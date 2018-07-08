CREATE OR REPLACE FUNCTION ti.getaggregateordertypes()
 RETURNS TABLE(aggregateordertypeid integer, aggregateordertype text)
 LANGUAGE sql
AS $function$
SELECT      aggregateordertypeid, aggregateordertype
 FROM ndb.aggregateordertypes;
$function$
