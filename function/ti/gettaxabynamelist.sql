CREATE OR REPLACE FUNCTION ti.gettaxabynamelist(_taxanames text)
 RETURNS integer
 LANGUAGE sql
AS $function$
	select 1
$function$
