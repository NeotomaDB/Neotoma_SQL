CREATE OR REPLACE FUNCTION ti.getaggregateordertypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      aggregateordertypeid, aggregateordertype
 FROM ndb.aggregateordertypes;
$function$