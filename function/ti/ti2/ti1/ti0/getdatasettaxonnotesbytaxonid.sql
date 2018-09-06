CREATE OR REPLACE FUNCTION ti.getdatasettaxonnotesbytaxonid(_datasetid integer, _taxonid integer)
 RETURNS TABLE(taxonid integer, taxonname character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.datasettaxonnotes.taxonid, ndb.taxa.taxonname, ndb.datasettaxonnotes.notes
FROM ndb.datasettaxonnotes INNER JOIN ndb.taxa ON ndb.datasettaxonnotes.taxonid = ndb.taxa.taxonid
WHERE ndb.datasettaxonnotes.datasetid = _datasetid AND ndb.datasettaxonnotes.taxonid = _taxonid
$function$
