CREATE OR REPLACE FUNCTION ti.getisosampleintrosystemtypes()
 RETURNS TABLE(isosampleintrosystemtypeid integer, isosampleintrosystemtype character varying)
 LANGUAGE sql
AS $function$
SELECT
  isosampleintrosystemtypeid, 
  isosampleintrosystemtype
FROM ndb.isosampleintrosystemtypes;
$function$
