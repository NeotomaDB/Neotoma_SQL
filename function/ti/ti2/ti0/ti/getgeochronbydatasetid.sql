CREATE OR REPLACE FUNCTION ti.getgeochronbydatasetid(datasetid integer)
 RETURNS TABLE(geochronid integer, geochrontypeid integer, geochrontype integer, agetype character varying, depth double precision, thickness double precision, analysisunitname character varying, age double precision, errorolder double precision, erroryounger double precision, infinite smallint, labnumber character varying, materialdated character varying, notes text)
 LANGUAGE sql
AS $function$

select     ndb.geochronology.geochronid, ndb.geochronology.geochrontypeid, ndb.geochrontypes.geochrontypeid, ndb.agetypes.agetype, ndb.analysisunits.depth, 
                      ndb.analysisunits.thickness, ndb.analysisunits.analysisunitname, ndb.geochronology.age, ndb.geochronology.errorolder, ndb.geochronology.erroryounger, 
                      ndb.geochronology.infinite, ndb.geochronology.labnumber, ndb.geochronology.materialdated, ndb.geochronology.notes
from         ndb.geochronology inner join
                      ndb.samples on ndb.geochronology.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid inner join
                      ndb.geochrontypes on ndb.geochronology.geochrontypeid = ndb.geochrontypes.geochrontypeid inner join
                      ndb.agetypes on ndb.geochronology.agetypeid = ndb.agetypes.agetypeid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
where     (ndb.datasets.datasetid = $1)

$function$
