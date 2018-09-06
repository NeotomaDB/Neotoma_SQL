CREATE OR REPLACE FUNCTION ti.getsampleagesbychronid(_chronologyid integer)
 RETURNS TABLE(sampleid integer, age double precision, ageyounger double precision, ageolder double precision)
 LANGUAGE sql
AS $function$
select     sa.sampleid, sa.age, sa.ageyounger, sa.ageolder
from         ndb.sampleages AS sa
where     (chronologyid = _chronologyid)

$function$
