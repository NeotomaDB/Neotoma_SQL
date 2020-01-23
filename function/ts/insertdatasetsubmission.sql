CREATE OR REPLACE FUNCTION ts.insertdatasetsubmission(_datasetid integer, _databaseid integer, _contactid integer, _submissiontypeid integer, _submissiondate character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.datasetsubmissions(
    datasetid,
    databaseid,
    contactid,
    submissiontypeid,
    submissiondate,
    notes)
  VALUES      (
    _datasetid,
    _databaseid,
    _contactid,
    _submissiontypeid,
    TO_DATE(_submissiondate, 'YYYY-MM-DD'),
    _notes)
  RETURNING submissionid

$function$
