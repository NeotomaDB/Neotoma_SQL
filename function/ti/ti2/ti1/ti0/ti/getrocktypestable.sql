CREATE OR REPLACE FUNCTION ti.getrocktypestable()
 RETURNS TABLE(rocktypeid integer, rocktype character varying, higherrocktypeid integer, description text)
 LANGUAGE sql
AS $function$
SELECT       rocktypeid, rocktype, higherrocktypeid, description
 FROM ndb.rocktypes;
$function$
