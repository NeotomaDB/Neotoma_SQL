CREATE OR REPLACE FUNCTION ts.insertspecimendatecal(
    _specimendatenid integer,
    _calage float = null,
    _calageolder float = null,
    _calageyounger float = null,
    _calibrationcurveid integer = null,
    _calibrationprogramid integer = null,
    _datecalibrated date = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimendatescal  (specimendateid, calage, calageolder,
    calageyounger, calibrationcurveid, calibrationprogramid, datecalibrated)
  VALUES (_specimendateid, _calage, _calageolder, _calageyounger,
    _calibrationcurveid, _calibrationprogramid,
    TO_CHAR(datecalibrated, 'YYYY-MM-DD') as datecalibrated)
  RETURNING specimendatecalid
$function$;
