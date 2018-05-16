CREATE OR REPLACE FUNCTION ti.getecolgrouptypestable()
RETURNS TABLE(ecolgroupid varchar(4), ecolgroup varchar(64))
AS $$
SELECT ecolgroupid, ecolgroup
FROM ndb.ecolgrouptypes
$$ LANGUAGE SQL;