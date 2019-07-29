CREATE OR REPLACE FUNCTION ti.getdatasetpisdatasettypes(_datasettypeidlist character varying DEFAULT NULL::character varying)
 RETURNS TABLE(contactid integer, datasettypeid integer, datasetid integer, contactname character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
	IF _datasettypeidlist IS NULL THEN
		RETURN QUERY SELECT ndb.datasetpis.contactid, ndb.datasets.datasettypeid, ndb.datasetpis.datasetid, ndb.contacts.contactname
		FROM   ndb.datasetpis INNER JOIN
				   ndb.datasets on ndb.datasetpis.datasetid = ndb.datasets.datasetid INNER JOIN
				   ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid;

	ELSE
		RETURN QUERY SELECT ndb.datasetpis.contactid, ndb.datasets.datasettypeid, ndb.datasetpis.datasetid, ndb.contacts.contactname
		FROM   ndb.datasetpis INNER JOIN
				   ndb.datasets on ndb.datasetpis.datasetid = ndb.datasets.datasetid INNER JOIN
				   ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
		WHERE  ndb.datasets.datasettypeid in (SELECT unnest(string_to_array(_datasettypeidlist,'$'))::int);
	END IF;
END;
$function$
