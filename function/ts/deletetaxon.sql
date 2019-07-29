CREATE OR REPLACE FUNCTION ts.deletetaxon(_taxonid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.taxaalthierarchy AS tah
  WHERE tah.highertaxonid = _taxonid;

  DELETE FROM ndb.taxa AS tx
  WHERE tx.taxonid = _taxonid;
$function$
