CREATE OR REPLACE FUNCTION ti.getdatasetsamples(_datasetid integer)
 RETURNS TABLE(sampleid integer, samplename character varying, analysisdate character varying, labnumber character varying, preparationmethod text, samplenotes text, analysisunitid integer, analysisunitname character varying, depth double precision, thickness double precision, faciesid integer, facies character varying, mixed smallint, igsn character varying, analunitnotes text)
 LANGUAGE sql
AS $function$
SELECT ndb.samples.sampleid, ndb.samples.samplename, ndb.samples.analysisdate::varchar(10) AS analysisdate, ndb.samples.labnumber, 
       ndb.samples.preparationmethod, ndb.samples.notes AS samplenotes, ndb.analysisunits.analysisunitid, ndb.analysisunits.analysisunitname, 
	   ndb.analysisunits.depth, ndb.analysisunits.thickness, ndb.analysisunits.faciesid, ndb.faciestypes.facies, ndb.analysisunits.mixed, 
	   ndb.analysisunits.igsn, ndb.analysisunits.notes AS analunitnotes
FROM ndb.samples INNER JOIN
     ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid LEFT OUTER JOIN
     ndb.faciestypes ON ndb.analysisunits.faciesid = ndb.faciestypes.faciesid
WHERE NDB.Samples.DatasetID = _datasetid;
$function$
