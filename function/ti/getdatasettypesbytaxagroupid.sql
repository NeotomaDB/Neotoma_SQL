CREATE OR REPLACE FUNCTION ti.getdatasettypesbytaxagroupid(_taxagroupid character varying)
 RETURNS TABLE(datasettypeid integer, datasettype character varying)
 LANGUAGE sql
AS $function$ 
SELECT ndb.datasettaxagrouptypes.datasettypeid, ndb.datasettypes.datasettype
FROM ndb.datasettaxagrouptypes INNER JOIN
		ndb.datasettypes on ndb.datasettaxagrouptypes.datasettypeid = ndb.datasettypes.datasettypeid
WHERE ndb.datasettaxagrouptypes.taxagroupid = _taxagroupid
$function$
