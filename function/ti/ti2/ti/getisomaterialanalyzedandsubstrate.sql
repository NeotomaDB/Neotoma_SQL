CREATE OR REPLACE FUNCTION ti.getisomaterialanalyzedandsubstrate()
 RETURNS TABLE(isomaterialanalyzedtype character varying, isosubstratetype character varying)
 LANGUAGE sql
AS $function$
SELECT
	imat.isomaterialanalyzedtype,
	ist.isosubstratetype
  FROM   ndb.isomaterialanalyzedtypes AS imat
  INNER JOIN ndb.isomatanalsubstrate AS iss  ON imat.isomatanaltypeid  = iss.isomatanaltypeid
  INNER JOIN   ndb.isosubstratetypes AS ist  ON iss.isosubstratetypeid = ist.isosubstratetypeid
order by imat.isomaterialanalyzedtype, ist.isosubstratetype;
$function$
