CREATE OR REPLACE FUNCTION getspecimenisotopedata(_datasetid integer)
RETURNS TABLE (
  specimenid integer,
  analysisunit character varying,
  depth text,
  thickness text,
  taxon character varying,
  element text,
  variable character varying,
  units character varying,
  value double precision,
  sd text,
  materialanalyzed character varying,
  substrate character varying,
  pretreatments text,
  analyst character varying,
  lab character varying,
  labnumber text,
  mass_mg text,
  weightpercent text,
  atomicpercent text,
  reps text
)
LANGUAGE sql
AS $function$
WITH speciesiso AS (
  SELECT
    dt.dataid,
    spec.specimenid,
    au.analysisunitname as "analysis unit",
    COALESCE(au.depth::text, '') as depth,
    COALESCE(au.thickness::text, '') as thickness,
    txb.taxonname as taxon,
    REGEXP_REPLACE(
    REGEXP_REPLACE(
      CONCAT(et.elementtype, ';',
         es.symmetry, ';',
         ep.portion, ';',
         em.maturity, ';'),
      '(;){2,}', ';'),
    ';$', '') AS element,
    tx.taxonname as variable,
    varu.variableunits as units,
    dt.value,
  COALESCE(isd.sd::text, '') as sd,
    COALESCE(iman.isomaterialanalyzedtype, '') as "material analyzed",
  COALESCE(ist.isosubstratetype, '') as substrate,
  COALESCE(ct.contactname, '') as analyst,
  COALESCE(imd.lab, '') as lab,
  COALESCE(imd.labnumber::text, '') as "lab number",
  COALESCE(imd.mass_mg::text, '') as "mass (mg)",
  COALESCE(imd.weightpercent::text, '') as "weight %",
  COALESCE(imd.atomicpercent::text, '') as "atomic %",
  COALESCE(imd.reps::text, '') as reps
  FROM
    ndb.datasets AS ds
    inner join                       ndb.samples AS smp  on ds.datasetid = smp.datasetid
    inner join                          ndb.data AS dt   on smp.sampleid = dt.sampleid
    inner join                     ndb.variables AS var  on dt.variableid = var.variableid
    inner join                          ndb.taxa AS tx   ON var.taxonid = tx.taxonid
    inner join                 ndb.variableunits AS varu ON var.variableunitsid = varu.variableunitsid
    inner join               ndb.isospecimendata AS isd  ON dt.dataid = isd.dataid
    inner join                     ndb.specimens AS spec on isd.specimenid = spec.specimenid
    inner join                          ndb.data AS dtb  on spec.dataid = dtb.dataid
    inner join                     ndb.variables AS varb on dtb.variableid = varb.variableid
    inner join                          ndb.taxa AS txb  on varb.taxonid = txb.taxonid
    inner join                 ndb.analysisunits AS au   on smp.analysisunitid = au.analysisunitid
    inner join                   ndb.isometadata AS imd  on dt.dataid = imd.dataid
    left outer join                 ndb.contacts AS ct   on imd.analystid = ct.contactid
    left outer join        ndb.isosubstratetypes AS ist  on imd.isosubstratetypeid = ist.isosubstratetypeid
    left outer join ndb.isomaterialanalyzedtypes AS iman on imd.isomatanaltypeid = iman.isomatanaltypeid
    left outer join          ndb.elementportions AS ep   on spec.portionid = ep.portionid
    left outer join             ndb.elementtypes AS et   on spec.elementtypeid = et.elementtypeid
    left outer join        ndb.elementsymmetries AS es   on spec.symmetryid = es.symmetryid
    left outer join        ndb.elementmaturities AS em   on spec.maturityid = em.maturityid
  where     (ds.datasetid = _datasetid)
  order by
    spec.specimenid,
    tx.taxonname
  ),
  pretreatments AS (
    SELECT
      dt.dataid,
      REGEXP_REPLACE(STRING_AGG(ipt.isopretreatmenttype || ', ' ||
                ipt.isopretreatmentqualifier || ', ' || isp.value::text,
                          ';' ORDER BY isp.order),
           ', , ', ', ') AS samplepretreatment
    FROM
      ndb.isopretreatmenttypes AS ipt
      INNER JOIN ndb.isosamplepretreatments AS isp ON ipt.isopretreatmenttypeid = isp.isopretreatmenttypeid
      INNER JOIN ndb.data AS dt ON isp.dataid = dt.dataid
      INNER JOIN ndb.samples AS smp ON smp.sampleid = dt.sampleid
      RIGHT OUTER JOIN ndb.datasets AS ds ON ds.datasetid = smp.datasetid
    WHERE     (ds.datasetid = _datasetid)
  GROUP BY dt.dataid
  )

  SELECT
    si.specimenid,
    si."analysis unit",
    si.depth,
    si.thickness,
    si.taxon,
    si.element,
    si.variable,
    si.units,
    si.value,
    si.sd,
    si."material analyzed",
    si.substrate,
    pt.samplepretreatment,
    si.analyst,
    si.lab,
    si."lab number",
    si."mass (mg)",
    si."weight %",
    si."atomic %",
    si.reps
  FROM  speciesiso AS si
    LEFT OUTER JOIN pretreatments AS pt ON si.dataid = pt.dataid
  ORDER BY si.specimenid, si.variable

$function$
