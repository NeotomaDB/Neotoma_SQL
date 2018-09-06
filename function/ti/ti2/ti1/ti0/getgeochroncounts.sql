CREATE OR REPLACE FUNCTION ti.getgeochroncounts()
 RETURNS TABLE(geochrontype character varying, count integer)
 LANGUAGE sql
AS $function$

SELECT   gt.geochrontype, COUNT(gt.geochrontype)::integer AS count
FROM     ndb.geochronology gc INNER JOIN
         ndb.geochrontypes gt ON gc.geochrontypeid = gt.geochrontypeid
GROUP BY gt.geochrontype
ORDER BY count DESC

$function$
