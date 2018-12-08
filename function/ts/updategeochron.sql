CREATE OR REPLACE FUNCTION ts.updategeochron(
  _geochronid integer,
  _geochrontypeid integer,
  _agetypeid integer,
  _age float = null,
  _errorolder float = null,
  _erroryounger float = null,
  _infinite boolean = FALSE,
  _labnumber character varying = null,
  _materialdated character varying = null,
  _notes character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.geochronology
	SET   geochrontypeid = _geochrontypeid, agetypeid = _agetypeid, age = _age,
    errorolder = _errorolder, erroryounger = _erroryounger,
    infinite = _infinite, labnumber = _labnumber,
    materialdated = _materialdated, notes = _notes
	WHERE geochronid = _geochronid
$function$;
