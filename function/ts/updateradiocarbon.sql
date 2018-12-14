CREATE OR REPLACE FUNCTION ts.updateradiocarbon(
  _geochronid integer,
  _radiocarbonmethodid integer = null,
  _percentc float = null,
  _percentn float = null,
  _delta13c float = null,
  _delta15n float = null,
  _percentcollagen float = null,
  _reservoir float = null)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.radiocarbon AS rc
	SET   radiocarbonmethodid = _radiocarbonmethodid, percentc = _percentc,
        percentn = _percentn, delta13c = _delta13c, delta15n = _delta15n, percentcollagen = _percentcollagen, reservoir = _reservoir
	WHERE rc.geochronid = _geochronid
$function$;
