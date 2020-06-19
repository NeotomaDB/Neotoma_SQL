CREATE OR REPLACE FUNCTION ts.insertaggregatedataset(_name character varying, _ordertypeid integer, _notes text DEFAULT NULL::text)
 RETURNS TABLE(aggregatedatasetid integer)
 LANGUAGE sql
AS $function$

  INSERT INTO ndb.aggregatedatasets (aggregatedatasetname, aggregateordertypeid, notes, recdatecreated, recdatemodified)
  VALUES      (_name, _ordertypeid, _notes, now(), now())
  RETURNING aggregatedatasetid;
$function$
