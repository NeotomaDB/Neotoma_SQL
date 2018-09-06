CREATE OR REPLACE FUNCTION ti.getisomaterialanalyzedtypes()
 RETURNS TABLE(isomatanaltypeid integer, isomaterialanalyzedtype character varying)
 LANGUAGE sql
AS $function$
SELECT      isomatanaltypeid, isomaterialanalyzedtype
 FROM ndb.isomaterialanalyzedtypes;
$function$
