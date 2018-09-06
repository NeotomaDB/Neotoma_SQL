CREATE OR REPLACE FUNCTION ti.getsampleage(_chronologyid integer, _sampleid integer)
 RETURNS TABLE(sampleageid integer, age double precision, ageyounger double precision, ageolder double precision)
 LANGUAGE sql
AS $function$
select     sa.sampleageid, sa.age, sa.ageyounger, sa.ageolder
from         ndb.sampleages AS sa
where     (sa.chronologyid = _chronologyid) AND (sa.sampleid = _sampleid)

$function$
