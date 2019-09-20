CREATE OR REPLACE FUNCTION ap.getgeochrondatasetbyassociateddatasetid(_datasetid integer)
 RETURNS TABLE(sampleid integer, geochrontype character varying, agetype character varying, depth double precision, thickness double precision, age double precision, errorolder double precision, erroryounger double precision, infinite boolean, delta13c double precision, labnumber character varying, materialdated character varying, notes text)
 LANGUAGE sql
AS $function$
    select     ndb.geochronology.sampleid, ndb.geochrontypes.geochrontype, ndb.agetypes.agetype, ndb.analysisunits.depth, 
                      ndb.analysisunits.thickness, ndb.geochronology.age, ndb.geochronology.errorolder, ndb.geochronology.erroryounger, 
                      ndb.geochronology.infinite, ndb.geochronology.delta13c, ndb.geochronology.labnumber, ndb.geochronology.materialdated, ndb.geochronology.notes
    from         ndb.geochronology inner join
                      ndb.samples on ndb.geochronology.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid inner join
                      ndb.geochrontypes on ndb.geochronology.geochrontypeid = ndb.geochrontypes.geochrontypeid inner join
                      ndb.agetypes on ndb.geochronology.agetypeid = ndb.agetypes.agetypeid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
    where     (ndb.datasets.datasetid = _datasetid  and (ndb.datasets.datasettypeid = 1));
$function$
