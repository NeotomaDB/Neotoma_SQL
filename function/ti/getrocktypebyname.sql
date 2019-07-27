CREATE OR REPLACE FUNCTION ti.getrocktypebyname(_rocktype character varying)
 RETURNS TABLE(rocktypeid integer, rocktype character varying, higherrocktypeid integer, description character varying)
 LANGUAGE sql
AS $function$
select     rt.rocktypeid, rt.rocktype, rt.higherrocktypeid, rt.description
from       ndb.rocktypes as rt
where      rocktype = _rocktype
$function$
