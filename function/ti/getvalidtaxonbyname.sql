CREATE OR REPLACE FUNCTION ti.getvalidtaxonbyname(_taxonname character varying)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname text, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes character varying)
 LANGUAGE sql
AS $function$
  SELECT
  	tx.taxonid,
	tx.taxoncode,
	tx.taxonname,
	tx.author,
	tx.valid,
	tx.highertaxonid,
	tx.extinct,
	tx.taxagroupid,
	tx.publicationid,
	tx.validatorid,
	TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') AS validatedate,
	tx.notes
  FROM ndb.taxa AS tx
  WHERE (tx.valid = True) AND (tx.taxonname ILIKE $1)
$function$
