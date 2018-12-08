CREATE OR REPLACE FUNCTION ts.insertspecimendatecal(
    _specimendatecalid integer,
    _calage float = null,
    _calageolder float = null,
    _calageyounger float = null,
    _calibrationcurveid integer = null,
    _calibrationprogramid integer = null,
    _datecalibrated character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimendatescal  (specimendatecalid, calage, calageolder,
    calageyounger, calibrationcurveid, calibrationprogramid, datecalibrated)
  VALUES (_specimendatecalid, _calage, _calageolder, _calageyounger,
    _calibrationcurveid, _calibrationprogramid,
    TO_DATE(_datecalibrated, 'YYYY-MM-DD'))
  RETURNING specimendatecalid
$function$;
