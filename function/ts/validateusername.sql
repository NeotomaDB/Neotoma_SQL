CREATE OR REPLACE FUNCTION ts.validateusername(_username character varying)
 RETURNS TABLE(contactid integer, taxonomyexpert boolean)
 LANGUAGE sql
AS $function$
    SELECT     contactid, taxonomyexpert
    FROM       ti.stewards
    WHERE     (username = _username)

$function$
