CREATE OR REPLACE FUNCTION ti.getlakeparametertypestable()
 RETURNS SETOF ndb.lakeparametertypes
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.lakeparametertypes;
$function$
