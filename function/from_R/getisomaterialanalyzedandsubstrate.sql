CREATE OR REPLACE FUNCTION ti.getisomaterialanalyzedandsubstrate()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      top 
100
 percent ndb.isomaterialanalyzedtypes.isomaterialanalyzedtype, ndb.isosubstratetypes.isosubstratetype
 FROM ndb.isomaterialanalyzedtypes inner join
                      ndb.isomatanalsubstrate on ndb.isomaterialanalyzedtypes.isomatanaltypeid = ndb.isomatanalsubstrate.isomatanaltypeid inner join
                      ndb.isosubstratetypes on ndb.isomatanalsubstrate.isosubstratetypeid = ndb.isosubstratetypes.isosubstratetypeid
order by ndb.isomaterialanalyzedtypes.isomaterialanalyzedtype, ndb.isosubstratetypes.isosubstratetype;
$function$