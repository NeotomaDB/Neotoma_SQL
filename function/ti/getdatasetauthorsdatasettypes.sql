CREATE OR REPLACE FUNCTION ti.getdatasetauthorsdatasettypes(_datasettypeidlist character varying)
 RETURNS TABLE(contactid integer, datasettypeid integer, datasetid integer, contactname character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
	IF _datasettypeidlist IS NULL THEN
		RETURN QUERY
		SELECT ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
		FROM ndb.datasets INNER JOIN
			ndb.datasetpublications ON ndb.datasets.datasetid = ndb.datasetpublications.datasetid INNER JOIN
				   ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid INNER JOIN
				   ndb.publicationauthors ON ndb.publications.publicationid = ndb.publicationauthors.publicationid INNER JOIN
				   ndb.contacts ON ndb.publicationauthors.contactid = ndb.contacts.contactid
		GROUP BY ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname;
	ELSE
		RETURN QUERY
		SELECT ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
		FROM ndb.datasets INNER JOIN
			ndb.datasetpublications ON ndb.datasets.datasetid = ndb.datasetpublications.datasetid INNER JOIN
				   ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid INNER JOIN
				   ndb.publicationauthors ON ndb.publications.publicationid = ndb.publicationauthors.publicationid INNER JOIN
				   ndb.contacts ON ndb.publicationauthors.contactid = ndb.contacts.contactid
		GROUP BY ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
		HAVING ndb.datasets.datasettypeid IN (SELECT unnest(string_to_array(_datasettypeidlist,'$'))::int);
	END IF;
    
END;
$function$
