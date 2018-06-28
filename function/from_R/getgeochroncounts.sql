CREATE OR REPLACE FUNCTION ti.getgeochroncounts()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      top 
100
 percent ndb.geochrontypes.geochrontype, count
ndb.geochrontypes.geochrontype
 as count
 FROM ndb.geochronology inner join
                      ndb.geochrontypes on ndb.geochronology.geochrontypeid = ndb.geochrontypes.geochrontypeid
group by ndb.geochrontypes.geochrontype
order by count desc;
$function$