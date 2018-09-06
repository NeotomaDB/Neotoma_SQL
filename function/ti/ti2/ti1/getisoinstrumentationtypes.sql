CREATE OR REPLACE FUNCTION ti.getisoinstrumentationtypes()
 RETURNS TABLE(isoinstrumentationtypeid integer, isoinstrumentationtype character varying)
 LANGUAGE sql
AS $function$
select
	iit.isoinstrumentationtypeid,
	iit.isoinstrumentationtype
from ndb.isoinstrumentationtypes AS iit;
$function$
