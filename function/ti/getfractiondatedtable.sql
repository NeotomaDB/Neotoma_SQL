CREATE OR REPLACE FUNCTION ti.getfractiondatedtable()
 RETURNS TABLE(fractionid integer, fraction character varying)
 LANGUAGE sql
AS $function$

select fractionid, fraction
from ndb.fractiondated

$function$
