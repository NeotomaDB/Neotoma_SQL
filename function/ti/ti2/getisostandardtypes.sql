CREATE OR REPLACE FUNCTION ti.getisostandardtypes()
 RETURNS TABLE(isostandardtypeid integer, isostandardtype character varying, isostandardmaterial character varying)
 LANGUAGE sql
AS $function$
SELECT      isostandardtypeid, isostandardtype, isostandardmaterial
 FROM ndb.isostandardtypes;
$function$
