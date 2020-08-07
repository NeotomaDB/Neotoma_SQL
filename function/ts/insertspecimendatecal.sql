CREATE OR REPLACE FUNCTION ts.insertspecimendatecal(_specimendateid integer, _calage double precision DEFAULT NULL::double precision, _calageolder double precision DEFAULT NULL::double precision, _calageyounger double precision DEFAULT NULL::double precision, _calibrationcurveid integer DEFAULT NULL::integer, _calibrationprogramid integer DEFAULT NULL::integer, _datecalibrated character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimendatescal  (specimendateid, calage, calageolder,
    calageyounger, calibrationcurveid, calibrationprogramid, datecalibrated)
  VALUES (_specimendateid, _calage, _calageolder, _calageyounger,
    _calibrationcurveid, _calibrationprogramid,
    TO_DATE(_datecalibrated, 'YYYY-MM-DD'))
  RETURNING specimendatecalid
$function$
