CREATE OR REPLACE FUNCTION ti.getalldatasetpis()
 RETURNS TABLE(contactname character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.contacts.contactname
FROM ndb.datasetpis INNER JOIN ndb.contacts ON ndb.datasetpis.contactid = ndb.contacts.contactid
GROUP BY ndb.contacts.contactname
ORDER BY ndb.contacts.contactname;
$function$
