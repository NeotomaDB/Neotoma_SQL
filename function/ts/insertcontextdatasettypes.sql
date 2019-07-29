CREATE OR REPLACE FUNCTION ts.insertcontextdatasettypes(_datasettypeid integer, _variablecontextid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.contextsdatasettypes(datasettypeid, variablecontextid)
VALUES (_datasettypeid, _variablecontextid)
$function$
