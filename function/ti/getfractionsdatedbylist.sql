CREATE OR REPLACE FUNCTION ti.getfractionsdatedbylist(_fractions character varying)
 RETURNS TABLE(fractionid integer, fraction character varying)
 LANGUAGE sql
AS $function$
SELECT       fd.fractionid, fd.fraction
FROM         ndb.fractiondated AS fd
WHERE       (fd.fraction IN (
		            SELECT unnest(string_to_array(_fractions,'$')
                    )))
$function$
