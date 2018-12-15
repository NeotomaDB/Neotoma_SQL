CREATE OR REPLACE FUNCTION ts.insertsite(
  _sitename CHARACTER VARYING,
  _east numeric,
  _north numeric,
  _west numeric,
  _south numeric,
  _altitude integer = null,
  _area numeric = null,
  _descript CHARACTER VARYING = null,
  _notes CHARACTER VARYING = null)
RETURNS integer
LANGUAGE sql
AS $function$

  insert into ndb.sites (sitename, altitude, area, sitedescription, notes, geog)
  values      (_sitename,
               _altitude, _area, _descript,
               _notes,
               (SELECT ST_Envelope(('LINESTRING(' ||
				                            _west::text || ' ' || _south::text || ',' ||
				                            _east::text || ' ' || _north::text || ')')::geometry)::geography))
  RETURNING siteid
$function$
