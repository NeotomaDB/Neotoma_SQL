<<<<<<< HEAD
CREATE OR REPLACE FUNCTION ts.deletedataprocessor(_datasetid integer, _contactid integer)
=======
CREATE OR REPLACE FUNCTION ts.deletedataprocessor (_datasetid integer, _contactid integer)
>>>>>>> Anna_SQL
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.dataprocessors AS dp
WHERE dp.datasetid = _datasetid AND dp.contactid = _contactid;
$function$
