CREATE OR REPLACE FUNCTION ti.getrelativeagebyname(_relativeage character varying)
 RETURNS TABLE(relativeageid integer, relativeageunitid integer, relativeagescaleid integer, relativeage character varying, c14ageyounger double precision, c14ageolder double precision, calageyounger double precision, calageolder double precision, notes character varying)
 LANGUAGE sql
AS $function$
select     ra.relativeageid,
		   ra.relativeageunitid,
		   ra.relativeagescaleid,
		   ra.relativeage,
		   ra.c14ageyounger,
		   ra.c14ageolder,
		   ra.calageyounger,
		   ra.calageolder,
		   ra.notes
from       ndb.relativeages as ra
where      ra.relativeage ILIKE _relativeage
$function$
