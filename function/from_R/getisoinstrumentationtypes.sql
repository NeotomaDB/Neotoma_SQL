CREATE OR REPLACE FUNCTION ti.getisoinstrumentationtypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isoinstrumentationtypeid, isoinstrumentationtype
 FROM ndb.isoinstrumentationtypes;
$function$