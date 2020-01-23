CREATE OR REPLACE FUNCTION ts.insertlithology(_collectionunitid integer, _depthtop double precision DEFAULT NULL::double precision, _depthbottom double precision DEFAULT NULL::double precision, _lowerboundary character varying DEFAULT NULL::character varying, _description character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.lithology (collectionunitid, depthtop, depthbottom, lowerboundary, description)
  VALUES (_collectionunitid, _depthtop, _depthbottom, _lowerboundary, _description)
  RETURNING lithologyid
$function$
