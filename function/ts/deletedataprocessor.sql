CREATE OR REPLACE FUNCTION ts.deletedataprocessor (_datasetid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.dataprocessors AS dp
WHERE dp.datasetid = _datasetid AND dp.contactid = _contactid;
$function$
