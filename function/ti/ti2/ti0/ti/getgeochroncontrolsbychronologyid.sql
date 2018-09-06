CREATE OR REPLACE FUNCTION ti.getgeochroncontrolsbychronologyid(_chronologyid integer)
 RETURNS TABLE(chroncontrolid integer, geochronid integer)
 LANGUAGE sql
AS $function$

select     ndb.geochroncontrols.chroncontrolid, ndb.geochroncontrols.geochronid
from       ndb.geochroncontrols inner join
           ndb.chroncontrols on ndb.geochroncontrols.chroncontrolid = ndb.chroncontrols.chroncontrolid
where     (ndb.chroncontrols.chronologyid = _chronologyid)

$function$
