CREATE OR REPLACE FUNCTION ts.insertunitsdatasettypes(
  _datasettypeid integer,
  _variableunitsid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.unitsdatasettypes(datasettypeid, variableunitsid)
  VALUES (_datasettypeid, _variableunitsid)
$function$;
