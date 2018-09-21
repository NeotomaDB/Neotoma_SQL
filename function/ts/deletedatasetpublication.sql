<<<<<<< HEAD
CREATE OR REPLACE FUNCTION ts.deletedatasetpublication(_datasetid integer, _publicationid integer)
=======
CREATE OR REPLACE FUNCTION ts.deletedatasetpublication (_datasetid integer, _publicationid integer)
>>>>>>> Anna_SQL
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.datasetpublications AS dsp
WHERE dsp.datasetid = _datasetid AND dsp.publicationid = _publicationid;
$function$
