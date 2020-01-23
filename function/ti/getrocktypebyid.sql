CREATE OR REPLACE FUNCTION ti.getrocktypebyid(_rocktypeid integer)
 RETURNS TABLE(rocktypeid integer, rocktype character varying, higherrocktypeid integer, description character varying)
 LANGUAGE sql
AS $function$

SELECT
	rt.rocktypeid,
	rt.rocktype,
	rt.higherrocktypeid,
	rt.description
FROM      ndb.rocktypes as rt
WHERE     rt.rocktypeid = _rocktypeid

$function$
