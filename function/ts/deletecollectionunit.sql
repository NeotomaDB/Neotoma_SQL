CREATE OR REPLACE FUNCTION ts.deletecollectionunit(_collectionunitid integer)
 RETURNS void
 LANGUAGE sql
AS $function$


WITH gccs AS (
  SELECT  gcc.chroncontrolid, gcc.geochronid
  FROM    ndb.collectionunits AS cu
    INNER JOIN  ndb.chronologies AS chr ON cu.collectionunitid = chr.collectionunitid
    INNER JOIN  ndb.chroncontrols AS cc on chr.chronologyid = cc.chronologyid
    INNER JOIN ndb.geochroncontrols AS gcc on cc.chroncontrolid = gcc.chroncontrolid
  WHERE   (cu.collectionunitid = _collectionunitid)
)

	DELETE FROM ndb.geochroncontrols
  WHERE chroncontrolid IN (SELECT gccs.chroncontrolid FROM gccs)
    AND geochronid IN (SELECT gccs.geochronid FROM gccs);


  WITH gccs AS
  (
    SELECT
      chr.chronologyid
    FROM    ndb.collectionunits AS cu
    JOIN       ndb.chronologies AS chr ON cu.collectionunitid = chr.collectionunitid
    JOIN      ndb.chroncontrols AS ccs ON  chr.chronologyid = ccs.chronologyid
    WHERE cu.collectionunitid = _collectionunitid
  )
  DELETE FROM ndb.chronologies AS chr WHERE chr.chronologyid IN (SELECT gccs.chronologyid FROM gccs);

    WITH gccs AS
  (
    SELECT
      smp.sampleid
    FROM    ndb.collectionunits AS cu
    JOIN      ndb.analysisunits AS au  ON cu.collectionunitid = au.collectionunitid
    JOIN            ndb.samples AS smp ON   au.analysisunitid = smp.analysisunitid
    WHERE cu.collectionunitid = _collectionunitid
  )

  DELETE FROM ndb.samples AS smp WHERE smp.sampleid IN (SELECT gccs.sampleid FROM gccs);

    WITH gccs AS
  (
    SELECT
      au.analysisunitid
    FROM    ndb.collectionunits AS cu
    JOIN      ndb.analysisunits AS au  ON cu.collectionunitid = au.collectionunitid
    WHERE cu.collectionunitid = _collectionunitid
  )

  DELETE FROM ndb.analysisunits AS au WHERE au.analysisunitid IN (SELECT gccs.analysisunitid FROM gccs);

  DELETE FROM ndb.collectionunits AS cu WHERE cu.collectionunitid = _collectionunitid
$function$
