CREATE OR REPLACE FUNCTION ti.getrelativeagestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       relativeageid, relativeageunitid, relativeagescaleid, relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes
 FROM ndb.relativeages;
$function$