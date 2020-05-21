CREATE OR REPLACE FUNCTION ti.getgeopolnumberofsubdivs(_highergeopolid integer)
 RETURNS TABLE(numberofsubdivs integer)
 LANGUAGE sql
AS $function$
select count(geopoliticalid)::int as numberofsubdivs
from  ndb.geopoliticalunits AS gpu
group by gpu.highergeopoliticalid
having  gpu.highergeopoliticalid = $1
$function$
