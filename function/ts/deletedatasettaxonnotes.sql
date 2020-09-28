CREATE OR REPLACE FUNCTION ts.deletedatasettaxonnotes(_datasetid integer, _taxonid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.datasettaxonnotes AS dtn
  WHERE dtn.datasetid = _datasetid AND dtn.taxonid = _taxonid;
$function$
