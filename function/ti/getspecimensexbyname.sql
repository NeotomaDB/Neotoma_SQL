CREATE OR REPLACE FUNCTION ti.getspecimensexbyname(_sex character varying)
 RETURNS TABLE(sexid integer, sex character varying)
 LANGUAGE sql
AS $function$

SELECT
	sst.sexid,
	sst.sex
FROM       ndb.specimensextypes AS sst
WHERE      sst.sex ILIKE _sex

$function$
