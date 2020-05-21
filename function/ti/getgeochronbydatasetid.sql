CREATE OR REPLACE FUNCTION ti.getgeochronbydatasetid(_datasetid integer)
 RETURNS TABLE(geochronid integer, geochrontypeid integer, geochrontype character varying, agetype character varying, depth double precision, thickness double precision, analysisunitid integer, analysisunitname character varying, age double precision, errorolder double precision, erroryounger double precision, infinite boolean, labnumber character varying, materialdated character varying, notes text)
 LANGUAGE sql
AS $function$
  select gc.geochronid,
         gct.geochrontypeid,
         gct.geochrontype,
         aty.agetype,
         au.depth,
         au.thickness,
         au.analysisunitid,
         au.analysisunitname,
         gc.age,
         gc.errorolder,
         gc.erroryounger,
         gc.infinite,
         gc.labnumber,
         gc.materialdated,
         gc.notes
  from         ndb.geochronology AS gc
    inner join       ndb.samples AS smp on        gc.sampleid = smp.sampleid
    inner join      ndb.datasets AS ds  on      smp.datasetid = ds.datasetid
    inner join ndb.geochrontypes AS gct on  gc.geochrontypeid = gct.geochrontypeid
    inner join      ndb.agetypes AS aty on       gc.agetypeid = aty.agetypeid
    inner join ndb.analysisunits AS au  on smp.analysisunitid = au.analysisunitid
  where (ds.datasetid = $1)

$function$
