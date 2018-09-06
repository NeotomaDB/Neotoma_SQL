CREATE OR REPLACE FUNCTION ti.getecolsetsgroupsbytaxonid(_taxonid integer)
 RETURNS TABLE(taxonid integer, ecolsetid integer, ecolsetname character varying, ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.ecolgroups.taxonid, ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname, ndb.ecolgroups.ecolgroupid, 
                      ndb.ecolgrouptypes.ecolgroup
FROM ndb.ecolgroups INNER JOIN
	ndb.ecolsettypes ON ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid INNER JOIN
	ndb.ecolgrouptypes ON ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid
WHERE ndb.ecolgroups.taxonid = @taxonid
ORDER BY ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid
$function$
