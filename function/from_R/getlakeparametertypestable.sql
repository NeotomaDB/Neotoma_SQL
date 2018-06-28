CREATE OR REPLACE FUNCTION ti.getlakeparametertypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.lakeparametertypes;
$function$