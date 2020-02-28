CREATE OR REPLACE FUNCTION updatereplacepublicationid(_keeppubid integer, _deposepubid integer)
RETURNS TABLE(id integer,
              result character varying)
LANGUAGE SQL
AS $function$

/* Replace @DEPOSEPUBID with @KEEPPUBID and delete @DEPOSEPUBID */


WITH goodpub AS (
  SELECT pub.publicationid, 'keep'
  FROM ndb.publications AS pub WHERE (pub.publicationid = _keeppubid)
  UNION
  SELECT pub.publicationid, 'drop'
  FROM ndb.publications AS pub WHERE (pub.publicationid = _deposepubid)

)
DECLARE @N int

SET @N = (SELECT COUNT(*) FROM NDB.Publications WHERE (PublicationID = @KEEPPUBID))
IF (@N = 0)
  BEGIN
    INSERT INTO @RESULTS SELECT (CONCAT(N'KEEPPUBID ' ,CAST(@KEEPPUBID AS nvarchar), N' does not exist. Procedure aborted.'))
	SELECT Result FROM @RESULTS
	RETURN
END

SET @N = (SELECT COUNT(*) FROM NDB.Publications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N = 0)
  BEGIN
    INSERT INTO @RESULTS SELECT (CONCAT(N'DEPOSEPUBID ' ,CAST(@DEPOSEPUBID AS nvarchar), N' does not exist. Procedure aborted.'))
	SELECT Result FROM @RESULTS
	RETURN
  END


SET @N = (SELECT COUNT(*) FROM NDB.Publications WHERE (PublicationID = @DEPOSEPUBID))

SET @N = (SELECT COUNT(*) FROM NDB.CalibrationCurves WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.CalibrationCurves
    SET    NDB.CalibrationCurves.PublicationID = @KEEPPUBID
    WHERE  (NDB.CalibrationCurves.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from CalibrationCurves = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.DatasetPublications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.DatasetPublications
    SET    NDB.DatasetPublications.PublicationID = @KEEPPUBID
    WHERE  (NDB.DatasetPublications.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from DatasetPublications = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.EventPublications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.EventPublications
    SET    NDB.EventPublications.PublicationID = @KEEPPUBID
    WHERE  (NDB.EventPublications.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from EventPublications = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.ExternalPublications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.ExternalPublications
    SET    NDB.ExternalPublications.PublicationID = @KEEPPUBID
    WHERE  (NDB.ExternalPublications.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from ExternalPublications = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.FormTaxa WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.FormTaxa
    SET    NDB.FormTaxa.PublicationID = @KEEPPUBID
    WHERE  (NDB.FormTaxa.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from FormTaxa = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.GeochronPublications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.GeochronPublications
    SET    NDB.GeochronPublications.PublicationID = @KEEPPUBID
    WHERE  (NDB.GeochronPublications.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from GeochronPublications = .' ,CAST(@N AS nvarchar)))

SET @N = (SELECT COUNT(*) FROM NDB.RelativeAgePublications WHERE (PublicationID = @DEPOSEPUBID))
IF (@N > 0)
  BEGIN
    UPDATE NDB.RelativeAgePublications
    SET    NDB.RelativeAgePublications.PublicationID = @KEEPPUBID
    WHERE  (NDB.RelativeAgePublications.PublicationID = @DEPOSEPUBID)
  END
INSERT INTO @RESULTS SELECT (CONCAT(N'Records updated from RelativeAgePublications = .' ,CAST(@N AS nvarchar)))

DELETE FROM NDB.Publications
WHERE PublicationID = @DEPOSEPUBID
INSERT INTO @RESULTS SELECT (CONCAT(N'PublicationdID ', CAST(@DEPOSEPUBID AS nvarchar), N' deleted from Publications table.'))

SELECT Result FROM @RESULTS


GO
