CREATE OR REPLACE FUNCTION ts.insertgeopoliticalunit(_geopolname character varying,
_geopolunit character varying,
_rank integer,
_higherid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.geopoliticalunits (geopoliticalname, geopoliticalunit, rank, highergeopoliticalid)
  VALUES (_geopolname, _geopolunit, _rank, _higherid)
  RETURNING geopoliticalid
$function$;
