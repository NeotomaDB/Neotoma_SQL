CREATE OR REPLACE FUNCTION ti.getdepenvtbyid(_depenvtid integer)
 RETURNS TABLE(depenvtid integer, depenvt character varying, depenvthigherid integer)
 LANGUAGE sql
AS $function$
SELECT depenvtid, depenvt, depenvthigherid
FROM ndb.depenvttypes
WHERE depenvtid = _depenvtid 
$function$
