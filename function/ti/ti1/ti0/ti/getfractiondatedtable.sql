CREATE OR REPLACE FUNCTION ti.getfractiondatedtable()
 RETURNS ndb.fractiondated
 LANGUAGE sql
AS $function$

select      ndb.fractiondated.*
from          ndb.fractiondated


$function$
