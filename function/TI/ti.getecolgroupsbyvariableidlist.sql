CREATE OR REPLACE FUNCTION ti.getecolgroupsbyvariableidlist(_variableids text)
RETURNS TABLE(variableid int, taxagroupid varchar(3), ecolsetname varchar(64), ecolgroupid varchar(4))
AS $$
SELECT ndb.variables.variableid, ndb.taxa.taxagroupid, ndb.ecolsettypes.ecolsetname, ndb.ecolgrouptypes.ecolgroupid
FROM ndb.variables INNER JOIN
	ndb.taxa ON ndb.variables.taxonid = ndb.taxa.taxonid INNER JOIN
	ndb.ecolgroups ON ndb.taxa.taxonid = ndb.ecolgroups.taxonid INNER JOIN
	ndb.ecolgrouptypes ON ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid INNER JOIN
	ndb.ecolsettypes ON ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid
WHERE (ndb.variables.variableid IN (
	SELECT unnest(string_to_array(_variableids,'$'))::int
	))
$$ LANGUAGE SQL;