CREATE OR REPLACE FUNCTION ti.getisosubstrates()
 RETURNS TABLE(isosubstratetypeid integer, isomatanaltypeid integer, isosubstratetype character varying)
 LANGUAGE sql
AS $function$
SELECT
  ist.isosubstratetypeid, 
  imat.isomatanaltypeid, 
  ist.isosubstratetype
 FROM   ndb.isomaterialanalyzedtypes AS imat
  INNER JOIN ndb.isomatanalsubstrate AS iss   ON imat.isomatanaltypeid = iss.isomatanaltypeid
  INNER JOIN   ndb.isosubstratetypes AS ist  ON iss.isosubstratetypeid = ist.isosubstratetypeid
order by ist.isosubstratetypeid;
$function$
