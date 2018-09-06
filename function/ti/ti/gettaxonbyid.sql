CREATE OR REPLACE FUNCTION ti.gettaxonbyid(_taxonid integer)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname character varying, author character varying, valid smallint, highertaxonid integer, extinct smallint, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes character varying)
 LANGUAGE sql
AS $function$
select      tx.taxonid, 
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
from          ndb.taxa AS tx
where      (tx.taxonid = _taxonid)
$function$
