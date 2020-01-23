CREATE OR REPLACE FUNCTION ti.getcollunitsummarybysiteid(_siteid integer)
 RETURNS TABLE(collectionunitid integer, handle character varying, collunitname character varying, colltype character varying, colldate character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, ndb.collectionunits.collunitname, ndb.collectiontypes.colltype, 
       ndb.collectionunits.colldate::varchar(10) AS colldate
FROM ndb.collectionunits INNER JOIN ndb.collectiontypes ON ndb.collectionunits.colltypeid = ndb.collectiontypes.colltypeid
WHERE ndb.collectionunits.siteid = _siteid;
$function$
