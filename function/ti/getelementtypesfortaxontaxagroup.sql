CREATE OR REPLACE FUNCTION ti.getelementtypesfortaxontaxagroup(_taxonid int)
RETURNS TABLE(elementtypeid int, elementtype varchar(64))
AS $$

SELECT ndb.elementtypes.elementtypeid, ndb.elementtypes.elementtype
FROM ndb.elementtypes INNER JOIN
	ndb.elementtaxagroups ON ndb.elementtypes.elementtypeid = ndb.elementtaxagroups.elementtypeid INNER JOIN
	ndb.taxa ON ndb.elementtaxagroups.taxagroupid = ndb.taxa.taxagroupid
WHERE ndb.taxa.taxonid = $1

$$ LANGUAGE SQL;


