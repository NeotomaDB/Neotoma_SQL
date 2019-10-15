CREATE OR REPLACE FUNCTION ti.gettaxabynamescount(_taxanames character varying)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$

SELECT count(tx.taxonid) AS count
from
  ndb.taxa AS tx
where
  (LOWER(tx.taxonname) in (SELECT unnest(string_to_array(LOWER($1),'$'))))

$function$
