CREATE OR REPLACE FUNCTION ti.getrelativeageunitsbyagescale(_relativeagescale character varying)
 RETURNS TABLE(relativeageunitid integer, relativeageunit character varying)
 LANGUAGE sql
AS $function$
select     rau.relativeageunitid, rau.relativeageunit
from          ndb.relativeagescales AS ras 
  inner join      ndb.relativeages AS ra  ON ras.relativeagescaleid = ra.relativeagescaleid 
  inner join  ndb.relativeageunits AS rau ON   ra.relativeageunitid = rau.relativeageunitid
WHERE (ras.relativeagescale = _relativeagescale)
GROUP BY 
  ras.relativeagescale, 
  rau.relativeageunitid, 
  rau.relativeageunit   

$function$
