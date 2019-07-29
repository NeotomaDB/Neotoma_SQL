CREATE OR REPLACE FUNCTION ts.insertdataprocessor(_datasetid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.dataprocessors(datasetid, contactid)
VALUES (_datasetid, _contactid)
$function$
