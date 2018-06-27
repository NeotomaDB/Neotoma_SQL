CREATE OR REPLACE FUNCTION da.chronologybyidv2(chronid integer)
 RETURNS TABLE(chronologyid integer, agetype character varying, isdefault smallint, chronologyname character varying, dateprepared date, agemodel character varying, ageboundyounger integer, ageboundolder integer, datasetidnotes character varying, chroncontrolid integer, controldepth double precision, controlthickness double precision, controlage double precision, controlageyounger double precision, controlageolder double precision, chroncontroltype character varying)
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
