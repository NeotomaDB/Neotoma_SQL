CREATE OR REPLACE FUNCTION ti.getdatasettaxonnotes(_datasetid integer)
 RETURNS TABLE(taxonid integer, taxonname text, notes text)
 LANGUAGE sql
AS $function$ 
SELECT ndb.datasettaxonnotes.taxonid, ndb.taxa.taxonname, ndb.datasettaxonnotes.notes
FROM ndb.datasettaxonnotes INNER JOIN ndb.taxa ON ndb.datasettaxonnotes.taxonid = ndb.taxa.taxonid
WHERE ndb.datasettaxonnotes.datasetid = _datasetid
$function$
