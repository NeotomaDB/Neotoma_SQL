CREATE OR REPLACE FUNCTION ti.getecolgroupstable()
RETURNS TABLE(taxonid int, ecolsetid int, ecolgroupid varchar(4))
AS $$
SELECT taxonid, ecolsetid, ecolgroupid
FROM ndb.ecolgroups 
$$ LANGUAGE SQL;