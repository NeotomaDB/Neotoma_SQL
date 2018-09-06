CREATE OR REPLACE FUNCTION ti.getfractionsdatedbylist(_fractions character varying)
 RETURNS TABLE(fractionid integer,
			   fraction character varying)
 LANGUAGE sql
AS $function$
select       fd.fractionid, fd.fraction
from         ndb.fractiondated as fd
where       (fd.fraction in (
		            select unnest(string_to_array(_fractions,'$')
                    )))
$function$
