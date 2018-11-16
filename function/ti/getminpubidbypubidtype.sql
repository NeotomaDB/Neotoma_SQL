CREATE OR REPLACE FUNCTION ti.getminpubidbypubidtype(_pubtypeid integer)
 RETURNS TABLE(minpubid integer)
 LANGUAGE sql
 AS $function$

 SELECT     min(pub.publicationid) as minpubid
 FROM       ndb.publications as pub
 GROUP BY 	pub.pubtypeid
 HAVING     pub.pubtypeid = _pubtypeid

$function$
