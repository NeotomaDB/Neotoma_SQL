CREATE OR REPLACE FUNCTION ti.getisosampleintrosystemtypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isosampleintrosystemtypeid, isosampleintrosystemtype
 FROM ndb.isosampleintrosystemtypes;
$function$