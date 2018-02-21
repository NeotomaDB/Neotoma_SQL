CREATE OR REPLACE FUNCTION ti.getdatasetsamples(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.samples.sampleid, ndb.samples.samplename, ndb.samples.analysisdate::varchar(10) AS analysisdate, ndb.samples.labnumber, 
       ndb.samples.preparationmethod, ndb.samples.notes AS samplenotes, ndb.analysisunits.analysisunitid, ndb.analysisunits.analysisunitname, 
	   ndb.analysisunits.depth, ndb.analysisunits.thickness, ndb.analysisunits.faciesid, ndb.faciestypes.facies, ndb.analysisunits.mixed, 
	   ndb.analysisunits.igsn, ndb.analysisunits.notes AS analunitnotes
FROM ndb.samples INNER JOIN
     ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid LEFT OUTER JOIN
     ndb.faciestypes ON ndb.analysisunits.faciesid = ndb.faciestypes.faciesid
WHERE NDB.Samples.DatasetID = _datasetid;
$$ LANGUAGE SQL;