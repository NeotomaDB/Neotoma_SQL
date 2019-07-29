CREATE OR REPLACE FUNCTION ts.updateradiocarbon(_geochronid integer, _radiocarbonmethodid integer DEFAULT NULL::integer, _percentc double precision DEFAULT NULL::double precision, _percentn double precision DEFAULT NULL::double precision, _delta13c double precision DEFAULT NULL::double precision, _delta15n double precision DEFAULT NULL::double precision, _percentcollagen double precision DEFAULT NULL::double precision, _reservoir double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.radiocarbon AS rc
	SET   radiocarbonmethodid = _radiocarbonmethodid, percentc = _percentc,
        percentn = _percentn, delta13c = _delta13c, delta15n = _delta15n, percentcollagen = _percentcollagen, reservoir = _reservoir
	WHERE rc.geochronid = _geochronid
$function$
