CREATE OR REPLACE FUNCTION ts.validateusername(_username character varying)
	RETURNS integer
	LANGUAGE sql
AS $function$
	SELECT ss.contactid, ss.taxonomyexpert
	FROM  ti.stewards AS ss
	WHERE ss.username = _username
$function$;

create procedure [validateusername](@username nvarchar(15))
as
select     contactid, taxonomyexpert
from         ti.stewards
where     (username = @username)
