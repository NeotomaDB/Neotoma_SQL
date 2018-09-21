CREATE OR REPLACE FUNCTION ts.insertdatasetpi(_datasetid integer, _contactid integer, _piorder integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.datasetpis(datasetid, contactid, piorder)
VALUES (_datasetid, _contactid, _piorder)
$function$;
