CREATE OR REPLACE FUNCTION ti.gettaxabycodeandtaxagroupid(_taxoncode character varying, _taxagroupid character varying)
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
  TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') as validatedate,
  tx.notes
from 
  ndb.taxa AS tx
where
  tx.taxoncode = _taxoncode AND
  tx.taxagroupid = _taxagroupid

$function$
