CREATE OR REPLACE FUNCTION ti.getlithologybycollunitid(_collunitid integer)
 RETURNS TABLE(lithologyid integer, depthtop double precision, depthbottom double precision,
			  lowerboundary character varying, description character varying)
 LANGUAGE sql
 AS $function$

 SELECT
 	li.lithologyid,
	li.depthtop,
	li.depthbottom,
	li.lowerboundary,
	li.description
 FROM      ndb.lithology as li
 WHERE     li.collectionunitid = _collunitid

$function$
