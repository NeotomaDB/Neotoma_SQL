CREATE OR REPLACE FUNCTION ti.getecolgroupsbyecolsetid(_ecolsetid integer)
 RETURNS TABLE(ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
FROM ndb.ecolgrouptypes INNER JOIN
	ndb.ecolgroups ON ndb.ecolgrouptypes.ecolgroupid = ndb.ecolgroups.ecolgroupid
GROUP BY ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
HAVING ndb.ecolgroups.ecolsetid = _ecolsetid
ORDER BY ndb.ecolgroups.ecolgroupid
$function$
