CREATE OR REPLACE FUNCTION ti.getlakeparamsbysiteid(_siteid integer) 
 RETURNS TABLE(lakeparameter character varying,
			  value double precision)
 LANGUAGE sql
AS $function$
select     lpt.lakeparameter,
		   lp.value
from       ndb.lakeparameters as lp
	inner join ndb.lakeparametertypes as lpt on lp.lakeparameterid = lpt.lakeparameterid
where     (lp.siteid = _siteid)
$function$
