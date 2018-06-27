CREATE OR REPLACE FUNCTION da.chronologybyid(chronid integer)
 RETURNS SETOF record
 LANGUAGE sql
AS $function$
SELECT ndb.chronologies.chronologyid, ndb.agetypes.agetype, ndb.chronologies.isdefault, ndb.chronologies.chronologyname, ndb.chronologies.dateprepared,
ndb.chronologies.agemodel, ndb.chronologies.ageboundyounger, ndb.chronologies.ageboundolder,ndb.chronologies.notes, ndb.chroncontrols.chroncontrolid,
ndb.chroncontrols.depth AS controldepth, ndb.chroncontrols.thickness AS controlthickness, ndb.chroncontrols.age AS controlage, ndb.chroncontrols.agelimityounger AS controlageyounger,
ndb.chroncontrols.agelimitolder AS controlageolder, ndb.chroncontroltypes.chroncontroltype
FROM ndb.chronologies INNER JOIN ndb.agetypes ON ndb.chronologies.agetypeid = ndb.agetypes.agetypeid LEFT JOIN
ndb.chroncontrols ON ndb.chronologies.chronologyid = ndb.chroncontrols.chronologyid LEFT JOIN
ndb.chroncontroltypes ON ndb.chroncontrols.chroncontroltypeid = ndb.chroncontroltypes.chroncontroltypeid
WHERE ndb.chronologies.chronologyid =  chronid;
$function$
