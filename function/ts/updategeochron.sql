CREATE OR REPLACE FUNCTION ts.updategeochron(_geochronid integer, _geochrontypeid integer, _agetypeid integer, _age double precision DEFAULT NULL::double precision, _errorolder double precision DEFAULT NULL::double precision, _erroryounger double precision DEFAULT NULL::double precision, _infinite boolean DEFAULT false, _labnumber character varying DEFAULT NULL::character varying, _materialdated character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.geochronology
	SET   geochrontypeid = _geochrontypeid, agetypeid = _agetypeid, age = _age,
    errorolder = _errorolder, erroryounger = _erroryounger,
    infinite = _infinite, labnumber = _labnumber,
    materialdated = _materialdated, notes = _notes
	WHERE geochronid = _geochronid
$function$
