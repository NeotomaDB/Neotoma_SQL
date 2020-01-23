CREATE OR REPLACE FUNCTION ti.getspecimenbyidcount(_specimenid int)
RETURNS TABLE(count bigint)
LANGUAGE sql
AS $function$

	SELECT COUNT(*) AS count
	FROM ndb.specimens
	WHERE specimenid = $1

$function$