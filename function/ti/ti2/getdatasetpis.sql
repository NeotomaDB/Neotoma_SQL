CREATE OR REPLACE FUNCTION ti.getdatasetpis(_datasetid integer)
 RETURNS TABLE(piorder integer, familyname character varying, leadinginitials character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.datasetpis.piorder, ndb.contacts.familyname, ndb.contacts.leadinginitials
FROM ndb.datasetpis INNER JOIN ndb.contacts ON ndb.datasetpis.contactid = ndb.contacts.contactid
WHERE ndb.datasetpis.datasetid = _datasetid;
$function$
