CREATE OR REPLACE FUNCTION ti.getsampleidfordatasettypeidfromgeochronanalunit(_geochronid integer, _datasettypeid integer)
 RETURNS TABLE(sampleid integer)
 LANGUAGE sql
AS $function$

SELECT samples_1.sampleid
FROM ndb.geochronology INNER JOIN
	ndb.samples ON ndb.geochronology.sampleid = ndb.samples.sampleid INNER JOIN
	ndb.samples as samples_1 ON ndb.samples.analysisunitid = samples_1.analysisunitid INNER JOIN
	ndb.datasets ON samples_1.datasetid = ndb.datasets.datasetid
WHERE (ndb.geochronology.geochronid = _geochronid) AND (ndb.datasets.datasettypeid = _datasettypeid)

$function$
