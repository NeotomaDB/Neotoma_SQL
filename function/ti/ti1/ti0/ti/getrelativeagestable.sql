CREATE OR REPLACE FUNCTION ti.getrelativeagestable()
 RETURNS TABLE(relativeageid integer, relativeageunitid integer, relativeagescaleid integer, relativeage character varying, c14ageyounger double precision, c14ageolder double precision, calageyounger double precision, calageolder double precision, notes text)
 LANGUAGE sql
AS $function$
SELECT       relativeageid, relativeageunitid, relativeagescaleid, relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes
 FROM ndb.relativeages;
$function$
