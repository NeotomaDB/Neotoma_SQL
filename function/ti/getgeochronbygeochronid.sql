CREATE OR REPLACE FUNCTION ti.getgeochronbygeochronid(geochronid integer)
 RETURNS TABLE(sampleid integer, geochrontypeid integer, agetypeid integer, age double precision, errorolder double precision, erroryounger double precision, infinite boolean, labnumber character varying, materialdated character varying, notes text)
 LANGUAGE sql
AS $function$


select     sampleid, geochrontypeid, agetypeid, age, errorolder, erroryounger, infinite, labnumber, materialdated, notes
from       ndb.geochronology
where     (geochronid = $1)



$function$
