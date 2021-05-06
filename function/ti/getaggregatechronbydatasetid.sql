CREATE OR REPLACE FUNCTION ti.getaggregatechronbydatasetid(_aggregatedatasetid integer)
 RETURNS TABLE(aggregatechronid integer, aggregatedatasetid integer, agetypeid integer, isdefault boolean, chronologyname character varying, ageboundyounger integer, ageboundolder integer, notes character varying)
 LANGUAGE sql
AS $function$

  SELECT aggregatechronid,
         aggregatedatasetid,
         agetypeid,
         isdefault,
         chronologyname,
         ageboundyounger,
         ageboundolder,
         notes
  FROM  ndb.aggregatechronologies
  WHERE aggregatedatasetid = _aggregatedatasetid

$function$
