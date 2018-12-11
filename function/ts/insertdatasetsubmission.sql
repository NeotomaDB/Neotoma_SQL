CREATE OR REPLACE FUNCTION ts.insertdatasetsubmission(
  _datasetid        INTEGER,
  _databaseid       INTEGER,
  _contactid        INTEGER,
  _submissiontypeid INTEGER,
  _submissiondate   CHARACTER VARYING,
  _notes            CHARACTER VARYING = null)
RETURNS INTEGER
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
