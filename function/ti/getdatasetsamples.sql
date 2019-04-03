CREATE OR REPLACE FUNCTION ti.getdatasetsamples(_datasetid integer)
 RETURNS TABLE(sampleid integer,
               samplename character varying,
               analysisdate character varying,
               labnumber character varying,
               preparationmethod text,
               samplenotes text,
               analysisunitid integer,
               analysisunitname character varying,
               depth double precision,
               thickness double precision,
               faciesid integer,
               facies character varying,
               mixed boolean,
               igsn character varying,
               analunitnotes text)
 LANGUAGE sql
AS $function$
SELECT smp.sampleid,
       smp.samplename,
       smp.analysisdate::varchar(10) AS analysisdate,
       smp.labnumber,
       smp.preparationmethod,
       smp.notes AS samplenotes,
       ayu.analysisunitid,
       ayu.analysisunitname,
	     ayu.depth,
       ayu.thickness,
       ayu.faciesid,
       fct.facies,
       ayu.mixed,
	     ayu.igsn,
       ayu.notes AS analunitnotes
FROM ndb.samples AS smp
  INNER JOIN    ndb.analysisunits AS ayu ON smp.analysisunitid = ayu.analysisunitid
  LEFT OUTER JOIN ndb.faciestypes AS fct ON       ayu.faciesid = fct.faciesid
WHERE smp.datasetid = _datasetid;
$function$
