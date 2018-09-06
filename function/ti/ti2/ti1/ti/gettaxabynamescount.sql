CREATE OR REPLACE FUNCTION ti.gettaxabynamescount(taxanames character varying)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$

SELECT count(tx.taxonid) AS count
from 
  ndb.taxa AS tx
where
  (tx.taxonname in (SELECT unnest(string_to_array(taxanames,'$'))))

$function$
