CREATE OR REPLACE FUNCTION ti.getinvalidtaxonbyname(_taxonname character varying)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname text, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes text)
 LANGUAGE sql
AS $function$


SELECT      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid,
               TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') AS validatedate, notes
FROM          ndb.taxa tx
WHERE      (valid = False) AND (tx.taxonname ILIKE _taxonname);

$function$
