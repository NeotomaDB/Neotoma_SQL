CREATE OR REPLACE FUNCTION ti.getdepenvttypestable()
 RETURNS TABLE(depenvtid integer, depenvt character varying, depenvthigherid integer)
 LANGUAGE sql
AS $function$
SELECT depenvtid, depenvt, depenvthigherid
FROM ndb.depenvttypes
$function$
