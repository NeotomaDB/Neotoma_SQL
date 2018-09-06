CREATE OR REPLACE FUNCTION ti.getdatasetsbyid(_datasets text)
 RETURNS TABLE(datasetid integer, collectionunitid integer, datasettypeid integer, datasettype character varying, datasetname character varying, notes text)
 LANGUAGE sql
AS $function$ 
SELECT ndb.datasets.datasetid, ndb.datasets.collectionunitid, ndb.datasets.datasettypeid, ndb.datasettypes.datasettype,
		ndb.datasets.datasetname, ndb.datasets.notes
FROM ndb.datasets INNER JOIN 
		ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
WHERE (datasetid IN (
		SELECT unnest(string_to_array(_datasets,'$'))::int
		))
$function$
