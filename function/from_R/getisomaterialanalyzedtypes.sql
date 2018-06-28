CREATE OR REPLACE FUNCTION ti.getisomaterialanalyzedtypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isomatanaltypeid, isomaterialanalyzedtype
 FROM ndb.isomaterialanalyzedtypes;
$function$