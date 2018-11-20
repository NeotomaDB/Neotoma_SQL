CREATE OR REPLACE FUNCTION ts.insertgeochron(_sampleid integer,
_geochrontypeid integer,
_agetypeid integer,
_age float = null,
_errorolder float = null,
_erroryounger float = null,
_infinite boolean = FALSE,
_delta13c float = null,
_labnumber character varying = null,
_materialdated character varying = null,
_notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.geochronology (sampleid, geochrontypeid, agetypeid, age, errorolder, erroryounger, infinite, delta13c, labnumber, materialdated, notes)
  VALUES (_sampleid, _geochrontypeid, _agetypeid, _age, _errorolder, _erroryounger, _infinite, _delta13c, _labnumber, _materialdated, _notes)
  RETURNING geochronid
$function$;
