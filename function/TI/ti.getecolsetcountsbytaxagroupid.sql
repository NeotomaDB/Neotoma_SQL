CREATE OR REPLACE FUNCTION ti.getecolsetcountsbytaxagroupid(_taxagroupid varchar(3))
RETURNS TABLE(ecolsetid int, ecolsetname varchar(64), count bigint)
AS $$
SELECT ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname, COUNT(*) AS count
FROM ndb.ecolgroups INNER JOIN
	ndb.taxa ON ndb.ecolgroups.taxonid = ndb.taxa.taxonid INNER JOIN
	ndb.ecolsettypes ON ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid
GROUP BY ndb.taxa.taxagroupid, ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname
HAVING ndb.taxa.taxagroupid = _taxagroupid
ORDER BY ndb.ecolsettypes.ecolsetname
$$ LANGUAGE SQL;