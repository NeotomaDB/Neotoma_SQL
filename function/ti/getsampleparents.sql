CREATE OR REPLACE FUNCTION ti.getsampleparents(_sampleid integer)
 RETURNS TABLE(sampleid integer, siteid integer, sitename character varying, collectionunitid integer, handle character varying, analysisunitid integer, depth double precision)
 LANGUAGE sql
AS $function$

SELECT ndb.samples.sampleid, ndb.sites.siteid, ndb.sites.sitename, ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, 
	ndb.analysisunits.analysisunitid, ndb.analysisunits.depth
FROM ndb.samples INNER JOIN 
	ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid INNER JOIN
	ndb.collectionunits ON ndb.analysisunits.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
	ndb.sites ON ndb.collectionunits.siteid = ndb.sites.siteid
WHERE ndb.samples.sampleid = _sampleid

$function$
