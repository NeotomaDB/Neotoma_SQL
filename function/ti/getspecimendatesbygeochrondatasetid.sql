CREATE OR REPLACE FUNCTION ti.getspecimendatesbygeochrondatasetid(_geochrondatasetid integer)
 RETURNS TABLE(specimendateid integer, specimenid integer, geochronid integer, sampleid integer, taxonname text, elementtype character varying, fraction character varying, notes character varying, calage double precision, calageolder double precision, calageyounger double precision, calibrationcurve character varying, calibrationprogram character varying, version character varying)
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
  WHERE smp.datasetid = _geochrondatasetid
$function$
