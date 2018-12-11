CREATE OR REPLACE FUNCTION ts.deletesite(_siteid INTEGER)
RETURNS void
LANGUAGE sql
AS $function$

  WITH gccs AS (
    SELECT  gcc.chroncontrolid,
                gcc.geochronid
    FROM    ndb.sites            AS sts
    JOIN    ndb.collectionunits  AS cu  ON sts.siteid = cu.siteid
    JOIN    ndb.chronologies     AS chr ON cu.collectionunitid = chr.collectionunitid
    JOIN    ndb.chroncontrols    AS cc  ON chr.chronologyid = cc.chronologyid
    JOIN    ndb.geochroncontrols AS gcc ON cc.chroncontrolid = gcc.chroncontrolid
    WHERE   sts.siteid = _siteid
  )

	DELETE FROM ndb.geochroncontrols AS gcc
  WHERE (gcc.chroncontrolid, gcc.geochronid) IN (SELECT chroncontrolid, geochronid FROM gccs);

  WITH chids AS (
    SELECT  chr.chronologyid
    FROM    ndb.sites AS sts
    JOIN    ndb.collectionunits AS cu  ON sts.siteid = cu.siteid
    JOIN    ndb.chronologies    AS chr ON cu.collectionunitid = chr.collectionunitid
    WHERE   sts.siteid = _siteid
  )

	DELETE FROM ndb.chronologies AS chr WHERE chr.chronologyid IN (SELECT chronologyid FROM chids);

  WITH samps AS (
    SELECT     smp.sampleid
    FROM       ndb.sites AS sts
    JOIN ndb.collectionunits AS cu  ON sts.siteid = cu.siteid
    JOIN ndb.analysisunits AS au ON cu.collectionunitid = au.collectionunitid
    JOIN ndb.samples AS smp ON au.analysisunitid = smp.analysisunitid
    WHERE sts.siteid = _siteid
  )

  DELETE FROM ndb.samples AS smp WHERE smp.sampleid IN (SELECT sampleid FROM samps);

  WITH aus AS (
    SELECT     au.analysisunitid
    FROM       ndb.sites AS sts
    JOIN ndb.collectionunits AS cu ON sts.siteid = cu.siteid
    JOIN ndb.analysisunits AS au ON cu.collectionunitid = au.collectionunitid
    WHERE sts.siteid = _siteid
  )

  DELETE FROM ndb.analysisunits AS au WHERE au.analysisunitid  IN (SELECT analysisunitid FROM aus);

  DELETE FROM ndb.sites AS sts
  WHERE sts.siteid = _siteid

$function$
