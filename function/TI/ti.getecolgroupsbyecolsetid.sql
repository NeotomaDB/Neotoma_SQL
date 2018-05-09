CREATE OR REPLACE FUNCTION ti.getecolgroupsbyecolsetid(_ecolsetid int)
RETURNS TABLE(ecolgroupid varchar(4), ecolgroup varchar(64))
AS $$
SELECT ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
FROM ndb.ecolgrouptypes INNER JOIN
	ndb.ecolgroups ON ndb.ecolgrouptypes.ecolgroupid = ndb.ecolgroups.ecolgroupid
GROUP BY ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
HAVING ndb.ecolgroups.ecolsetid = _ecolsetid
ORDER BY ndb.ecolgroups.ecolgroupid
$$ LANGUAGE SQL;