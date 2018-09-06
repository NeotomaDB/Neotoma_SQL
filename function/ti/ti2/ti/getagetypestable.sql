CREATE OR REPLACE FUNCTION ti.getagetypestable()
 RETURNS SETOF ndb.agetypes
 LANGUAGE sql
AS $function$SELECT ndb.agetypes.* FROM ndb.agetypes;$function$
