CREATE OR REPLACE FUNCTION ti.getaggregatedatasetbyname(name character varying)
 RETURNS TABLE(aggregatedatasetid integer, aggregatedatasetname character varying, aggregateordertypeid integer, notes text)
 LANGUAGE sql
AS $function$

SELECT     aggregatedatasetid, aggregatedatasetname, aggregateordertypeid, notes
FROM       ndb.aggregatedatasets
WHERE     (aggregatedatasetname ILIKE $1)

$function$
