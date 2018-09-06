CREATE OR REPLACE FUNCTION ti.getalldatasetauthors()
 RETURNS TABLE(contactname character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.contacts.contactname
FROM ndb.datasetpublications INNER JOIN
ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid INNER JOIN
ndb.publicationauthors ON ndb.publications.publicationid = ndb.publicationauthors.publicationid INNER JOIN
ndb.contacts ON ndb.publicationauthors.contactid = ndb.contacts.contactid
GROUP BY ndb.contacts.contactname
ORDER BY ndb.contacts.contactname;
$function$
