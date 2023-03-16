CREATE OR REPLACE FUNCTION ti.gettaxalookupsynonymybytaxagroupidlist(_taxagrouplist character varying)
 RETURNS TABLE(taxonid integer, taxonname text, validtaxonid integer)
 LANGUAGE sql
AS $function$

SELECT tx.taxonid,
       tx.taxonname,
		   sy.validtaxonid
FROM
  ndb.taxa AS tx
  inner join ndb.synonyms AS sy on tx.taxonid = sy.invalidtaxonid
WHERE
  tx.valid = False AND
  (LOWER(tx.taxagroupid) in (SELECT unnest(string_to_array(LOWER($1),'$'))))

$function$
