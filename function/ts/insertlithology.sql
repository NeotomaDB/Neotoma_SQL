CREATE OR REPLACE FUNCTION ts.insertlithology(_collectionunitid integer,
_depthtop float = null,
_depthbottom float = null,
_lowerboundary character varying = null,
_description character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.lithology (collectionunitid, depthop, depthbottom, lowerboundary, description)
  VALUES (_collectionunitid, _depthtop, _depthbottom, _lowerboundary, _description)
  RETURNING lithologyid
$function$;
