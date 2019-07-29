CREATE OR REPLACE FUNCTION ts.insertdatasettaxonnotes(_datasetid integer, _taxonid integer, _contactid integer, _date character varying, _notes character varying, _update boolean)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.datasettaxonnotes (datasetid, taxonid, contactid, date, notes)
  VALUES      (_datasetid, _taxonid, _contactid, TO_DATE(_date, 'YYYY-MM-DD'), _notes);

  WITH updval AS (
    SELECT _contactid AS contactid,
           'datasettaxonnotes' AS tablename,
           _datasetid AS pk1,
           _taxonid AS pk2,
           'insert' AS operation
    WHERE _update
  )
  INSERT INTO ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
  SELECT * FROM updval;

$function$
