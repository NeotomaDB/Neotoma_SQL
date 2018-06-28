CREATE OR REPLACE FUNCTION ti.getisostandardtypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isostandardtypeid, isostandardtype, isostandardmaterial
 FROM ndb.isostandardtypes;
$function$