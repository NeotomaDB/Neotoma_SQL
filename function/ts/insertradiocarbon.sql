CREATE OR REPLACE FUNCTION ts.insertradiocarbon(_geochronid integer, _radiocarbonmethodid integer DEFAULT NULL::integer, _percentc double precision DEFAULT NULL::double precision, _percentn double precision DEFAULT NULL::double precision, _delta13c double precision DEFAULT NULL::double precision, _delta15n double precision DEFAULT NULL::double precision, _percentcollagen double precision DEFAULT NULL::double precision, _reservoir double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.radiocarbon(geochronid, radiocarbonmethodid, percentc,
    percentn, delta13c, delta15n, percentcollagen, reservoir)
  VALUES (_geochronid, _radiocarbonmethodid, _percentc, _percentn, _delta13c,
    _delta15n, _percentcollagen, _reservoir)
$function$
