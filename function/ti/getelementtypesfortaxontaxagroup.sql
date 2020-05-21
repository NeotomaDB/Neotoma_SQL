CREATE OR REPLACE FUNCTION ti.getelementtypesfortaxontaxagroup(_taxonid integer)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$

SELECT ndb.elementtypes.elementtypeid, ndb.elementtypes.elementtype
FROM ndb.elementtypes INNER JOIN
	ndb.elementtaxagroups ON ndb.elementtypes.elementtypeid = ndb.elementtaxagroups.elementtypeid INNER JOIN
	ndb.taxa ON ndb.elementtaxagroups.taxagroupid = ndb.taxa.taxagroupid
WHERE ndb.taxa.taxonid = $1

$function$
