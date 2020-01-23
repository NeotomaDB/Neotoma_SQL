CREATE OR REPLACE FUNCTION ts.insertsite(_sitename character varying, _east numeric, _north numeric, _west numeric, _south numeric, _altitude integer DEFAULT NULL::integer, _area numeric DEFAULT NULL::numeric, _descript character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
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
