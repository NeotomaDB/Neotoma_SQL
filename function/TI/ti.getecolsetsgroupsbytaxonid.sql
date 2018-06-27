CREATE OR REPLACE FUNCTION ti.getecolsetsgroupsbytaxonid(_taxonid int)
RETURNS TABLE(taxonid int, ecolsetid int, ecolsetname varchar(64), ecolgroupid varchar(4), ecolgroup varchar(64))
AS $$
SELECT ndb.ecolgroups.taxonid, ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname, ndb.ecolgroups.ecolgroupid, 
                      ndb.ecolgrouptypes.ecolgroup
FROM ndb.ecolgroups INNER JOIN
	ndb.ecolsettypes ON ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid INNER JOIN
	ndb.ecolgrouptypes ON ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid
WHERE ndb.ecolgroups.taxonid = @taxonid
ORDER BY ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid
$$ LANGUAGE SQL;