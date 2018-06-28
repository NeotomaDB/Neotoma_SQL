CREATE OR REPLACE FUNCTION ti.getrocktypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       rocktypeid, rocktype, higherrocktypeid, description
 FROM ndb.rocktypes;
$function$