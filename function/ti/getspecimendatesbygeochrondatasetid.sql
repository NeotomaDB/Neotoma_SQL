CREATE OR REPLACE FUNCTION ti.getspecimendatesbygeochrondatasetid(_geochronid integer)
 RETURNS TABLE(specimentdateid integer,
                    specimenid integer,
    geochronid integer,
    sampleid integer,
    taxonname varchar,
    elementtype varchar,
    fraction varchar,
    notes varchar,
    calage double precision,
    calageolder double precision,
    calageyounger double precision,
    calibrationcurve varchar,
    calibrationprogram varchar,
    version varchar)
LANGUAGE sql
AS $function$
  SELECT sdt.specimendateid,
       sdt.specimenid,
  	   sdt.geochronid,
  	   sdt.sampleid,
  	   txa.taxonname,
       ety.elementtype,
  	   fdt.fraction,
  	   sdt.notes,
  	   sdc.calage,
  	   sdc.calageolder,
  	   sdc.calageyounger,
  	   cc.calibrationcurve,
  	   cp.calibrationprogram,
  	   cp.version
  FROM   ndb.samples as smp
    INNER JOIN ndb.geochronology  as gcn on smp.sampleid = gcn.sampleid
    INNER JOIN ndb.specimendates as sdt on gcn.geochronid = sdt.geochronid
    INNER JOIN ndb.taxa as txa on sdt.taxonid = txa.taxonid
    LEFT OUTER JOIN ndb.fractiondated as fdt on sdt.fractionid = fdt.fractionid
    LEFT OUTER JOIN ndb.elementtypes as ety on sdt.elementtypeid = ety.elementtypeid
    LEFT OUTER JOIN ndb.specimendatescal AS sdc ON sdc.specimendateid =sdt.specimendateid
    LEFT OUTER JOIN ndb.calibrationprograms AS cp ON cp.calibrationprogramid = sdc.calibrationprogramid
    LEFT OUTER JOIN ndb.calibrationcurves AS cc ON cc.calibrationcurveid = sdc.calibrationcurveid
  WHERE gcn.geochronid = _geochronid
$function$
