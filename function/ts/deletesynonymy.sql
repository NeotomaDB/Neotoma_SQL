CREATE OR REPLACE FUNCTION ts.deletesynonymy(_synonymyid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.synonymy AS sy
  WHERE sy.synonymyid = _synonymyid;
$function$
