CREATE OR REPLACE FUNCTION ti.getdatasettaxonnotesbytaxonid(_datasetid integer, _taxonid integer)
 RETURNS TABLE(taxonid integer, taxonname character varying, notes text)
 LANGUAGE sql
AS $function$
  SELECT dtn.taxonid,
         tx.taxonname,
         dtn.notes
  FROM ndb.datasettaxonnotes AS dtn
    INNER JOIN      ndb.taxa AS tx ON dtn.taxonid = tx.taxonid
  WHERE dtn.datasetid = _datasetid
    AND dtn.taxonid = _taxonid
$function$
