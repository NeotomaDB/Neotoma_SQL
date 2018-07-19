CREATE OR REPLACE FUNCTION ti.getisomaterialanalyzedandsubstrate()
RETURNS TABLE(isomaterialanalyzedtype, isosubstratetype)
LANGUAGE SQL
AS $function$
SELECT  imat.isomaterialanalyzedtype, ist.isosubstratetype
 FROM ndb.isomaterialanalyzedtypes AS imat
 INNER JOIN ndb.isomatanalsubstrate AS imas ON imat.isomatanaltypeid = imas.isomatanaltypeid
 INNER JOIN ndb.isosubstratetypes AS ist ON imas.isosubstratetypeid = ist.isosubstratetypeid
ORDER BY imat.isomaterialanalyzedtype, ist.isosubstratetype;
$function$
