CREATE OR REPLACE FUNCTION ti.gettaxalookupsynonymybytaxagroupidlist(taxagrouplist character varying)
 RETURNS TABLE(taxonid integer, taxonname character varying, validtaxonid integer)
 LANGUAGE sql
AS $function$

SELECT tx.taxonid, 
        tx.taxonname, 
		sy.validtaxonid
from 
  ndb.taxa AS tx
  inner join ndb.synonyms AS sy on tx.taxonid = sy.invalidtaxonid
where      
  tx.valid = 0 AND 
  (tx.taxagroupid in (SELECT unnest(string_to_array(taxagrouplist,'$'))))

$function$
