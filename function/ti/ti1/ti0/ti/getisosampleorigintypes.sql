CREATE OR REPLACE FUNCTION ti.getisosampleorigintypes()
 RETURNS TABLE(isosampleorigintypeid integer, isosampleorigintype character varying)
 LANGUAGE sql
AS $function$
SELECT      isosampleorigintypeid, isosampleorigintype
 FROM ndb.isosampleorigintypes;
$function$
