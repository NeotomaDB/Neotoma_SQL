CREATE OR REPLACE FUNCTION ti.getinvalidtaxonbyname(_taxonname character varying)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname character varying, author character varying, valid smallint, highertaxonid integer, extinct smallint, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes text)
 LANGUAGE sql
AS $function$


SELECT      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid, 
               TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') AS validatedate, notes
FROM          NDB.Taxa tx
WHERE      (valid = 0) AND (tx.taxonname ilike _taxonname);

$function$