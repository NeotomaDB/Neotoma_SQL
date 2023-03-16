CREATE OR REPLACE FUNCTION ti.gettaxabytaxagroupid(_taxagroupid character varying)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname text, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes character varying)
 LANGUAGE sql
AS $function$
select tx.taxonid, 
        tx.taxoncode, 
		tx.taxonname, 
		tx.author, 
		tx.valid, 
		tx.highertaxonid, 
		tx.extinct, 
		tx.taxagroupid, 
		tx.publicationid, 
		tx.validatorid,
        TO_CHAR(validatedate, 'YYYY-MM-DD HH:MI:SS') as validatedate, 
		tx.notes
from          ndb.taxa AS tx
where      tx.taxagroupid = _taxagroupid

$function$
