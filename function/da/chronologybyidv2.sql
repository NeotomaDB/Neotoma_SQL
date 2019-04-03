CREATE OR REPLACE FUNCTION da.chronologybyidv2(chronid integer)
 RETURNS TABLE(chronologyid integer,
               agetype character varying,
               isdefault boolean,
               chronologyname character varying,
               dateprepared date,
               agemodel character varying,
               ageboundyounger integer,
               ageboundolder integer,
               datasetidnotes character varying,
               chroncontrolid integer,
               controldepth double precision,
               controlthickness double precision,
               controlage double precision,
               controlageyounger double precision,
               controlageolder double precision,
               chroncontroltype character varying)
 LANGUAGE sql
AS $function$

SELECT chr.chronologyid,
       aty.agetype,
       chr.isdefault,
       chr.chronologyname,
       chr.dateprepared,
       chr.agemodel,
       chr.ageboundyounger,
       chr.ageboundolder,
       chr.notes,
       chcr.chroncontrolid,
       chcr.depth           AS controldepth,
       chcr.thickness       AS controlthickness,
       chcr.age             AS controlage,
       chcr.agelimityounger AS controlageyounger,
       chcr.agelimitolder   AS controlageolder,
       cct.chroncontroltype
FROM       ndb.chronologies AS chr
  INNER JOIN ndb.agetypes         AS aty  ON           chr.agetypeid = aty.agetypeid
  LEFT JOIN ndb.chroncontrols     AS chcr ON        chr.chronologyid = chcr.chronologyid
  LEFT JOIN ndb.chroncontroltypes AS cct  ON chcr.chroncontroltypeid = cct.chroncontroltypeid
WHERE chr.chronologyid =  chronid;

$function$
