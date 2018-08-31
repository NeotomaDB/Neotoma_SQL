CREATE OR REPLACE FUNCTION ti.getgeopolnumberofsubdivs(_highergeopolid integer)
 RETURNS TABLE (higherpoliticalid bigint)
 LANGUAGE sql
as $function$
select      count(geopoliticalid) as numberofsubdivs
from          ndb.geopoliticalunits AS gpu
group by gpu.highergeopoliticalid
having       (gpu.highergeopoliticalid = _highergeopolid)
$function$
