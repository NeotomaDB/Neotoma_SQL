CREATE OR REPLACE FUNCTION ts.insertgeochron(_sampleid integer, _geochrontypeid integer, _agetypeid integer, _age double precision DEFAULT NULL::double precision, _errorolder double precision DEFAULT NULL::double precision, _erroryounger double precision DEFAULT NULL::double precision, _infinite boolean DEFAULT false, _delta13c double precision DEFAULT NULL::double precision, _labnumber character varying DEFAULT NULL::character varying, _materialdated character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.geochronology (sampleid, geochrontypeid, agetypeid, age, errorolder, erroryounger, infinite, delta13c, labnumber, materialdated, notes)
  VALUES (_sampleid, _geochrontypeid, _agetypeid, _age, _errorolder, _erroryounger, _infinite, _delta13c, _labnumber, _materialdated, _notes)
  RETURNING geochronid
$function$
