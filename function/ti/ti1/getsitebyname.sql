CREATE OR REPLACE FUNCTION ti.getsitebyname(_sitename character varying)
 RETURNS TABLE(siteid integer, sitename character varying, geog character varying)
 LANGUAGE sql
AS $function$
select     st.siteid,
           st.sitename,
           ST_AsText(st.geog) as geog
from       ndb.sites AS st
where     st.sitename LIKE _sitename
$function$
