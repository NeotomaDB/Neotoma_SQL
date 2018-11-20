CREATE OR REPLACE FUNCTION ts.insertradiocarbon(_geochronid integer,
    _radiocarbonmethodid integer=null,
    _percentc float = null,
    _percentn float = null,
    _delta13c float = null,
    _delta15n float = null,
    _percentcollagen float = null,
    _reservoir float = null)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.radiocarbon(geochronid, radiocarbonmethodid, percentc,
    percentn, delta13c, delta15n, percentcollagen, reservoir)
  VALUES (_geochronid, _radiocarbonmethodid, _percentc, _percentn, _delta13c,
    _delta15n, _percentcollagen, _reservoir)
$function$;
