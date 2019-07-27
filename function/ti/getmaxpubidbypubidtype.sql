CREATE OR REPLACE FUNCTION ti.getmaxpubidbypubidtype(_pubtypeid integer)
 RETURNS TABLE(maxpubid integer)
 LANGUAGE sql
AS $function$

 SELECT     MAX(pub.publicationid) AS maxpubid
 FROM       ndb.publications AS pub
 GROUP BY	  pub.pubtypeid
 HAVING     pub.pubtypeid = _pubtypeid

$function$
