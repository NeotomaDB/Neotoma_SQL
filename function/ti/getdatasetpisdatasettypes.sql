CREATE OR REPLACE FUNCTION ti.getdatasetpisdatasettypes(_datasettypeidlist character varying DEFAULT NULL::character varying)
 RETURNS TABLE(contactid integer,
               datasettypeid integer,
               datasetid integer,
               contactname character varying)
 LANGUAGE sql
AS $function$
  SELECT dspi.contactid,
         ds.datasettypeid,
         dspi.datasetid,
         ct.contactname
	FROM   ndb.datasetpis AS dspi
    INNER JOIN ndb.datasets AS ds ON dspi.datasetid = ds.datasetid
    INNER JOIN ndb.contacts AS ct on dspi.contactid = ct.contactid
	WHERE  (_datasettypeidlist IS NULL) OR ds.datasettypeid in (SELECT unnest(string_to_array(_datasettypeidlist,','))::int);
$function$
