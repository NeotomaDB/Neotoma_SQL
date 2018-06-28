CREATE OR REPLACE FUNCTION ti.getisosampleorigintypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isosampleorigintypeid, isosampleorigintype
 FROM ndb.isosampleorigintypes;
$function$