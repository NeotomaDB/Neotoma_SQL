CREATE OR REPLACE FUNCTION ti.getgeochronanalysisunit(_geochronid integer)
 RETURNS TABLE(sampleid integer, collectionunitid integer, analysisunitid integer, analysisunitname character varying, depth double precision, thickness double precision)
 LANGUAGE sql
AS $function$

select     ndb.samples.sampleid, ndb.analysisunits.collectionunitid, ndb.analysisunits.analysisunitid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth, 
             ndb.analysisunits.thickness 
from       ndb.geochronology inner join
                      ndb.samples on ndb.geochronology.sampleid = ndb.samples.sampleid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
where     (ndb.geochronology.geochronid = $1)

$function$
