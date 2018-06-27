/*
Navicat SQL Server Data Transfer

Source Server         : db5-emswin-neotomaDev
Source Server Version : 110000
Source Host           : db5.emswin.psu.edu:1433
Source Database       : Neotoma
Source Schema         : TS

Target Server Type    : SQL Server
Target Server Version : 110000
File Encoding         : 65001

Date: 2018-06-27 14:34:49
*/


-- ----------------------------
-- Procedure structure for CheckSteward
-- ----------------------------



CREATE PROCEDURE [CheckSteward]

@username nvarchar(80),
@pwd nvarchar(80)

 AS

SET NOCOUNT ON

SELECT StewardID, authorized
FROM TS.StewardAuthorization
WHERE username = @username AND pwd = @pwd
                  
   RETURN

SET NOCOUNT OFF




GO

-- ----------------------------
-- Procedure structure for CombineContacts
-- ----------------------------



CREATE PROCEDURE [CombineContacts](@KEEPCONTACTID int, @CONTACTIDLIST nvarchar(MAX))
AS 
-- DECLARE @KEEPCONTACTID int
-- SET @KEEPCONTACTID = 1524
-- DECLARE @CONTACTIDLIST nvarchar(MAX)
-- SET @CONTACTIDLIST = N'1524$7393$9040'

DECLARE @N int

DECLARE @CONTACTIDS TABLE (ID int NOT NULL primary key identity(1,1),
                           ContactID int)

INSERT INTO @CONTACTIDS (ContactID)
SELECT      ContactID
FROM        NDB.Contacts
WHERE       (ContactID IN (
		             SELECT Value
		             FROM TI.func_NvarcharListToIN(@CONTACTIDLIST,'$')
                     ))

DECLARE @NROWS int = @@ROWCOUNT
DECLARE @CURRENTID int = 0
DECLARE @CONTACTID int
WHILE @CURRENTID < @NROWS
  BEGIN 
    SET @CURRENTID = @CURRENTID+1
	SET @CONTACTID = (SELECT ContactID FROM @CONTACTIDS WHERE ID = @CURRENTID)
	IF @CONTACTID <> @KEEPCONTACTID
	  BEGIN
	    IF (SELECT COUNT(ContactID) FROM NDB.PublicationAuthors WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.PublicationAuthors
            SET    NDB.PublicationAuthors.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.PublicationAuthors.ContactID = @CONTACTID) 
		  END
        IF (SELECT COUNT(ContactID) FROM NDB.Chronologies WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.Chronologies
            SET    NDB.Chronologies.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.Chronologies.ContactID = @CONTACTID) 
		  END
        IF (SELECT COUNT(ContactID) FROM NDB.Collectors WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.Collectors
            SET    NDB.Collectors.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.Collectors.ContactID = @CONTACTID) 
		  END
        IF (SELECT COUNT(ContactID) FROM NDB.ConstituentDatabases WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.ConstituentDatabases
            SET    NDB.ConstituentDatabases.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.ConstituentDatabases.ContactID = @CONTACTID) 
		  END
        IF (SELECT COUNT(ContactID) FROM NDB.DataProcessors WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.DataProcessors
            SET    NDB.DataProcessors.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.DataProcessors.ContactID = @CONTACTID) 
		  END
        IF (SELECT COUNT(ContactID) FROM NDB.DatasetPIs WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.DatasetPIs
            SET    NDB.DatasetPIs.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.DatasetPIs.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.DatasetSubmissions WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.DatasetSubmissions
            SET    NDB.DatasetSubmissions.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.DatasetSubmissions.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.DatasetTaxonNotes WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.DatasetTaxonNotes
            SET    NDB.DatasetTaxonNotes.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.DatasetTaxonNotes.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.DataTaxonNotes WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.DataTaxonNotes
            SET    NDB.DataTaxonNotes.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.DataTaxonNotes.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.SampleAnalysts WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.SampleAnalysts
            SET    NDB.SampleAnalysts.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.SampleAnalysts.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.SiteImages WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.SiteImages
            SET    NDB.SiteImages.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.SiteImages.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM TI.StewardUpdates WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE TI.StewardUpdates
            SET    TI.StewardUpdates.ContactID = @KEEPCONTACTID   
            WHERE  (TI.StewardUpdates.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ContactID) FROM NDB.Synonymy WHERE (ContactID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.Synonymy
            SET    NDB.Synonymy.ContactID = @KEEPCONTACTID   
            WHERE  (NDB.Synonymy.ContactID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(ValidatorID) FROM NDB.Taxa WHERE (ValidatorID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.Taxa
            SET    NDB.Taxa.ValidatorID = @KEEPCONTACTID   
            WHERE  (NDB.Taxa.ValidatorID = @CONTACTID) 
		  END 
        IF (SELECT COUNT(AnalystID) FROM NDB.IsoMetadata WHERE (AnalystID = @CONTACTID)) > 0
		  BEGIN
		    UPDATE NDB.IsoMetadata
            SET    NDB.IsoMetadata.AnalystID = @KEEPCONTACTID   
            WHERE  (NDB.IsoMetadata.AnalystID = @CONTACTID) 
		  END 
        DELETE FROM NDB.Contacts WHERE (NDB.Contacts.ContactID = @CONTACTID) 
	  END
  END

GO

-- ----------------------------
-- Procedure structure for DeleteAnalysisUnit
-- ----------------------------




CREATE PROCEDURE [DeleteAnalysisUnit](@ANALUNITID int)
AS 
Delete from NDB.AnalysisUnits
WHERE AnalysisUnitID = @ANALUNITID






GO

-- ----------------------------
-- Procedure structure for DeleteChronology
-- ----------------------------






CREATE PROCEDURE [DeleteChronology](@CHRONOLOGYID int)
AS 
/* Nuke GeochronControls */
DECLARE @GEOCHRONCONTROLS TABLE
(
  ChronControlID int,
  GeochronID int,
  PRIMARY KEY (ChronControlID, GeochronID)
)

INSERT INTO @GEOCHRONCONTROLS(ChronControlID, GeochronID)
SELECT     NDB.GeoChronControls.ChronControlID, NDB.GeoChronControls.GeochronID
FROM       NDB.Chronologies INNER JOIN
                      NDB.ChronControls ON NDB.Chronologies.ChronologyID = NDB.ChronControls.ChronologyID INNER JOIN
                      NDB.GeoChronControls ON NDB.ChronControls.ChronControlID = NDB.GeoChronControls.ChronControlID
WHERE     (NDB.Chronologies.ChronologyID = @CHRONOLOGYID)

DECLARE @CHRONCONTROLID int
DECLARE @GEOCHRONID int
WHILE (SELECT COUNT(*) From @GEOCHRONCONTROLS) > 0
  BEGIN
    SET @CHRONCONTROLID = (SELECT TOP (1) ChronControlID FROM @GEOCHRONCONTROLS)
    SET @GEOCHRONID = (SELECT TOP (1) GeochronID FROM @GEOCHRONCONTROLS)
	DELETE FROM NDB.GeoChronControls WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
	DELETE FROM @GEOCHRONCONTROLS WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
  END


/* Nuke ChronologY */
DELETE FROM NDB.Chronologies WHERE ChronologyID = @CHRONOLOGYID



GO

-- ----------------------------
-- Procedure structure for DeleteCollectionUnit
-- ----------------------------






CREATE PROCEDURE [DeleteCollectionUnit](@COLLECTIONUNITID int)
AS 
/* Nuke GeochronControls */
DECLARE @GEOCHRONCONTROLS TABLE
(
  ChronControlID int,
  GeochronID int,
  PRIMARY KEY (ChronControlID, GeochronID)
)

INSERT INTO @GEOCHRONCONTROLS(ChronControlID, GeochronID)
SELECT  NDB.GeoChronControls.ChronControlID, NDB.GeoChronControls.GeochronID
FROM    NDB.CollectionUnits INNER JOIN
                    NDB.Chronologies ON NDB.CollectionUnits.CollectionUnitID = NDB.Chronologies.CollectionUnitID INNER JOIN
                    NDB.ChronControls ON NDB.Chronologies.ChronologyID = NDB.ChronControls.ChronologyID INNER JOIN
                    NDB.GeoChronControls ON NDB.ChronControls.ChronControlID = NDB.GeoChronControls.ChronControlID
WHERE   (NDB.CollectionUnits.CollectionUnitID = @COLLECTIONUNITID)


DECLARE @CHRONCONTROLID int
DECLARE @GEOCHRONID int
WHILE (SELECT COUNT(*) From @GEOCHRONCONTROLS) > 0
  BEGIN
    SET @CHRONCONTROLID = (SELECT TOP (1) ChronControlID FROM @GEOCHRONCONTROLS)
    SET @GEOCHRONID = (SELECT TOP (1) GeochronID FROM @GEOCHRONCONTROLS)
	DELETE FROM NDB.GeoChronControls WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
	DELETE FROM @GEOCHRONCONTROLS WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
  END


/* Nuke Chronologies */
DECLARE @CHRONOLOGYIDS TABLE
(
  ChronologyID int PRIMARY KEY
)

INSERT INTO @CHRONOLOGYIDS(ChronologyID)
SELECT  NDB.Chronologies.ChronologyID
FROM    NDB.CollectionUnits INNER JOIN
                  NDB.Chronologies ON NDB.CollectionUnits.CollectionUnitID = NDB.Chronologies.CollectionUnitID
WHERE   (NDB.CollectionUnits.CollectionUnitID = @COLLECTIONUNITID)


DECLARE @CHRONID int
WHILE (SELECT COUNT(*) From @CHRONOLOGYIDS) > 0
  BEGIN
    SET @CHRONID = (SELECT TOP 1 ChronologyID FROM @CHRONOLOGYIDS)
	DELETE FROM NDB.Chronologies WHERE ChronologyID = @CHRONID
	DELETE FROM @CHRONOLOGYIDS WHERE ChronologyID = @CHRONID
  END

/* Nuke Samples */
DECLARE @SAMPLEIDS TABLE
(
  SampleID int PRIMARY KEY
)

INSERT INTO @SAMPLEIDS(SampleID)
SELECT     NDB.Samples.SampleID
FROM       NDB.CollectionUnits INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID INNER JOIN
                      NDB.Samples ON NDB.AnalysisUnits.AnalysisUnitID = NDB.Samples.AnalysisUnitID
WHERE      (NDB.CollectionUnits.CollectionUnitID = @COLLECTIONUNITID)

DECLARE @SAMPLEID int
WHILE (SELECT COUNT(*) From @SAMPLEIDS) > 0
  BEGIN
    SET @SAMPLEID = (SELECT TOP 1 SampleID FROM @SAMPLEIDS)
	DELETE FROM NDB.Samples WHERE SampleID = @SAMPLEID
	DELETE FROM @SAMPLEIDS WHERE SampleID = @SAMPLEID
  END

/* Nuke AnalysisUnits */
DECLARE @ANALUNITIDS TABLE
(
  AnalUnitID int PRIMARY KEY
)

INSERT INTO @ANALUNITIDS(AnalUnitID)
SELECT     NDB.AnalysisUnits.AnalysisUnitID
FROM       NDB.CollectionUnits INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID
WHERE      (NDB.CollectionUnits.CollectionUnitID = @COLLECTIONUNITID)


DECLARE @ANALUNITID int
WHILE (SELECT COUNT(*) From @ANALUNITIDS) > 0
  BEGIN
    SET @ANALUNITID = (SELECT TOP 1 AnalUnitID FROM @ANALUNITIDS)
	DELETE FROM NDB.AnalysisUnits WHERE AnalysisUnitID = @ANALUNITID
	DELETE FROM @ANALUNITIDS WHERE AnalUnitID = @ANALUNITID
  END

DELETE FROM NDB.CollectionUnits 
WHERE CollectionUnitID = @COLLECTIONUNITID


GO

-- ----------------------------
-- Procedure structure for DeleteCollectors
-- ----------------------------





CREATE PROCEDURE [DeleteCollectors](@COLLUNITID int)
AS 
Delete from NDB.Collectors
WHERE CollectionUnitID = @COLLUNITID









GO

-- ----------------------------
-- Procedure structure for DeleteData
-- ----------------------------




CREATE PROCEDURE [DeleteData](@DATAID int)
AS 
Delete from NDB.Data
WHERE DataID = @DATAID






GO

-- ----------------------------
-- Procedure structure for DeleteDataProcessor
-- ----------------------------






CREATE PROCEDURE [DeleteDataProcessor](@DATASETID int, @CONTACTID int)
AS
DELETE FROM NDB.DataProcessors
WHERE (NDB.DataProcessors.DatasetID = @DATASETID) AND (NDB.DataProcessors.ContactID = @CONTACTID)





GO

-- ----------------------------
-- Procedure structure for DeleteDataset
-- ----------------------------





CREATE PROCEDURE [DeleteDataset](@DATASETID int)
AS 
DELETE FROM NDB.Samples
WHERE DatasetID = @DATASETID
DELETE FROM NDB.Datasets
WHERE DatasetID = @DATASETID






GO

-- ----------------------------
-- Procedure structure for DeleteDatasetPI
-- ----------------------------





CREATE PROCEDURE [DeleteDatasetPI](@DATASETID int, @CONTACTID int)
AS
DECLARE @DATASETPIS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  ContactID int,
  PIOrder int
)


DELETE FROM NDB.DatasetPIs
WHERE (NDB.DatasetPIs.DatasetID = @DATASETID) AND (NDB.DatasetPIs.ContactID = @CONTACTID)

DECLARE @NPIS int
SET @NPIS = (SELECT COUNT(*) FROM NDB.DatasetPIs WHERE (DatasetID = @DATASETID))
IF @NPIS > 0
  BEGIN
    INSERT INTO @DATASETPIS (ContactID, PIOrder)
    SELECT      ContactID, PIOrder FROM NDB.DatasetPIs WHERE (DatasetID = @DATASETID) 
	ORDER BY    NDB.DatasetPIs.PIOrder
	DECLARE @TContactID int
	DECLARE @CurrentID int = 0
	WHILE @CurrentID < @NPIS
      BEGIN
	    SET @CurrentID = @CurrentID+1
		SET @TContactID = (SELECT ContactID FROM @DATASETPIS WHERE (ID = @CurrentID))
		UPDATE NDB.DatasetPIs
        SET    NDB.DatasetPIs.PIOrder = @CurrentID
        WHERE  (NDB.DatasetPIs.DatasetID = @DATASETID) AND (NDB.DatasetPIs.ContactID = @TContactID)
      END 
  END

  



GO

-- ----------------------------
-- Procedure structure for DeleteDatasetPublication
-- ----------------------------



CREATE PROCEDURE [DeleteDatasetPublication](@DATASETID int, @PUBLICATIONID int)
AS 
DELETE FROM NDB.DatasetPublications
WHERE (DatasetID = @DATASETID AND PublicationID = @PUBLICATIONID)







GO

-- ----------------------------
-- Procedure structure for DeleteDatasetTaxonNotes
-- ----------------------------





CREATE PROCEDURE [DeleteDatasetTaxonNotes](@DATASETID int, @TAXONID int, @CONTACTID int)
AS 
Delete from NDB.DatasetTaxonNotes
WHERE DatasetID = @DATASETID AND TaxonID = @TAXONID

INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation)
VALUES      (@CONTACTID, N'DatasetTaxonNotes', @DATASETID, @TAXONID, N'Delete')





GO

-- ----------------------------
-- Procedure structure for DeleteDatasetVariable
-- ----------------------------






CREATE PROCEDURE [DeleteDatasetVariable](@DATASETID int, @VARIABLEID int)
AS 

DELETE FROM NDB.Data
WHERE DataID in (SELECT NDB.Data.DataID
                 FROM NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID
                 WHERE     (NDB.Samples.DatasetID = @DATASETID) AND (NDB.Data.VariableID = @VARIABLEID))

GO

-- ----------------------------
-- Procedure structure for DeleteDepEnvtType
-- ----------------------------


CREATE PROCEDURE [DeleteDepEnvtType](@DEPENVTID int)
AS Delete from NDB.DepEnvtTypes
WHERE DEPENVTID = @DEPENVTID






GO

-- ----------------------------
-- Procedure structure for DeleteEcolGroup
-- ----------------------------



CREATE PROCEDURE [DeleteEcolGroup](@TAXONID int, @ECOLSETID int)
AS 
Delete from NDB.EcolGroups
WHERE TaxonID = @TAXONID and EcolSetID = @ECOLSETID





GO

-- ----------------------------
-- Procedure structure for DeleteEventPublication
-- ----------------------------




CREATE PROCEDURE [DeleteEventPublication](@EVENTID int, @PUBLICATIONID int)
AS 
Delete from NDB.EventPublications
WHERE EventID = @EVENTID and PublicationID = @PUBLICATIONID






GO

-- ----------------------------
-- Procedure structure for DeleteGeochron
-- ----------------------------




CREATE PROCEDURE [DeleteGeochron](@GEOCHRONID int)
AS 

IF (SELECT COUNT(GeochronID) FROM NDB.GeoChronControls WHERE (GeochronID = @GEOCHRONID)) > 0
  BEGIN
    DELETE FROM NDB.GeoChronControls
	WHERE (GeochronID = @GEOCHRONID)
  END
DELETE FROM NDB.Geochronology
WHERE GeochronID = @GEOCHRONID






GO

-- ----------------------------
-- Procedure structure for DeleteGeochronControl
-- ----------------------------




CREATE PROCEDURE [DeleteGeochronControl](@CHRONCONTROLID int)
AS 
IF (SELECT  COUNT(ChronControlID) FROM NDB.GeoChronControls WHERE (ChronControlID = @CHRONCONTROLID)) > 0
  BEGIN
    DELETE FROM NDB.GeoChronControls
	WHERE (ChronControlID = @CHRONCONTROLID)
  END
DELETE FROM NDB.ChronControls
WHERE (ChronControlID = @CHRONCONTROLID)





GO

-- ----------------------------
-- Procedure structure for DeleteGeochronPublication
-- ----------------------------





CREATE PROCEDURE [DeleteGeochronPublication](@GEOCHRONID int, @PUBLICATIONID int)
AS 
DELETE FROM NDB.GeochronPublications
WHERE (GeochronID = @GEOCHRONID AND PublicationID = @PUBLICATIONID)






GO

-- ----------------------------
-- Procedure structure for DeletePublicationAuthor
-- ----------------------------



CREATE PROCEDURE [DeletePublicationAuthor](@AUTHORID int)
AS Delete from NDB.PublicationAuthors
WHERE AuthorID = @AUTHORID







GO

-- ----------------------------
-- Procedure structure for DeletePublicationEditor
-- ----------------------------




CREATE PROCEDURE [DeletePublicationEditor](@EDITORID int)
AS Delete from NDB.PublicationEditors
WHERE EditorID = @EDITORID








GO

-- ----------------------------
-- Procedure structure for DeletePublicationTranslator
-- ----------------------------




CREATE PROCEDURE [DeletePublicationTranslator](@TRANSLATORID int)
AS Delete from NDB.PublicationTranslators
WHERE TranslatorID = @TRANSLATORID








GO

-- ----------------------------
-- Procedure structure for DeleteRelativeAgePublication
-- ----------------------------


CREATE PROCEDURE [DeleteRelativeAgePublication](@RELATIVEAGEID int, @PUBLICATIONID int)
AS 
Delete from NDB.RelativeAgePublications
WHERE RelativeAgeID = @RELATIVEAGEID and PublicationID = @PUBLICATIONID







GO

-- ----------------------------
-- Procedure structure for DeleteRepositorySpecimen
-- ----------------------------





CREATE PROCEDURE [DeleteRepositorySpecimen](@DATASETID int, @REPOSITORYID int)
AS 
DELETE FROM NDB.RepositorySpecimens
WHERE       (DatasetID = @DATASETID) AND (RepositoryID = @REPOSITORYID)

-- INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation)
-- VALUES      (@CONTACTID, N'RepositorySpecimens', @DATASETID, @REPOSITORYID, N'Delete')





GO

-- ----------------------------
-- Procedure structure for DeleteSample
-- ----------------------------



CREATE PROCEDURE [DeleteSample](@SAMPLEID int)
AS 
Delete from NDB.Samples
WHERE SampleID = @SAMPLEID





GO

-- ----------------------------
-- Procedure structure for DeleteSampleAnalysts
-- ----------------------------




CREATE PROCEDURE [DeleteSampleAnalysts](@SAMPLEID int)
AS 
DELETE FROM NDB.SampleAnalysts
WHERE SampleID = @SAMPLEID






GO

-- ----------------------------
-- Procedure structure for DeleteSite
-- ----------------------------





CREATE PROCEDURE [DeleteSite](@SITEID int)
AS 
/* Nuke GeochronControls */
DECLARE @GEOCHRONCONTROLS TABLE
(
  ChronControlID int,
  GeochronID int,
  PRIMARY KEY (ChronControlID, GeochronID)
)

INSERT INTO @GEOCHRONCONTROLS(ChronControlID, GeochronID)
SELECT  NDB.GeoChronControls.ChronControlID, NDB.GeoChronControls.GeochronID
FROM    NDB.Sites INNER JOIN
                    NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                    NDB.Chronologies ON NDB.CollectionUnits.CollectionUnitID = NDB.Chronologies.CollectionUnitID INNER JOIN
                    NDB.ChronControls ON NDB.Chronologies.ChronologyID = NDB.ChronControls.ChronologyID INNER JOIN
                    NDB.GeoChronControls ON NDB.ChronControls.ChronControlID = NDB.GeoChronControls.ChronControlID
WHERE   (NDB.Sites.SiteID = @SITEID)

DECLARE @CHRONCONTROLID int
DECLARE @GEOCHRONID int
WHILE (SELECT COUNT(*) From @GEOCHRONCONTROLS) > 0
  BEGIN
    SET @CHRONCONTROLID = (SELECT TOP (1) ChronControlID FROM @GEOCHRONCONTROLS)
    SET @GEOCHRONID = (SELECT TOP (1) GeochronID FROM @GEOCHRONCONTROLS)
	DELETE FROM NDB.GeoChronControls WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
	DELETE FROM @GEOCHRONCONTROLS WHERE (ChronControlID = @CHRONCONTROLID AND GeochronID = @GEOCHRONID)
  END


/* Nuke Chronologies */
DECLARE @CHRONOLOGYIDS TABLE
(
  ChronologyID int PRIMARY KEY
)

INSERT INTO @CHRONOLOGYIDS(ChronologyID)
SELECT  NDB.Chronologies.ChronologyID
FROM    NDB.Sites INNER JOIN
                  NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                  NDB.Chronologies ON NDB.CollectionUnits.CollectionUnitID = NDB.Chronologies.CollectionUnitID
WHERE   (NDB.Sites.SiteID = @SITEID)

DECLARE @CHRONID int
WHILE (SELECT COUNT(*) From @CHRONOLOGYIDS) > 0
  BEGIN
    SET @CHRONID = (SELECT TOP 1 ChronologyID FROM @CHRONOLOGYIDS)
	DELETE FROM NDB.Chronologies WHERE ChronologyID = @CHRONID
	DELETE FROM @CHRONOLOGYIDS WHERE ChronologyID = @CHRONID
  END

/* Nuke Samples */
DECLARE @SAMPLEIDS TABLE
(
  SampleID int PRIMARY KEY
)

INSERT INTO @SAMPLEIDS(SampleID)
SELECT     NDB.Samples.SampleID
FROM       NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID INNER JOIN
                      NDB.Samples ON NDB.AnalysisUnits.AnalysisUnitID = NDB.Samples.AnalysisUnitID
WHERE      (NDB.Sites.SiteID = @SITEID)

DECLARE @SAMPLEID int
WHILE (SELECT COUNT(*) From @SAMPLEIDS) > 0
  BEGIN
    SET @SAMPLEID = (SELECT TOP 1 SampleID FROM @SAMPLEIDS)
	DELETE FROM NDB.Samples WHERE SampleID = @SAMPLEID
	DELETE FROM @SAMPLEIDS WHERE SampleID = @SAMPLEID
  END

/* Nuke AnalysisUnits */
DECLARE @ANALUNITIDS TABLE
(
  AnalUnitID int PRIMARY KEY
)

INSERT INTO @ANALUNITIDS(AnalUnitID)
SELECT     NDB.AnalysisUnits.AnalysisUnitID
FROM       NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID
WHERE      (NDB.Sites.SiteID = @SITEID)

DECLARE @ANALUNITID int
WHILE (SELECT COUNT(*) From @ANALUNITIDS) > 0
  BEGIN
    SET @ANALUNITID = (SELECT TOP 1 AnalUnitID FROM @ANALUNITIDS)
	DELETE FROM NDB.AnalysisUnits WHERE AnalysisUnitID = @ANALUNITID
	DELETE FROM @ANALUNITIDS WHERE AnalUnitID = @ANALUNITID
  END

DELETE FROM NDB.Sites 
WHERE SiteID = @SITEID

GO

-- ----------------------------
-- Procedure structure for DeleteSynonymy
-- ----------------------------




CREATE PROCEDURE [DeleteSynonymy](@SYNONYMYID int, @CONTACTID int)
AS 
Delete from NDB.Synonymy
WHERE SynonymyID = @SYNONYMYID

INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation)
VALUES      (@CONTACTID, N'Synonymy', @SYNONYMYID, N'Delete')




GO

-- ----------------------------
-- Procedure structure for DeleteTaxon
-- ----------------------------




CREATE PROCEDURE [DeleteTaxon](@TAXONID int)
AS 
IF (SELECT COUNT(HigherTaxonID) FROM NDB.TaxaAltHierarchy WHERE (HigherTaxonID = @TAXONID)) > 0
  BEGIN
    DELETE FROM NDB.TaxaAltHierarchy
	WHERE (HigherTaxonID = @TAXONID)
  END
DELETE FROM NDB.Taxa
WHERE TaxonID = @TAXONID

GO

-- ----------------------------
-- Procedure structure for DeleteVariableByVariableID
-- ----------------------------



CREATE PROCEDURE [DeleteVariableByVariableID](@VARIABLEID int)
AS 
Delete from NDB.Variables
WHERE VariableID = @VARIABLEID





GO

-- ----------------------------
-- Procedure structure for DeleteVariableContext
-- ----------------------------




CREATE PROCEDURE [DeleteVariableContext](@VARIABLECONTEXTID int)
AS 
Delete from NDB.VariableContexts
WHERE VariableContextID = @VARIABLECONTEXTID




GO

-- ----------------------------
-- Procedure structure for DeleteVariablesByTaxonID
-- ----------------------------


CREATE PROCEDURE [DeleteVariablesByTaxonID](@TAXONID int)
AS 
Delete from NDB.Variables
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for InsertAccumulationRate
-- ----------------------------



CREATE PROCEDURE [InsertAccumulationRate](@ANALYSISUNITID int, @CHRONOLOGYID int, @ACCRATE float, @VARIABLEUNITSID int)

AS INSERT INTO NDB.AccumulationRates(AnalysisUnitID, ChronologyID, AccumulationRate, VariableUnitsID)
VALUES      (@ANALYSISUNITID, @CHRONOLOGYID, @ACCRATE, @VARIABLEUNITSID)

GO

-- ----------------------------
-- Procedure structure for InsertAggregateChronology
-- ----------------------------


CREATE PROCEDURE [InsertAggregateChronology](@AGGREGATEDATASETID int, 
@AGETYPEID int,
@ISDEFAULT bit,
@CHRONOLOGYNAME nvarchar(80),
@AGEBOUNDYOUNGER int,
@AGEBOUNDOLDER int,
@NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.AggregateChronologies(AggregateDatasetID, AgeTypeID, IsDefault, ChronologyName, AgeBoundYounger, AgeBoundOlder, Notes)
VALUES      (@AGGREGATEDATASETID, @AGETYPEID, @ISDEFAULT, @CHRONOLOGYNAME, @AGEBOUNDYOUNGER, @AGEBOUNDOLDER, @NOTES)

---return id 
Select SCOPE_IDENTITY()

GO

-- ----------------------------
-- Procedure structure for InsertAggregateDataset
-- ----------------------------


CREATE PROCEDURE [InsertAggregateDataset](@NAME nvarchar(80), @ORDERTYPEID int, @NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.AggregateDatasets(AggregateDatasetName, AggregateOrderTypeID, Notes)
VALUES      (@NAME, @ORDERTYPEID, @NOTES)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertAggregateSample
-- ----------------------------


CREATE PROCEDURE [InsertAggregateSample](@AGGREGATEDATASETID int, @SAMPLEID int)
AS 
INSERT INTO NDB.AggregateSamples(AggregateDatasetID, SampleID)
VALUES      (@AGGREGATEDATASETID, @SAMPLEID)

GO

-- ----------------------------
-- Procedure structure for InsertAggregateSampleAges
-- ----------------------------




CREATE PROCEDURE [InsertAggregateSampleAges](@AGGREGATEDATASETID int, @AGGREGATECHRONID int)
AS 
DECLARE @SAMPLEAGEIDS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  SampleAgeID int
)

INSERT INTO @SAMPLEAGEIDS (SampleAgeID)
SELECT   NDB.SampleAges.SampleAgeID
FROM     NDB.AggregateSamples INNER JOIN
            NDB.SampleAges ON NDB.AggregateSamples.SampleID = NDB.SampleAges.SampleID
WHERE   (NDB.AggregateSamples.AggregateDatasetID = @AGGREGATEDATASETID)

DECLARE @NRows int = @@ROWCOUNT
DECLARE @CurrentID int = 0
DECLARE @SAMPLEAGEID int
DECLARE @COUNT int

WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	SET @SAMPLEAGEID = (SELECT SampleAgeID FROM @SAMPLEAGEIDS WHERE ID = @CurrentID)
	SET @COUNT = (SELECT COUNT(*) FROM NDB.AggregateSampleAges
                  WHERE (SampleAgeID = @SAMPLEAGEID) AND (AggregateDatasetID = @AGGREGATEDATASETID) AND (AggregateChronID = @AGGREGATECHRONID))
	IF @COUNT = 0
	  BEGIN
	    INSERT INTO NDB.AggregateSampleAges (AggregateDatasetID, AggregateChronID, SampleAgeID)
        VALUES      (@AGGREGATEDATASETID, @AGGREGATECHRONID, @SAMPLEAGEID)  
	  END
  END


GO

-- ----------------------------
-- Procedure structure for InsertAnalysisUnit
-- ----------------------------




CREATE PROCEDURE [InsertAnalysisUnit](@COLLECTIONUNITID int,
@ANALYSISUNITNAME nvarchar(80) = null,
@DEPTH float = null,
@THICKNESS float = null,
@FACIESID int = null,
@MIXED bit = null,
@IGSN nvarchar(40) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.AnalysisUnits(CollectionUnitID, AnalysisUnitName, Depth, Thickness, FaciesID, Mixed, IGSN, Notes)
VALUES      (@COLLECTIONUNITID, @ANALYSISUNITNAME, @DEPTH, @THICKNESS, @FACIESID, @MIXED, @IGSN, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertAnalysisUnitAltDepth
-- ----------------------------




CREATE PROCEDURE [InsertAnalysisUnitAltDepth](@ANALYSISUNITID int, @ALTDEPTHSCALEID int, @ALTDEPTH float)

AS 
INSERT INTO NDB.AnalysisUnitAltDepths(AnalysisUnitID, AltDepthScaleID, AltDepth)
VALUES      (@ANALYSISUNITID, @ALTDEPTHSCALEID, @ALTDEPTH)




GO

-- ----------------------------
-- Procedure structure for InsertAnalysisUnitAltDepthScale
-- ----------------------------





CREATE PROCEDURE [InsertAnalysisUnitAltDepthScale](@ALTDEPTHID int,
@ALTDEPTHNAME nvarchar(80),
@VARIABLEUNITSID int,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.AnalysisUnitAltDepthScales(AltDepthID, AltDepthName, VariableUnitsID, Notes)
VALUES      (@ALTDEPTHID, @ALTDEPTHNAME, @VARIABLEUNITSID, @NOTES)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertCalibrationProgram
-- ----------------------------




CREATE PROCEDURE [InsertCalibrationProgram](@CALIBRATIONPROGRAM nvarchar(24), @VERSION nvarchar(24))

AS 
INSERT INTO NDB.CalibrationPrograms(CalibrationProgram, Version)
VALUES      (@CALIBRATIONPROGRAM, @VERSION)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertChronControl
-- ----------------------------



CREATE PROCEDURE [InsertChronControl](@CHRONOLOGYID int,
@CHRONCONTROLTYPEID int,
@ANALYSISUNITID int = null,
@DEPTH float = null,
@THICKNESS float = null,
@AGETYPEID int = null,
@AGE float = null,
@AGELIMITYOUNGER float = null,
@AGELIMITOLDER float = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.ChronControls(ChronologyID, ChronControlTypeID, AnalysisUnitID, Depth, Thickness, AgeTypeID, Age, AgeLimitYounger, AgeLimitOlder, Notes)
VALUES      (@CHRONOLOGYID, @CHRONCONTROLTYPEID, @ANALYSISUNITID, @DEPTH, @THICKNESS, @AGETYPEID, @AGE, @AGELIMITYOUNGER, @AGELIMITOLDER, @NOTES)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertChronControlCal14C
-- ----------------------------




CREATE PROCEDURE [InsertChronControlCal14C](@CHRONCONTROLID int, @CALIBRATIONCURVEID int, @CALIBRATIONPROGRAMID int)

AS INSERT INTO NDB.ChronControlsCal14C(ChronControlID, CalibrationCurveID, CalibrationProgramID)
VALUES      (@CHRONCONTROLID, @CALIBRATIONCURVEID, @CALIBRATIONPROGRAMID)


GO

-- ----------------------------
-- Procedure structure for InsertChronControlType
-- ----------------------------



CREATE PROCEDURE [InsertChronControlType](@CHRONCONTROLTYPE nvarchar(64), @HIGHERCHRONCONTROLTYPEID int)
AS 
INSERT INTO NDB.ChronControlTypes(ChronControlType, HigherChronControlTypeID)
VALUES      (@CHRONCONTROLTYPE, @HIGHERCHRONCONTROLTYPEID)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertChronology
-- ----------------------------



CREATE PROCEDURE [InsertChronology](@COLLECTIONUNITID int,
@AGETYPEID int,
@CONTACTID int = null,
@ISDEFAULT bit,
@CHRONOLOGYNAME nvarchar(80) = null,
@DATEPREPARED date = null,
@AGEMODEL nvarchar(80) = null,
@AGEBOUNDYOUNGER int = null,
@AGEBOUNDOLDER int = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Chronologies(CollectionUnitID, AgeTypeID, ContactID, IsDefault, ChronologyName, DatePrepared, AgeModel, AgeBoundYounger, AgeBoundOlder, Notes)
VALUES      (@COLLECTIONUNITID, @AGETYPEID, @CONTACTID, @ISDEFAULT, @CHRONOLOGYNAME, convert(datetime, @DATEPREPARED, 105), @AGEMODEL, @AGEBOUNDYOUNGER, @AGEBOUNDOLDER, @NOTES)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertCollectionUnit
-- ----------------------------



CREATE PROCEDURE [InsertCollectionUnit](@HANDLE nvarchar(10),
@SITEID int,
@COLLTYPEID int = null,
@DEPENVTID int = null,
@COLLUNITNAME nvarchar(255) = null,
@COLLDATE date = null,
@COLLDEVICE nvarchar(255) = null,
@GPSLATITUDE float = null,
@GPSLONGITUDE float = null,
@GPSALTITUDE float = null,
@GPSERROR float = null,
@WATERDEPTH float = null,
@WATERTABLEDEPTH float = null,
@SUBSTRATEID int = null,
@SLOPEASPECT int = null,
@SLOPEANGLE int = null,
@LOCATION nvarchar(255) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.CollectionUnits
                        (Handle, SiteID, CollTypeID, DepEnvtID, CollUnitName, CollDate, CollDevice, GPSLatitude, GPSLongitude, GPSAltitude, GPSError, 
						 WaterDepth, SubstrateID, SlopeAspect, SlopeAngle, Location, Notes)
VALUES      (@HANDLE, @SITEID, @COLLTYPEID, @DEPENVTID, @COLLUNITNAME, convert(datetime, @COLLDATE, 105), @COLLDEVICE, @GPSLATITUDE, @GPSLONGITUDE,
             @GPSALTITUDE, @GPSERROR, @WATERDEPTH, @SUBSTRATEID, @SLOPEASPECT, @SLOPEANGLE, @LOCATION, @NOTES)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertCollector
-- ----------------------------




CREATE PROCEDURE [InsertCollector](@COLLUNITID int, @CONTACTID int, @COLLECTORORDER int)

AS INSERT INTO NDB.Collectors(CollectionUnitID, ContactID, CollectorOrder)
VALUES      (@COLLUNITID, @CONTACTID, @COLLECTORORDER)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertContact
-- ----------------------------


CREATE PROCEDURE [InsertContact](@ALIASID int = null,
@CONTACTNAME nvarchar(80),
@STATUSID int = null,
@FAMILYNAME nvarchar(80) = null,
@INITIALS nvarchar(16) = null,
@GIVENNAMES nvarchar(80) = null,
@SUFFIX nvarchar(16) = null,
@TITLE nvarchar(16) = null,
@PHONE nvarchar(64) = null,
@FAX nvarchar(64) = null,
@EMAIL nvarchar(64) = null,
@URL nvarchar(255) = null,
@ADDRESS nvarchar(MAX) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Contacts
                           (AliasID, ContactName, ContactStatusID, FamilyName, LeadingInitials, GivenNames, Suffix, Title, Phone, Fax, Email, URL, Address, Notes)
VALUES      (@ALIASID, @CONTACTNAME, @STATUSID, @FAMILYNAME, @INITIALS, @GIVENNAMES, @SUFFIX, @TITLE, @PHONE, @FAX, @EMAIL, @URL, @ADDRESS, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertContextDatasetTypes
-- ----------------------------



CREATE PROCEDURE [InsertContextDatasetTypes](@DATASETTYPEID int, @VARIABLECONTEXTID int)

AS 
INSERT INTO NDB.ContextsDatasetTypes(DatasetTypeID, VariableContextID)
VALUES      (@DATASETTYPEID, @VARIABLECONTEXTID)


GO

-- ----------------------------
-- Procedure structure for InsertData
-- ----------------------------


CREATE PROCEDURE [InsertData](@SAMPLEID int, @VARIABLEID int, @VALUE float)

AS INSERT INTO NDB.Data(SampleID, VariableID, Value)
VALUES      (@SAMPLEID, @VARIABLEID, @VALUE)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertDataProcessor
-- ----------------------------




CREATE PROCEDURE [InsertDataProcessor](@DATASETID int, @CONTACTID int)

AS 
INSERT INTO NDB.DataProcessors(DatasetID, ContactID)
VALUES      (@DATASETID, @CONTACTID)






GO

-- ----------------------------
-- Procedure structure for InsertDataset
-- ----------------------------

CREATE PROCEDURE [InsertDataset](@COLLECTIONUNITID int,
@DATASETTYPEID int,
@DATASETNAME nvarchar(80) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Datasets(CollectionUnitID, DatasetTypeID, DatasetName, Notes)
VALUES      (@COLLECTIONUNITID, @DATASETTYPEID, @DATASETNAME, @NOTES)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertDatasetDatabase
-- ----------------------------



CREATE PROCEDURE [InsertDatasetDatabase](@DATASETID int, @DATABASEID int)

AS 
INSERT INTO NDB.DatasetDatabases(DatasetID, DatabaseID)
VALUES      (@DATASETID, @DATABASEID)





GO

-- ----------------------------
-- Procedure structure for InsertDatasetPI
-- ----------------------------



CREATE PROCEDURE [InsertDatasetPI](@DATASETID int, @CONTACTID int, @PIORDER int)

AS 
INSERT INTO NDB.DatasetPIs(DatasetID, ContactID, PIOrder)
VALUES      (@DATASETID, @CONTACTID, @PIORDER)





GO

-- ----------------------------
-- Procedure structure for InsertDatasetPublication
-- ----------------------------



CREATE PROCEDURE [InsertDatasetPublication](@DATASETID int, @PUBLICATIONID int, @PRIMARYPUB bit)

AS 
DECLARE @NRECS int
SET @NRECS = (SELECT COUNT(*) FROM NDB.DatasetPublications GROUP BY DatasetID, PublicationID HAVING (DatasetID = @DATASETID) AND (PublicationID = @PUBLICATIONID))
IF (@NRECS IS NULL)
BEGIN
  INSERT INTO NDB.DatasetPublications(DatasetID, PublicationID, PrimaryPub)
  VALUES      (@DATASETID, @PUBLICATIONID, @PRIMARYPUB)
END





GO

-- ----------------------------
-- Procedure structure for InsertDatasetRepository
-- ----------------------------



CREATE PROCEDURE [InsertDatasetRepository](@DATASETID int, @REPOSITORYID int, @NOTES nvarchar(MAX) = null)

AS 
INSERT INTO NDB.RepositorySpecimens(DatasetID, RepositoryID, Notes)
VALUES      (@DATASETID, @REPOSITORYID, @NOTES)





GO

-- ----------------------------
-- Procedure structure for InsertDatasetSubmission
-- ----------------------------



CREATE PROCEDURE [InsertDatasetSubmission](@DATASETID int, 
@DATABASEID int, 
@CONTACTID int, 
@SUBMISSIONTYPEID int, 
@SUBMISSIONDATE date, 
@NOTES nvarchar(MAX) = null)

AS 
INSERT INTO NDB.DatasetSubmissions(DatasetID, DatabaseID, ContactID, SubmissionTypeID, SubmissionDate, Notes)
VALUES      (@DATASETID, @DATABASEID, @CONTACTID, @SUBMISSIONTYPEID, convert(datetime, @SUBMISSIONDATE, 105), @NOTES)


---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertDatasetTaxonNotes
-- ----------------------------




CREATE PROCEDURE [InsertDatasetTaxonNotes](@DATASETID int, @TAXONID int, @CONTACTID int, @DATE date, @NOTES nvarchar(MAX), @UPDATE bit = 0)

AS 
INSERT INTO NDB.DatasetTaxonNotes(DatasetID, TaxonID, ContactID, Date, Notes)
VALUES      (@DATASETID, @TAXONID, @CONTACTID, convert(datetime, @DATE, 105), @NOTES)
IF @UPDATE = 1
  BEGIN
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation)
    VALUES      (@CONTACTID, N'DatasetTaxonNotes', @DATASETID, @TAXONID, N'Insert')
  END

GO

-- ----------------------------
-- Procedure structure for InsertDepAgent
-- ----------------------------





CREATE PROCEDURE [InsertDepAgent](@ANALYSISUNITID int, @DEPAGENTID int)

AS 
INSERT INTO NDB.DepAgents(AnalysisUnitID, DepAgentID)
VALUES      (@ANALYSISUNITID, @DEPAGENTID)





GO

-- ----------------------------
-- Procedure structure for InsertDepAgentTypes
-- ----------------------------



CREATE PROCEDURE [InsertDepAgentTypes](@DEPAGENT nvarchar(64))
AS 
INSERT INTO NDB.DepAgentTypes(DepAgent)
VALUES      (@DEPAGENT)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertDepEnvtType
-- ----------------------------


CREATE PROCEDURE [InsertDepEnvtType](@DEPENVT nvarchar(255),
@DEPENVTHIGHERID int = null)
AS INSERT INTO NDB.DepEnvtTypes
                        (DepEnvt, DepEnvtHigherID)
VALUES      (@DEPENVT, @DEPENVTHIGHERID)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertEcolGroup
-- ----------------------------



CREATE PROCEDURE [InsertEcolGroup](@TAXONID int, @ECOLSETID int, @ECOLGROUPID nvarchar(4))

AS 
INSERT INTO NDB.EcolGroups (TaxonID, EcolSetID, EcolGroupID)
VALUES      (@TAXONID, @ECOLSETID, @ECOLGROUPID)



GO

-- ----------------------------
-- Procedure structure for InsertEcolGroupType
-- ----------------------------


CREATE PROCEDURE [InsertEcolGroupType](@ECOLGROUPID nvarchar(4), @ECOLGROUP nvarchar(64))

AS 
INSERT INTO NDB.EcolGroupTypes (EcolGroupID, EcolGroup)
VALUES      (@ECOLGROUPID, @ECOLGROUP)


GO

-- ----------------------------
-- Procedure structure for InsertElementDatasetTaxaGroups
-- ----------------------------





CREATE PROCEDURE [InsertElementDatasetTaxaGroups](@DATASETTYPEID int, @TAXAGROUPID nvarchar(3), @ELEMENTTYPEID int)

AS 
INSERT INTO NDB.ElementDatasetTaxaGroups (DatasetTypeID, TaxaGroupID, ElementTypeID)
VALUES      (@DATASETTYPEID, @TAXAGROUPID, @ELEMENTTYPEID)


GO

-- ----------------------------
-- Procedure structure for InsertElementMaturity
-- ----------------------------







CREATE PROCEDURE [InsertElementMaturity](@MATURITY nvarchar(36))

AS 
INSERT INTO NDB.ElementMaturities(Maturity)
VALUES      (@MATURITY)

---return id 
Select SCOPE_IDENTITY()











GO

-- ----------------------------
-- Procedure structure for InsertElementPortion
-- ----------------------------






CREATE PROCEDURE [InsertElementPortion](@PORTION nvarchar(48))

AS 
INSERT INTO NDB.ElementPortions(Portion)
VALUES      (@PORTION)

---return id 
Select SCOPE_IDENTITY()










GO

-- ----------------------------
-- Procedure structure for InsertElementSymmetry
-- ----------------------------





CREATE PROCEDURE [InsertElementSymmetry](@SYMMETRY nvarchar(24))

AS 
INSERT INTO NDB.ElementSymmetries (Symmetry)
VALUES      (@SYMMETRY)

---return id 
Select SCOPE_IDENTITY()









GO

-- ----------------------------
-- Procedure structure for InsertElementTaxaGroupMaturity
-- ----------------------------








CREATE PROCEDURE [InsertElementTaxaGroupMaturity](@ELEMENTTAXAGROUPID int, @MATURITYID int)

AS 
INSERT INTO NDB.ElementTaxaGroupMaturities(ElementTaxaGroupID, MaturityID)
VALUES      (@ELEMENTTAXAGROUPID, @MATURITYID)





GO

-- ----------------------------
-- Procedure structure for InsertElementTaxaGroupPortion
-- ----------------------------







CREATE PROCEDURE [InsertElementTaxaGroupPortion](@ELEMENTTAXAGROUPID int, @PORTIONID int)

AS 
INSERT INTO NDB.ElementTaxaGroupPortions(ElementTaxaGroupID, PortionID)
VALUES      (@ELEMENTTAXAGROUPID, @PORTIONID)




GO

-- ----------------------------
-- Procedure structure for InsertElementTaxaGroups
-- ----------------------------






CREATE PROCEDURE [InsertElementTaxaGroups](@TAXAGROUPID nvarchar(3), @ELEMENTTYPEID int)

AS 
INSERT INTO NDB.ElementTaxaGroups (TaxaGroupID, ElementTypeID)
VALUES      (@TAXAGROUPID, @ELEMENTTYPEID)

---return id 
Select SCOPE_IDENTITY()


GO

-- ----------------------------
-- Procedure structure for InsertElementTaxaGroupSymmetry
-- ----------------------------






CREATE PROCEDURE [InsertElementTaxaGroupSymmetry](@ELEMENTTAXAGROUPID int, @SYMMETRYID int)

AS 
INSERT INTO NDB.ElementTaxaGroupSymmetries(ElementTaxaGroupID, SymmetryID)
VALUES      (@ELEMENTTAXAGROUPID, @SYMMETRYID)



GO

-- ----------------------------
-- Procedure structure for InsertElementType
-- ----------------------------




CREATE PROCEDURE [InsertElementType](@ELEMENTTYPE nvarchar(64))

AS 
INSERT INTO NDB.ElementTypes (ElementType)
VALUES      (@ELEMENTTYPE)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertEPDEntityDatasetID
-- ----------------------------




CREATE PROCEDURE [InsertEPDEntityDatasetID](@ENR int, @DATASETID int)

AS 
INSERT INTO EPD.dbo.EntityDatasetID(E#, DatasetID)
VALUES      (@ENR, @DATASETID)
---return id 
Select SCOPE_IDENTITY()


GO

-- ----------------------------
-- Procedure structure for InsertEvent
-- ----------------------------




CREATE PROCEDURE [InsertEvent](@EVENTTYPEID int,
@EVENTNAME nvarchar(80),
@C14AGE float = null,
@C14AGEYOUNGER float = null,
@C14AGEOLDER float = null,
@CALAGE float = null,
@CALAGEYOUNGER float = null,
@CALAGEOLDER float = null,
@NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.Events
                        (EventTypeID, EventName, C14Age, C14AgeYounger, C14AgeOlder, CalAge, CalAgeYounger, CalAgeOlder, Notes)
VALUES      (@EVENTTYPEID, @EVENTNAME, @C14AGE, @C14AGEYOUNGER, @C14AGEOLDER, @CALAGE, @CALAGEYOUNGER, @CALAGEOLDER, @NOTES)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertEventChronology
-- ----------------------------


CREATE PROCEDURE [InsertEventChronology](@ANALYSISUNITID int, @EVENTID int, @CHRONCONTROLID int, @NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.EventChronology (AnalysisUnitID, EventID, ChronControlID, Notes)
VALUES      (@ANALYSISUNITID, @EVENTID, @CHRONCONTROLID, @NOTES)

---return id 
Select SCOPE_IDENTITY()



GO

-- ----------------------------
-- Procedure structure for InsertEventPublication
-- ----------------------------




CREATE PROCEDURE [InsertEventPublication](@EVENTID int, @PUBLICATIONID int)

AS 
INSERT INTO NDB.EventPublications(EventID, PublicationID)
VALUES      (@EVENTID, @PUBLICATIONID)




GO

-- ----------------------------
-- Procedure structure for InsertFaciesTypes
-- ----------------------------


CREATE PROCEDURE [InsertFaciesTypes](@FACIES nvarchar(64))
AS 
INSERT INTO NDB.FaciesTypes(Facies)
VALUES      (@FACIES)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertFormTaxon
-- ----------------------------





CREATE PROCEDURE [InsertFormTaxon](@TAXONID int,
@AFFINITYID int,
@PUBLICATIONID int,
@SYSTEMATICDESCRIPTION bit)

AS INSERT INTO NDB.FormTaxa(TaxonID, AffinityID, PublicationID, SystematicDescription)
VALUES      (@TAXONID, @AFFINITYID, @PUBLICATIONID, @SYSTEMATICDESCRIPTION)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertFractionDated
-- ----------------------------



CREATE PROCEDURE [InsertFractionDated](@FRACTION nvarchar(80))
AS 
INSERT INTO NDB.FractionDated(Fraction)
VALUES      (@FRACTION)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertGeochron
-- ----------------------------


CREATE PROCEDURE [InsertGeochron](@SAMPLEID int,
@GEOCHRONTYPEID int,
@AGETYPEID int,
@AGE float = null,
@ERROROLDER float = null,
@ERRORYOUNGER float = null,
@INFINITE bit = 0,
@DELTA13C float = null,
@LABNUMBER nvarchar(40) = null,
@MATERIALDATED nvarchar(255) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Geochronology(SampleID, GeochronTypeID, AgeTypeID, Age, ErrorOlder, ErrorYounger, Infinite, Delta13C, LabNumber, MaterialDated, Notes)
VALUES      (@SAMPLEID, @GEOCHRONTYPEID, @AGETYPEID, @AGE, @ERROROLDER, @ERRORYOUNGER, @INFINITE, @DELTA13C, @LABNUMBER, @MATERIALDATED, @NOTES)

---return id 
Select SCOPE_IDENTITY()









GO

-- ----------------------------
-- Procedure structure for InsertGeoChronControl
-- ----------------------------




CREATE PROCEDURE [InsertGeoChronControl](@CHRONCONTROLID int, @GEOCHRONID int)

AS 
INSERT INTO NDB.GeoChronControls(ChronControlID, GeochronID)
VALUES      (@CHRONCONTROLID, @GEOCHRONID)






GO

-- ----------------------------
-- Procedure structure for InsertGeochronParameterValue
-- ----------------------------



CREATE PROCEDURE [InsertGeochronParameterValue](@GEOCHRONPARAMETERID int, @FLOATVALUE float = null, @CHARVALUE nvarchar(1024) = null)

AS 
IF @FLOATVALUE IS NOT NULL
  BEGIN
    INSERT INTO NDB.GeochronParameterValues(GeochronParameterID, ParameterValue)
    VALUES      (@GEOCHRONPARAMETERID, CAST(@FLOATVALUE AS nvarchar(128)))
  END
ELSE IF @CHARVALUE IS NOT NULL
  BEGIN
    INSERT INTO NDB.GeochronParameterValues(GeochronParameterID, ParameterValue)
    VALUES      (@GEOCHRONPARAMETERID, @CHARVALUE)
  END

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertGeochronPublication
-- ----------------------------


CREATE PROCEDURE [InsertGeochronPublication](@GEOCHRONID int, @PUBLICATIONID int)

AS 
INSERT INTO NDB.GeochronPublications(GeochronID, PublicationID)
VALUES      (@GEOCHRONID, @PUBLICATIONID)



GO

-- ----------------------------
-- Procedure structure for InsertGeoPoliticalUnit
-- ----------------------------




CREATE PROCEDURE [InsertGeoPoliticalUnit](@GEOPOLNAME nvarchar(255),
@GEOPOLUNIT nvarchar(255),
@RANK int,
@HIGHERID int)

AS INSERT INTO NDB.GeoPoliticalUnits
                        (GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID)
VALUES      (@GEOPOLNAME, @GEOPOLUNIT, @RANK, @HIGHERID)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertIsoInstrumention
-- ----------------------------




CREATE PROCEDURE [InsertIsoInstrumention](@DATASETID int, 
@VARIABLEID int, 
@ISOINSTRUMENTATIONTYPEID int = null,
@ISOSAMPLEINTROSYSTEMTYPEID int = null,
@INSTERRORPERCENT float = null,
@INSTERRORRUNSD float = null,
@INSTERRORLONGTERMPERCENT float = null,
@NOTES nvarchar(MAX) = null
)
AS 
INSERT INTO NDB.IsoInstrumentation (DatasetID, VariableID, IsoInstrumentationTypeID, IsoSampleIntroSystemTypeID, 
                                    InstErrorPercent, InstErrorRunSD, InstErrorLongTermPercent, Notes)
VALUES      (@DATASETID, @VARIABLEID, @ISOINSTRUMENTATIONTYPEID, @ISOSAMPLEINTROSYSTEMTYPEID, @INSTERRORPERCENT, @INSTERRORRUNSD, @INSTERRORLONGTERMPERCENT, @NOTES)







GO

-- ----------------------------
-- Procedure structure for InsertIsoMetadata
-- ----------------------------



CREATE PROCEDURE [InsertIsoMetadata](@DATAID int, 
@ISOMATANALTYPEID int = null, 
@ISOSUBSTRATETYPEID int = null,
@ANALYSTID int = null,
@LAB nvarchar(255) = null,
@LABNUMBER nvarchar(64) = null,
@MASSMG float = null,
@WEIGHTPERCENT float = null,
@ATOMICPERCENT float = null,
@REPS int = null)

AS 
INSERT INTO NDB.IsoMetadata(DataID, IsoMatAnalTypeID, IsoSubstrateTypeID, AnalystID, Lab, LabNumber, Mass_mg, WeightPercent, AtomicPercent, Reps)
VALUES      (@DATAID, @ISOMATANALTYPEID, @ISOSUBSTRATETYPEID, @ANALYSTID, @LAB, @LABNUMBER, @MASSMG, @WEIGHTPERCENT, @ATOMICPERCENT, @REPS)



GO

-- ----------------------------
-- Procedure structure for InsertIsoSamplePretreatments
-- ----------------------------



CREATE PROCEDURE [InsertIsoSamplePretreatments](@DATAID int, @ISOPRETREATMENTTYPEID int, @ORDER int, @VALUE float = null)

AS 
INSERT INTO NDB.IsoSamplePretreatments(DataID, IsoPretreatmentTypeID, [Order], Value)
VALUES      (@DATAID, @ISOPRETREATMENTTYPEID, @ORDER, @VALUE)



GO

-- ----------------------------
-- Procedure structure for InsertIsoSpecimenData
-- ----------------------------





CREATE PROCEDURE [InsertIsoSpecimenData](@DATAID int, @SPECIMENID int, @SD float = null)

AS 
INSERT INTO NDB.IsoSpecimenData(DataID, SpecimenID, SD)
VALUES      (@DATAID, @SPECIMENID, @SD)


GO

-- ----------------------------
-- Procedure structure for InsertIsoSrMetadata
-- ----------------------------





CREATE PROCEDURE [InsertIsoSrMetadata](@DATASETID int, 
@VARIABLEID int, 
@SRLOCALVALUE nvarchar(MAX) = null,
@SRLOCALGEOLCONTEXT nvarchar(MAX) = null
)
AS 
INSERT INTO NDB.IsoSrMetadata(DatasetID, VariableID, SrLocalValue, SrLocalGeolContext)
VALUES      (@DATASETID, @VARIABLEID, @SRLOCALVALUE, @SRLOCALGEOLCONTEXT)








GO

-- ----------------------------
-- Procedure structure for InsertIsoStandards
-- ----------------------------



CREATE PROCEDURE [InsertIsoStandards](@DATASETID int, @VARIABLEID int, @ISOSTANDARDID int, @VALUE float)
AS 
INSERT INTO NDB.IsoStandards(DatasetID, VariableID, IsoStandardID, Value)
VALUES      (@DATASETID, @VARIABLEID, @ISOSTANDARDID, @VALUE)





GO

-- ----------------------------
-- Procedure structure for InsertIsoStratData
-- ----------------------------






CREATE PROCEDURE [InsertIsoStratData](@DATAID int, @SD float = null, @TAXONID int = null, @ELEMENTTYPEID int = null)

AS 
INSERT INTO NDB.IsoStratData(DataID, SD, TaxonID, ElementTypeID)
VALUES      (@DATAID, @SD, @TAXONID, @ELEMENTTYPEID)






GO

-- ----------------------------
-- Procedure structure for InsertLakeParameter
-- ----------------------------



CREATE PROCEDURE [InsertLakeParameter](@SITEID int,
@LAKEPARAMETERID int, @VALUE float)
AS INSERT INTO NDB.LakeParameters
                        (SiteID, LakeParameterID, Value)
VALUES      (@SITEID, @LAKEPARAMETERID, @VALUE)






GO

-- ----------------------------
-- Procedure structure for InsertLithology
-- ----------------------------





CREATE PROCEDURE [InsertLithology](@COLLECTIONUNITID int,
@DEPTHTOP float = null,
@DEPTHBOTTOM float = null,
@LOWERBOUNDARY nvarchar(255) = null,
@DESCRIPTION nvarchar(MAX) = null)

AS INSERT INTO NDB.Lithology(CollectionUnitID, DepthTop, DepthBottom, LowerBoundary, Description)
VALUES      (@COLLECTIONUNITID, @DEPTHTOP, @DEPTHBOTTOM, @LOWERBOUNDARY, @DESCRIPTION)

---return id 
Select SCOPE_IDENTITY()








GO

-- ----------------------------
-- Procedure structure for InsertNewDatasetPI
-- ----------------------------




CREATE PROCEDURE [InsertNewDatasetPI](@DATASETID int, @CONTACTID int)
AS
DECLARE @NPIS int
SET @NPIS = (SELECT COUNT(*) FROM NDB.DatasetPIs WHERE (DatasetID = @DATASETID))
DECLARE @PIORDER int = @NPIS + 1
INSERT INTO NDB.DatasetPIs(DatasetID, ContactID, PIOrder)
VALUES      (@DATASETID, @CONTACTID, @PIORDER)






GO

-- ----------------------------
-- Procedure structure for InsertPublication
-- ----------------------------




CREATE PROCEDURE [InsertPublication](@PUBTYPEID int,
@YEAR nvarchar(64) = null,
@CITATION nvarchar(MAX),
@TITLE nvarchar(MAX) = null,
@JOURNAL nvarchar(MAX) = null,
@VOL nvarchar(16) = null,
@ISSUE nvarchar(8) = null,
@PAGES nvarchar(24) = null,
@CITNUMBER nvarchar(24) = null,
@DOI nvarchar(128) = null,
@BOOKTITLE nvarchar(MAX) = null,
@NUMVOL nvarchar(8) = null,
@EDITION nvarchar(24) = null,
@VOLTITLE nvarchar(MAX) = null,
@SERTITLE nvarchar(MAX) = null,
@SERVOL nvarchar(16) = null,
@PUBLISHER nvarchar(255) = null,
@URL nvarchar(MAX) = null,
@CITY nvarchar(64) = null,
@STATE nvarchar(64) = null,
@COUNTRY nvarchar(64) = null,
@ORIGLANG nvarchar(64) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Publications
                        (PubTypeID, Year, Citation, ArticleTitle, Journal, Volume, Issue, Pages, CitationNumber, DOI, BookTitle, 
                        NumVolumes, Edition, VolumeTitle, SeriesTitle, SeriesVolume, Publisher, URL, City, State, Country, 
                        OriginalLanguage, Notes)
VALUES      (@PUBTYPEID, @YEAR, @CITATION, @TITLE, @JOURNAL, @VOL, @ISSUE, @PAGES, @CITNUMBER, @DOI, @BOOKTITLE, @NUMVOL, @EDITION,
             @VOLTITLE, @SERTITLE, @SERVOL, @PUBLISHER, @URL, @CITY, @STATE, @COUNTRY, @ORIGLANG, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertPublicationAuthors
-- ----------------------------




CREATE PROCEDURE [InsertPublicationAuthors](@PUBLICATIONID int,
@AUTHORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null,
@CONTACTID int)

AS INSERT INTO NDB.PublicationAuthors (PublicationID, AuthorOrder, FamilyName, Initials, Suffix, ContactID)
VALUES      (@PUBLICATIONID, @AUTHORORDER, @FAMILYNAME, @INITIALS, @SUFFIX, @CONTACTID)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertPublicationEditors
-- ----------------------------




CREATE PROCEDURE [InsertPublicationEditors](@PUBLICATIONID int,
@EDITORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null)

AS INSERT INTO NDB.PublicationEditors (PublicationID, EditorOrder, FamilyName, Initials, Suffix)
VALUES      (@PUBLICATIONID, @EDITORORDER, @FAMILYNAME, @INITIALS, @SUFFIX)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertPublicationTranslators
-- ----------------------------




CREATE PROCEDURE [InsertPublicationTranslators](@PUBLICATIONID int,
@TRANSLATORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null)

AS INSERT INTO NDB.PublicationTranslators (PublicationID, TranslatorOrder, FamilyName, Initials, Suffix)
VALUES      (@PUBLICATIONID, @TRANSLATORORDER, @FAMILYNAME, @INITIALS, @SUFFIX)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertRadiocarbon
-- ----------------------------



CREATE PROCEDURE [InsertRadiocarbon](@GEOCHRONID int,
@RADIOCARBONMETHODID int = null,
@PERCENTC float = null,
@PERCENTN float = null,
@DELTA13C float = null,
@DELTA15N float = null,
@PERCENTCOLLAGEN float = null,
@RESERVOIR float = null)

AS 
INSERT INTO NDB.Radiocarbon(GeochronID, RadiocarbonMethodID, PercentC, PercentN, Delta13C, Delta15N, PercentCollagen, Reservoir)
VALUES      (@GEOCHRONID, @RADIOCARBONMETHODID, @PERCENTC, @PERCENTN, @DELTA13C, @DELTA15N, @PERCENTCOLLAGEN, @RESERVOIR)



GO

-- ----------------------------
-- Procedure structure for InsertRelativeAge
-- ----------------------------



CREATE PROCEDURE [InsertRelativeAge](@RELATIVEAGEUNITID int,
@RELATIVEAGESCALEID int,
@RELATIVEAGE nvarchar(64),
@C14AGEYOUNGER float = null,
@C14AGEOLDER float = null,
@CALAGEYOUNGER float = null,
@CALAGEOLDER float = null,
@NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.RelativeAges
                        (RelativeAgeUnitID, RelativeAgeScaleID, RelativeAge, C14AgeYounger, C14AgeOlder, CalAgeYounger, CalAgeOlder, Notes)
VALUES      (@RELATIVEAGEUNITID, @RELATIVEAGESCALEID, @RELATIVEAGE, @C14AGEYOUNGER, @C14AGEOLDER, @CALAGEYOUNGER, @CALAGEOLDER, @NOTES)

---return id 
Select SCOPE_IDENTITY()



GO

-- ----------------------------
-- Procedure structure for InsertRelativeAgePublication
-- ----------------------------


CREATE PROCEDURE [InsertRelativeAgePublication](@RELATIVEAGEID int, @PUBLICATIONID int)

AS 
INSERT INTO NDB.RelativeAgePublications(RelativeAgeID, PublicationID)
VALUES      (@RELATIVEAGEID, @PUBLICATIONID)





GO

-- ----------------------------
-- Procedure structure for InsertRelativeChronology
-- ----------------------------


CREATE PROCEDURE [InsertRelativeChronology](@ANALYSISUNITID int, @RELATIVEAGEID int, @CHRONCONTROLID int, @NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.RelativeChronology(AnalysisUnitID, RelativeAgeID, ChronControlID, Notes)
VALUES      (@ANALYSISUNITID, @RELATIVEAGEID, @CHRONCONTROLID, @NOTES)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertRepositoryInstitution
-- ----------------------------


CREATE PROCEDURE [InsertRepositoryInstitution](@ACRONYM nvarchar(64), @REPOSITORY nvarchar(128), @NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.RepositoryInstitutions(Acronym, Repository, Notes)
VALUES      (@ACRONYM, @REPOSITORY, @NOTES)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertSample
-- ----------------------------

CREATE PROCEDURE [InsertSample](@ANALYSISUNITID int,
@DATASETID int,
@SAMPLENAME nvarchar(80) = null,
@SAMPLEDATE date = null,
@ANALYSISDATE date = null,
@TAXONID int = null,
@LABNUMBER nvarchar(40) = null,
@PREPMETHOD nvarchar(MAX) = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Samples(AnalysisUnitID, DatasetID, SampleName, SampleDate, AnalysisDate, TaxonID, LabNumber, PreparationMethod, Notes)
VALUES      (@ANALYSISUNITID, @DATASETID, @SAMPLENAME, convert(datetime, @SAMPLEDATE, 105), convert(datetime, @ANALYSISDATE, 105), 
             @TAXONID, @LABNUMBER, @PREPMETHOD, @NOTES)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertSampleAge
-- ----------------------------


CREATE PROCEDURE [InsertSampleAge](@SAMPLEID int, 
@CHRONOLOGYID int, 
@AGE float = null,
@AGEYOUNGER float = null,
@AGEOLDER float = null)

AS INSERT INTO NDB.SampleAges(SampleID, ChronologyID, Age, AgeYounger, AgeOlder)
VALUES      (@SAMPLEID, @CHRONOLOGYID, @AGE, @AGEYOUNGER, @AGEOLDER)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertSampleAnalyst
-- ----------------------------


CREATE PROCEDURE [InsertSampleAnalyst](@SAMPLEID int, @CONTACTID int, @ANALYSTORDER int)

AS INSERT INTO NDB.SampleAnalysts(SampleID, ContactID, AnalystOrder)
VALUES      (@SAMPLEID, @CONTACTID, @ANALYSTORDER)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertSampleKeyword
-- ----------------------------




CREATE PROCEDURE [InsertSampleKeyword](@SAMPLEID int, @KEYWORDID int)

AS 
INSERT INTO NDB.SampleKeywords(SampleID, KeywordID)
VALUES      (@SAMPLEID, @KEYWORDID)




GO

-- ----------------------------
-- Procedure structure for InsertSite
-- ----------------------------


CREATE PROCEDURE [InsertSite](@SITENAME nvarchar(128),
@EAST float,
@NORTH float,
@WEST float,
@SOUTH float,
@ALTITUDE int = null,
@AREA float = null,
@DESCRIPT nvarchar(MAX) = null,
@NOTES nvarchar(MAX) = null)

AS 
DECLARE @GEOG geography
IF ((@NORTH > @SOUTH) AND (@EAST > @WEST))
  SET @GEOG = geography::STGeomFromText('POLYGON((' + 
              CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
              CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + '))', 4326).MakeValid()
ELSE
  SET @GEOG = geography::STGeomFromText('POINT(' + CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ')', 4326).MakeValid()   

INSERT INTO NDB.Sites (SiteName, Altitude, Area, SiteDescription, Notes, geog)
VALUES      (@SITENAME, @ALTITUDE, @AREA, @DESCRIPT, @NOTES, @GEOG)


---return id 
Select SCOPE_IDENTITY()


GO

-- ----------------------------
-- Procedure structure for InsertSiteGeoPol
-- ----------------------------



CREATE PROCEDURE [InsertSiteGeoPol](@SITEID int, @GEOPOLITICALID int)

AS INSERT INTO NDB.SiteGeoPolitical(SiteID, GeoPoliticalID)
VALUES      (@SITEID, @GEOPOLITICALID)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertSpecimen
-- ----------------------------


CREATE PROCEDURE [InsertSpecimen](@DATAID int,
@ELEMENTTYPEID int = null,
@SYMMETRYID int = null,
@PORTIONID int = null,
@MATURITYID int = null,
@SEXID int = null,
@DOMESTICSTATUSID int = null,
@PRESERVATIVE nvarchar(256) = null,
@NISP float = null,
@REPOSITORYID int = null,
@SPECIMENNR nvarchar(50) = null,
@FIELDNR nvarchar(50) = null,
@ARCTOSNR nvarchar(50) = null,
@NOTES nvarchar(MAX) = null)

AS 
INSERT INTO NDB.Specimens (DataID, ElementTypeID, SymmetryID, PortionID, MaturityID, SexID, DomesticStatusID, Preservative,
            NISP, RepositoryID, SpecimenNr, FieldNr, ArctosNr, Notes)
VALUES (@DATAID, @ELEMENTTYPEID, @SYMMETRYID, @PORTIONID, @MATURITYID, @SEXID, @DOMESTICSTATUSID, @PRESERVATIVE,
  @NISP, @REPOSITORYID, @SPECIMENNR, @FIELDNR, @ARCTOSNR, @NOTES)



---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertSpecimenDate
-- ----------------------------




CREATE PROCEDURE [InsertSpecimenDate](@GEOCHRONID int,
@SPECIMENID int = null,
@TAXONID int,
@ELEMENTTYPEID int = null,
@FRACTIONID int = null,
@SAMPLEID int,
@NOTES nvarchar(MAX) = null)

AS 
INSERT INTO NDB.SpecimenDates
                        (GeochronID, SpecimenID, TaxonID, ElementTypeID, FractionID, SampleID, Notes)
VALUES      (@GEOCHRONID, @SPECIMENID, @TAXONID, @ELEMENTTYPEID, @FRACTIONID, @SAMPLEID, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertSpecimenDateCal
-- ----------------------------




CREATE PROCEDURE [InsertSpecimenDateCal](@SPECIMENDATEID int,
@CALAGE float = null,
@CALAGEOLDER float = null,
@CALAGEYOUNGER float = null,
@CALIBRATIONCURVEID int = null,
@CALIBRATIONPROGRAMID int = null,
@DATECALIBRATED date = null)

AS 
INSERT INTO NDB.SpecimenDatesCal
                        (SpecimenDateID, CalAge, CalAgeOlder, CalAgeYounger, CalibrationCurveID, CalibrationProgramID, DateCalibrated)
VALUES      (@SPECIMENDATEID, @CALAGE, @CALAGEOLDER, @CALAGEYOUNGER, @CALIBRATIONCURVEID, @CALIBRATIONPROGRAMID, convert(datetime, @DATECALIBRATED, 105))

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertSpecimenGenBankNr
-- ----------------------------



CREATE PROCEDURE [InsertSpecimenGenBankNr](@SPECIMENID int, @GENBANKNR nvarchar(50))

AS 
INSERT INTO NDB.SpecimenGenBank(SpecimenID, GenBankNr)
VALUES      (@SPECIMENID, @GENBANKNR)



GO

-- ----------------------------
-- Procedure structure for InsertSpecimenTaphonomy
-- ----------------------------




CREATE PROCEDURE [InsertSpecimenTaphonomy](@SPECIMENID int, @TAPHONOMICTYPEID int)

AS 
INSERT INTO NDB.SpecimenTaphonomy(SpecimenID, TaphonomicTypeID)
VALUES      (@SPECIMENID, @TAPHONOMICTYPEID)




GO

-- ----------------------------
-- Procedure structure for InsertSteward
-- ----------------------------




CREATE PROCEDURE [InsertSteward](@CONTACTID int, 
@USERNAME nvarchar(15), 
@PASSWORD nvarchar(15),
@TAXONOMYEXPERT bit,
@DATABASEID int)

AS 
INSERT INTO TI.Stewards(ContactID, username, pwd, TaxonomyExpert)
VALUES      (@CONTACTID, @USERNAME, @PASSWORD, @TAXONOMYEXPERT)

DECLARE @STEWARDID int
SET @STEWARDID = (SELECT StewardID FROM TI.Stewards WHERE (ContactID = @CONTACTID))

INSERT INTO TI.StewardDatabases(StewardID, DatabaseID)
VALUES      (@STEWARDID, @DATABASEID)




GO

-- ----------------------------
-- Procedure structure for InsertSummaryDataTaphonomy
-- ----------------------------





CREATE PROCEDURE [InsertSummaryDataTaphonomy](@DATAID int, @TAPHONOMICTYPEID int)

AS 
INSERT INTO NDB.SummaryDataTaphonomy(DataID, TaphonomicTypeID)
VALUES      (@DATAID, @TAPHONOMICTYPEID)





GO

-- ----------------------------
-- Procedure structure for InsertSynonym
-- ----------------------------




CREATE PROCEDURE [InsertSynonym](@INVALIDTAXONID int, @VALIDTAXONID int, @SYNONYMTYPEID int = null)
AS 
INSERT INTO NDB.Synonyms(InvalidTaxonID, ValidTaxonID, SynonymTypeID)
VALUES      (@INVALIDTAXONID, @VALIDTAXONID, @SYNONYMTYPEID)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertSynonymType
-- ----------------------------



CREATE PROCEDURE [InsertSynonymType](@SYNONYMTYPE nvarchar(255))
AS INSERT INTO NDB.SynonymTypes(SynonymType)
VALUES      (@SYNONYMTYPE)

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertSynonymy
-- ----------------------------




CREATE PROCEDURE [InsertSynonymy](@DATASETID int,
@TAXONID int,
@REFTAXONID int,
@FROMCONTRIBUTOR bit = 0,
@PUBLICATIONID int = null,
@NOTES nvarchar(MAX) = null,
@CONTACTID int = null,
@DATESYNONYMIZED date = null)

AS 
INSERT INTO NDB.Synonymy(DatasetID, TaxonID, RefTaxonID, FromContributor, PublicationID, Notes, ContactID, DateSynonymized)
VALUES  (@DATASETID, @TAXONID, @REFTAXONID, @FROMCONTRIBUTOR, @PUBLICATIONID, @NOTES, @CONTACTID, convert(datetime, @DATESYNONYMIZED, 105))              


---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertTaphonomicSystem
-- ----------------------------



CREATE PROCEDURE [InsertTaphonomicSystem](@TAPHONOMICSYSTEM nvarchar(64),
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.TaphonomicSystems
                        (TaphonomicSystem, Notes)
VALUES      (@TAPHONOMICSYSTEM, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertTaphonomicSystemDatasetType
-- ----------------------------




CREATE PROCEDURE [InsertTaphonomicSystemDatasetType](@DATASETTYPEID int,
@TAPHONOMICSYSTEMID int)

AS INSERT INTO NDB.TaphonomicSystemsDatasetTypes
                        (DatasetTypeID, TaphonomicSystemID)
VALUES      (@DATASETTYPEID, @TAPHONOMICSYSTEMID)




GO

-- ----------------------------
-- Procedure structure for InsertTaphonomicType
-- ----------------------------



CREATE PROCEDURE [InsertTaphonomicType](@TAPHONOMICSYSTEMID int,
@TAPHONOMICTYPE nvarchar(64),
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.TaphonomicTypes
                        (TaphonomicSystemID, TaphonomicType, Notes)
VALUES      (@TAPHONOMICSYSTEMID, @TAPHONOMICTYPE, @NOTES)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertTaxaGroup
-- ----------------------------




CREATE PROCEDURE [InsertTaxaGroup](@TAXAGROUPID nvarchar(3), @TAXAGROUP nvarchar(64))

AS 
INSERT INTO NDB.TaxaGroupTypes (TaxaGroupID, TaxaGroup)
VALUES      (@TAXAGROUPID, @TAXAGROUP)

GO

-- ----------------------------
-- Procedure structure for InsertTaxon
-- ----------------------------



CREATE PROCEDURE [InsertTaxon](@CODE nvarchar(64),
@NAME nvarchar(80),
@AUTHOR nvarchar(128) = null,
@VALID bit = 1,
@HIGHERID int = null,
@EXTINCT bit = 0,
@GROUPID nvarchar(3),
@PUBID int = null,
@VALIDATORID int = null,
@VALIDATEDATE date = null,
@NOTES nvarchar(MAX) = null)

AS INSERT INTO NDB.Taxa
                        (TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, ValidatorID, ValidateDate, Notes)
VALUES      (@CODE, @NAME, @AUTHOR, @VALID, @HIGHERID, @EXTINCT, @GROUPID, @PUBID, @VALIDATORID, convert(datetime, @VALIDATEDATE, 105), @NOTES)

IF @HIGHERID = -1
BEGIN
  DECLARE @ID int
  SET @ID = SCOPE_IDENTITY()
  UPDATE NDB.Taxa
  SET    NDB.Taxa.HigherTaxonID = @ID
  WHERE  (NDB.Taxa.TaxonID = @ID)
END

---return id 
Select SCOPE_IDENTITY()






GO

-- ----------------------------
-- Procedure structure for InsertTephra
-- ----------------------------


CREATE PROCEDURE [InsertTephra](@EVENTID int, @ANALYSISUNITID int, @NOTES nvarchar(MAX) = null)
AS 
INSERT INTO NDB.Tephras(EventID, AnalysisUnitID, Notes)
VALUES      (@EVENTID, @ANALYSISUNITID, @NOTES)

---return id 
Select SCOPE_IDENTITY()



GO

-- ----------------------------
-- Procedure structure for InsertUnitsDatasetTypes
-- ----------------------------


CREATE PROCEDURE [InsertUnitsDatasetTypes](@DATASETTYPEID int, @VARIABLEUNITSID int)

AS 
INSERT INTO NDB.UnitsDatasetTypes(DatasetTypeID, VariableUnitsID)
VALUES      (@DATASETTYPEID, @VARIABLEUNITSID)

GO

-- ----------------------------
-- Procedure structure for InsertVariable
-- ----------------------------




CREATE PROCEDURE [InsertVariable](@TAXONID int,
@VARIABLEELEMENTID int = null,
@VARIABLEUNITSID int = null,
@VARIABLECONTEXTID int = null)

AS INSERT INTO NDB.Variables (TaxonID, VariableElementID, VariableUnitsID, VariableContextID )
VALUES      (@TAXONID, @VARIABLEELEMENTID, @VARIABLEUNITSID, @VARIABLECONTEXTID)

---return id 
Select SCOPE_IDENTITY()







GO

-- ----------------------------
-- Procedure structure for InsertVariableContext
-- ----------------------------


CREATE PROCEDURE [InsertVariableContext](@CONTEXT nvarchar(64))

AS 
INSERT INTO NDB.VariableContexts(VariableContext)
VALUES      (@CONTEXT)

---return id 
Select SCOPE_IDENTITY()




GO

-- ----------------------------
-- Procedure structure for InsertVariableElement
-- ----------------------------


CREATE PROCEDURE [InsertVariableElement](@VARIABLEELEMENT nvarchar(64), 
@ELEMENTTYPEID int,
@SYMMETRYID int = null,
@PORTIONID int = null,
@MATURITYID int = null)

AS 
INSERT INTO NDB.VariableElements(VariableElement, ElementTypeID, SymmetryID, PortionID, MaturityID)
VALUES      (@VARIABLEELEMENT, @ELEMENTTYPEID, @SYMMETRYID, @PORTIONID, @MATURITYID)

---return id 
Select SCOPE_IDENTITY()





GO

-- ----------------------------
-- Procedure structure for InsertVariableUnits
-- ----------------------------





CREATE PROCEDURE [InsertVariableUnits](@UNITS nvarchar(64))

AS 
INSERT INTO NDB.VariableUnits(VariableUnits)
VALUES      (@UNITS)

---return id 
Select SCOPE_IDENTITY()









GO

-- ----------------------------
-- Procedure structure for UpdateAggregateChronAgeBounds
-- ----------------------------




CREATE PROCEDURE [UpdateAggregateChronAgeBounds](@AGGREGATECHRONID int, @AGEBOUNDYOUNGER int, @AGEBOUNDOLDER int)
AS 
UPDATE NDB.AggregateChronologies
SET   AgeBoundYounger = @AGEBOUNDYOUNGER, AgeBoundOlder = @AGEBOUNDOLDER
WHERE AggregateChronID = @AGGREGATECHRONID





GO

-- ----------------------------
-- Procedure structure for UpdateAnalysisUnitDepth
-- ----------------------------





CREATE PROCEDURE [UpdateAnalysisUnitDepth](@ANALYSISUNITID int, @DEPTH float)
AS 
UPDATE     NDB.AnalysisUnits
SET        NDB.AnalysisUnits.Depth = @DEPTH 
WHERE      (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)





GO

-- ----------------------------
-- Procedure structure for UpdateAnalysisUnitName
-- ----------------------------




CREATE PROCEDURE [UpdateAnalysisUnitName](@ANALYSISUNITID int, @ANALYSISUNITNAME nvarchar(80))
AS 
UPDATE     NDB.AnalysisUnits
SET        NDB.AnalysisUnits.AnalysisUnitName = @ANALYSISUNITNAME 
WHERE     (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)




GO

-- ----------------------------
-- Procedure structure for UpdateAnalysisUnitThickness
-- ----------------------------





CREATE PROCEDURE [UpdateAnalysisUnitThickness](@ANALYSISUNITID int, @THICKNESS float)
AS 
UPDATE     NDB.AnalysisUnits
SET        NDB.AnalysisUnits.Thickness = @THICKNESS
WHERE      (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)





GO

-- ----------------------------
-- Procedure structure for UpdateCapitalizeTaxonName
-- ----------------------------





CREATE PROCEDURE [UpdateCapitalizeTaxonName](@HIGHERTAXONID int)
AS 
UPDATE     NDB.Taxa
SET        NDB.Taxa.TaxonName = UPPER(LEFT(NDB.Taxa.TaxonName,1))+LOWER(SUBSTRING(NDB.Taxa.TaxonName,2,LEN(NDB.Taxa.TaxonName)))
WHERE     (HigherTaxonID = @HIGHERTAXONID)







GO

-- ----------------------------
-- Procedure structure for UpdateChronControlAnalysisUnit
-- ----------------------------




CREATE PROCEDURE [UpdateChronControlAnalysisUnit](@CHRONCONTROLID int, @ANALUNITID int)
AS 
UPDATE NDB.ChronControls
SET AnalysisUnitID = @ANALUNITID
WHERE ChronControlID = @CHRONCONTROLID






GO

-- ----------------------------
-- Procedure structure for UpdateChronControlType
-- ----------------------------



CREATE PROCEDURE [UpdateChronControlType](@CHRONCONTROLTYPEID int, @CHRONCONTROLTYPE nvarchar(64))
AS 
UPDATE NDB.ChronControlTypes
Set ChronControlType = @CHRONCONTROLTYPE
WHERE ChronControlTypeID = @CHRONCONTROLTYPEID





GO

-- ----------------------------
-- Procedure structure for UpdateChronology
-- ----------------------------



CREATE PROCEDURE [UpdateChronology](@CHRONOLOGYID int,
@AGETYPE nvarchar(64),
@CONTACTID int = null,
@ISDEFAULT bit,
@CHRONOLOGYNAME nvarchar(80) = null,
@DATEPREPARED date = null,
@AGEMODEL nvarchar(80) = null,
@AGEBOUNDYOUNGER int = null,
@AGEBOUNDOLDER int = null,
@NOTES nvarchar(MAX) = null)


AS 

DECLARE @AGETYPEID int
SET @AGETYPEID = (SELECT AgeTypeID FROM NDB.AgeTypes WHERE (AgeType = @AGETYPE))

UPDATE NDB.Chronologies

Set AgeTypeID = @AGETYPEID, ContactID = @CONTACTID, IsDefault = @ISDEFAULT, ChronologyName = @CHRONOLOGYNAME, DatePrepared = convert(datetime, @DATEPREPARED, 105),
    AgeModel = @AGEMODEL, AgeBoundYounger = @AGEBOUNDYOUNGER, AgeBoundOlder = @AGEBOUNDOLDER, Notes = @NOTES  
WHERE ChronologyID = @CHRONOLOGYID






GO

-- ----------------------------
-- Procedure structure for UpdateCollectionUnit
-- ----------------------------


CREATE PROCEDURE [UpdateCollectionUnit](@COLLUNITID int,
@STEWARDCONTACTID int,
@HANDLE nvarchar(10),
@COLLTYPEID int = null,
@DEPENVTID int = null,
@COLLUNITNAME nvarchar(255) = null,
@COLLDATE date = null,
@COLLDEVICE nvarchar(255) = null,
@GPSLATITUDE float = null,
@GPSLONGITUDE float = null,
@GPSALTITUDE float = null,
@GPSERROR float = null,
@WATERDEPTH float = null,
@SUBSTRATEID int = null,
@SLOPEASPECT int = null,
@SLOPEANGLE int = null,
@LOCATION nvarchar(255) = null,
@NOTES nvarchar(MAX) = null)

AS 
DECLARE @OldHandle nvarchar(10) = (SELECT Handle FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldCollTypeID int = (SELECT CollTypeID FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldDepEnvtID int = (SELECT DepEnvtID FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldCollUnitName nvarchar(255) = (SELECT CollUnitName FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldCollDate date = (SELECT CollDate FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldCollDevice nvarchar(255) = (SELECT CollDevice FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldGPSLatitude float = (SELECT GPSLatitude FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldGPSLongitude float = (SELECT GPSLongitude FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldGPSAltitude float = (SELECT GPSAltitude FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldGPSError float = (SELECT GPSError FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldWaterDepth float = (SELECT WaterDepth FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldSubstrateID int = (SELECT SubstrateID FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldSlopeAspect int = (SELECT SlopeAspect FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldSlopeAngle int = (SELECT SlopeAngle FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldLocation nvarchar(255) = (SELECT Location FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)
DECLARE @OldNotes nvarchar(MAX) = (SELECT Notes FROM NDB.CollectionUnits WHERE CollectionUnitID = @COLLUNITID)

IF @OldHandle <> @HANDLE
  BEGIN
    UPDATE NDB.CollectionUnits
    SET Handle = @HANDLE WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'Handle')
  END

IF (@COLLTYPEID <> @OldCollTypeID)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET CollTypeID = @COLLTYPEID WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollTypeID')
  END

IF @DEPENVTID IS NULL
  BEGIN
    IF @OldDepEnvtID IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET DepEnvtID = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'DepEnvtID')
      END
  END
ELSE IF (@OldDepEnvtID IS NULL) OR (@DEPENVTID <> @OldDepEnvtID)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET DepEnvtID = @DEPENVTID WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'DepEnvtID')
  END

IF @COLLUNITNAME IS NULL
  BEGIN
    IF @OldCollUnitName IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET CollUnitName = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollUnitName')
      END
  END
ELSE IF (@OldCollUnitName IS NULL) OR (@COLLUNITNAME <> @OldCollUnitName)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET CollUnitName = @COLLUNITNAME WHERE CollectionUnitID = @COLLUNITID 
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollUnitName')
  END

/* convert(datetime, @COLLDATE, 105) */
IF @COLLDATE IS NULL
  BEGIN
    IF @OldCollDate IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET CollDate = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollDate')
      END
  END
ELSE IF (@OldCollDate IS NULL) OR (@COLLDATE <> @OldCollDate)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET CollDate = convert(datetime, @COLLDATE, 105) WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollDate')
  END

IF @COLLDEVICE IS NULL
  BEGIN
    IF @OldCollDevice IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET CollDevice = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollDevice')
      END
  END
ELSE IF (@OldCollDevice IS NULL) OR (@COLLDEVICE <> @OldCollDevice)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET CollDevice = @COLLDEVICE WHERE CollectionUnitID = @COLLUNITID 
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'CollDevice')
  END

IF @GPSLATITUDE IS NULL
  BEGIN
    IF @OldGPSLatitude IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET GPSLatitude = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSLatitude')
      END
  END
ELSE IF (@OldGPSLatitude IS NULL) OR (@GPSLATITUDE <> @OldGPSLatitude)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET GPSLatitude = @GPSLATITUDE WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSLatitude')
  END

IF @GPSLONGITUDE IS NULL
  BEGIN
    IF @OldGPSLongitude IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET GPSLongitude = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSLongitude')
      END
  END
ELSE IF (@OldGPSLongitude IS NULL) OR (@GPSLONGITUDE <> @OldGPSLongitude)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET GPSLongitude = @GPSLONGITUDE WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSLongitude')
  END

IF @GPSALTITUDE IS NULL
  BEGIN
    IF @OldGPSAltitude IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET GPSAltitude = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSAltitude')
      END
  END
ELSE IF (@OldGPSAltitude IS NULL) OR (@GPSALTITUDE <> @OldGPSAltitude)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET GPSAltitude = @GPSALTITUDE WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSAltitude')
  END

IF @GPSERROR IS NULL
  BEGIN
    IF @OldGPSError IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET GPSError = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSError')
      END
  END
ELSE IF (@OldGPSError IS NULL) OR (@GPSERROR <> @OldGPSError)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET GPSError = @GPSERROR WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'GPSError')
  END

IF @WATERDEPTH IS NULL
  BEGIN
    IF @OldWaterDepth IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET WaterDepth = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'WaterDepth')
      END
  END
ELSE IF (@OldWaterDepth IS NULL) OR (@WATERDEPTH <> @OldWaterDepth)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET WaterDepth = @WATERDEPTH WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'WaterDepth')
  END

IF @SUBSTRATEID IS NULL
  BEGIN
    IF @OldSubstrateID IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET SubstrateID = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SubstrateID')
      END
  END
ELSE IF (@OldSubstrateID IS NULL) OR (@SUBSTRATEID <> @OldSubstrateID)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET SubstrateID = @SUBSTRATEID WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SubstrateID')
  END

IF @SLOPEASPECT IS NULL
  BEGIN
    IF @OldSlopeAspect IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET SlopeAspect = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SlopeAspect')
      END
  END
ELSE IF (@OldSlopeAspect IS NULL) OR (@SLOPEASPECT <> @OldSlopeAspect)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET SlopeAspect = @SLOPEASPECT WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SlopeAspect')
  END

IF @SLOPEANGLE IS NULL
  BEGIN
    IF @OldSlopeAngle IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET SlopeAngle = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SlopeAngle')
      END
  END
ELSE IF (@OldSlopeAngle IS NULL) OR (@SLOPEANGLE <> @OldSlopeAngle)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET SlopeAngle = @SLOPEANGLE WHERE CollectionUnitID = @COLLUNITID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'SlopeAngle')
  END

IF @LOCATION IS NULL
  BEGIN
    IF @OldLocation IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET Location = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'Location')
      END
  END
ELSE IF (@OldLocation IS NULL) OR (@LOCATION <> @OldLocation)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET Location = @LOCATION WHERE CollectionUnitID = @COLLUNITID 
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'Location')
  END

IF @NOTES IS NULL
  BEGIN
    IF @OldNotes IS NOT NULL
      BEGIN
        UPDATE NDB.CollectionUnits
        SET Notes = NULL WHERE CollectionUnitID = @COLLUNITID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'Notes')
      END
  END
ELSE IF (@OldNotes IS NULL) OR (@NOTES <> @OldNotes)
  BEGIN
    UPDATE NDB.CollectionUnits
    SET Notes = @NOTES WHERE CollectionUnitID = @COLLUNITID 
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'CollectionUnits', @COLLUNITID, N'Update', N'Notes')
  END
GO

-- ----------------------------
-- Procedure structure for UpdateContact
-- ----------------------------


CREATE PROCEDURE [UpdateContact](@CONTACTID int,
@ALIASID int = null,
@CONTACTNAME nvarchar(80),
@STATUSID int = null,
@FAMILYNAME nvarchar(80) = null,
@INITIALS nvarchar(16) = null,
@GIVENNAMES nvarchar(80) = null,
@SUFFIX nvarchar(16) = null,
@TITLE nvarchar(16) = null,
@PHONE nvarchar(64) = null,
@FAX nvarchar(64) = null,
@EMAIL nvarchar(64) = null,
@URL nvarchar(255) = null,
@ADDRESS nvarchar(MAX) = null,
@NOTES nvarchar(MAX)= null)

AS UPDATE NDB.Contacts

Set AliasID = @ALIASID, ContactName = @CONTACTNAME, ContactStatusID = @STATUSID, FamilyName = @FAMILYNAME, LeadingInitials = @INITIALS,
    GivenNames = @GIVENNAMES, Suffix = @SUFFIX, Title = @TITLE, Phone = @PHONE, Fax = @FAX, Email = @EMAIL, URL = @URL, Address = @ADDRESS, 
    Notes = @NOTES  
WHERE ContactID = @CONTACTID





GO

-- ----------------------------
-- Procedure structure for UpdateContactAliasID
-- ----------------------------



CREATE PROCEDURE [UpdateContactAliasID](@CONTACTID int, @ALIASID int)

AS UPDATE NDB.Contacts

Set AliasID = @ALIASID  
WHERE ContactID = @CONTACTID






GO

-- ----------------------------
-- Procedure structure for UpdateData
-- ----------------------------



CREATE PROCEDURE [UpdateData](@DATAID int, @VALUE float)
AS 
UPDATE     NDB.Data
SET        NDB.Data.Value = @VALUE 
WHERE     (NDB.Data.DataID = @DATAID)



GO

-- ----------------------------
-- Procedure structure for UpdateDatasetName
-- ----------------------------




CREATE PROCEDURE [UpdateDatasetName](@DATASETID int, @DATASETNAME nvarchar(80))
AS 
UPDATE     NDB.Datasets
SET        NDB.Datasets.DatasetName = @DATASETNAME
WHERE     (NDB.Datasets.DatasetID = @DATASETID)






GO

-- ----------------------------
-- Procedure structure for UpdateDatasetNotes
-- ----------------------------





CREATE PROCEDURE [UpdateDatasetNotes](@DATASETID int, @DATASETNOTES nvarchar(MAX) = null)
AS 
IF @DATASETNOTES IS NOT NULL
  BEGIN
    UPDATE     NDB.Datasets
    SET        NDB.Datasets.Notes = @DATASETNOTES
    WHERE     (NDB.Datasets.DatasetID = @DATASETID)
  END
ELSE
  BEGIN
    UPDATE     NDB.Datasets
    SET        NDB.Datasets.Notes = null
    WHERE     (NDB.Datasets.DatasetID = @DATASETID)
  END

GO

-- ----------------------------
-- Procedure structure for UpdateDatasetPubPrimary
-- ----------------------------





CREATE PROCEDURE [UpdateDatasetPubPrimary](@DATASETID int, @PUBLICATIONID int, @PRIMARY bit)
AS 
UPDATE     NDB.DatasetPublications
SET        NDB.DatasetPublications.PrimaryPub = @PRIMARY
WHERE      (NDB.DatasetPublications.DatasetID = @DATASETID) AND (NDB.DatasetPublications.PublicationID = @PUBLICATIONID)







GO

-- ----------------------------
-- Procedure structure for UpdateDatasetRepositoryNotes
-- ----------------------------





CREATE PROCEDURE [UpdateDatasetRepositoryNotes](@DATASETID int, @REPOSITORYID int, @NOTES nvarchar(MAX) = null)

AS 
IF @NOTES IS NULL
  BEGIN
    UPDATE NDB.RepositorySpecimens
    SET    Notes = NULL 
    WHERE  (DatasetID = @DATASETID) AND (RepositoryID = @REPOSITORYID)
  END
ELSE
  BEGIN
    UPDATE NDB.RepositorySpecimens
    SET    Notes = @NOTES 
    WHERE  (DatasetID = @DATASETID) AND (RepositoryID = @REPOSITORYID)
  END


--INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation, ColumnName)
--VALUES      (@CONTACTID, N'RepositorySpecimens', @DATASETID, @REPOSITORYID, N'Update', N'Notes')





GO

-- ----------------------------
-- Procedure structure for UpdateDatasetTaxonNotes
-- ----------------------------




CREATE PROCEDURE [UpdateDatasetTaxonNotes](@DATASETID int, @TAXONID int, @CONTACTID int, @DATE date, @NOTES nvarchar(MAX))

AS 
UPDATE NDB.DatasetTaxonNotes
Set DatasetID = @DATASETID, 
    TaxonID = @TAXONID, 
	ContactID = @CONTACTID, 
	Date = convert(datetime, @DATE, 105),
	Notes = @NOTES
WHERE DatasetID = @DATASETID AND TaxonID = @TAXONID

INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation, ColumnName)
VALUES      (@CONTACTID, N'DatasetTaxonNotes', @DATASETID, @TAXONID, N'Update', N'Notes')






GO

-- ----------------------------
-- Procedure structure for UpdateDatasetVariable
-- ----------------------------



CREATE PROCEDURE [UpdateDatasetVariable](@OLDVARIABLEID int, @NEWVARIABLEID int, @SAMPLEID1 int, @SAMPLEID2 int)
AS 
UPDATE     NDB.Data
SET        NDB.Data.VariableID = @NEWVARIABLEID
WHERE     (NDB.Data.VariableID = @OLDVARIABLEID AND NDB.Data.SampleID >= @SAMPLEID1 AND NDB.Data.SampleID <= @SAMPLEID2)





GO

-- ----------------------------
-- Procedure structure for UpdateDataVariable
-- ----------------------------



CREATE PROCEDURE [UpdateDataVariable](@DATASETID int, @OLDVARIABLEID int, @NEWVARIABLEID int, @CONTACTID int)
AS 
DECLARE @DATAIDS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  DataID int
)

INSERT INTO @DATAIDS (DataID)
SELECT    NDB.Data.DataID
FROM      NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID
WHERE     (NDB.Samples.DatasetID = @DATASETID) AND (NDB.Data.VariableID = @OLDVARIABLEID)

DECLARE @NRows int = @@ROWCOUNT
DECLARE @CurrentID int = 0
DECLARE @DATAID int

WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	SET @DATAID = (SELECT DataID FROM @DATAIDS WHERE ID = @CurrentID)
	UPDATE NDB.Data
	SET    NDB.Data.VariableID = @NEWVARIABLEID
	WHERE  (NDB.Data.DataID = @DATAID)  
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@CONTACTID, N'Data', @DATAID, N'Update', N'VariableID')   
  END

GO

-- ----------------------------
-- Procedure structure for UpdateDataVariableID
-- ----------------------------


CREATE PROCEDURE [UpdateDataVariableID](@OLDVARIABLEID int, @NEWVARIABLEID int)
AS 
UPDATE NDB.Data
SET    VariableID = @NEWVARIABLEID
WHERE  (VariableID = @OLDVARIABLEID)



GO

-- ----------------------------
-- Procedure structure for UpdateDataVariableID_DeleteVariable
-- ----------------------------



CREATE PROCEDURE [UpdateDataVariableID_DeleteVariable](@SAVEVARID int, @DELVARID int)
/* Merges @DELVARID with @SAVEVARID and deletes @DELVARID */
AS 
UPDATE NDB.Data
SET    VariableID = @SAVEVARID
WHERE  (VariableID = @DELVARID)

DELETE FROM NDB.Variables
WHERE VariableID = @DELVARID



GO

-- ----------------------------
-- Procedure structure for UpdateDepEnvtHigherID
-- ----------------------------



CREATE PROCEDURE [UpdateDepEnvtHigherID](@DEPENVTID int, @DEPENVTHIGHERID int)
AS UPDATE NDB.DepEnvtTypes
Set DepEnvtHigherID = @DEPENVTHIGHERID
WHERE DEPENVTID = @DEPENVTID







GO

-- ----------------------------
-- Procedure structure for UpdateDepEnvtType
-- ----------------------------


CREATE PROCEDURE [UpdateDepEnvtType](@DEPENVTID int, @DEPENVT nvarchar(255),
@DEPENVTHIGHERID int)
AS UPDATE NDB.DepEnvtTypes
Set DepEnvt = @DEPENVT, DepEnvtHigherID = @DEPENVTHIGHERID
WHERE DEPENVTID = @DEPENVTID






GO

-- ----------------------------
-- Procedure structure for UpdateElementPollenToSpore
-- ----------------------------




CREATE PROCEDURE [UpdateElementPollenToSpore](@TAXONID int)
AS 
DECLARE @NPOLLENVARS int
SET @NPOLLENVARS = (SELECT COUNT(*) FROM NDB.Variables WHERE (TaxonID = @TAXONID) AND (VariableElementID = 141))
IF (@NPOLLENVARS > 1)
  BEGIN
    SELECT N'Pollen variables >1. Cannot process.'
	RETURN
  END

DECLARE @SPOREVARIABLEID int
DECLARE @POLLENVARIABLEID int
DECLARE @UNITSID int
DECLARE @CONTEXTID int
SET @POLLENVARIABLEID = (SELECT VariableID FROM NDB.Variables WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 141)))
SET @UNITSID = (SELECT VariableUnitsID FROM NDB.Variables WHERE (VariableID = @POLLENVARIABLEID))
SET @CONTEXTID = (SELECT VariableContextID FROM NDB.Variables WHERE (VariableID = @POLLENVARIABLEID))
IF (@CONTEXTID IS NULL)
  BEGIN
    SET @SPOREVARIABLEID = (SELECT VariableID FROM NDB.Variables 
    WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 166) AND (VariableUnitsID = @UNITSID) AND (VariableContextID IS NULL)))
  END
ELSE
  BEGIN
    SET @SPOREVARIABLEID = (SELECT VariableID FROM NDB.Variables 
    WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 166) AND (VariableUnitsID = @UNITSID) AND (VariableContextID = @CONTEXTID)))
  END

IF (@SPOREVARIABLEID IS NULL)
  BEGIN
    SELECT N'No equivalent spore variable.'
	RETURN
  END

UPDATE NDB.Data
SET    NDB.Data.VariableID = @SPOREVARIABLEID   -- correct VariableID 
WHERE  (NDB.Data.VariableID = @POLLENVARIABLEID)  -- incorrect VariableID

SELECT CONCAT (N'Data table updated: Pollen variable ', CAST (@POLLENVARIABLEID AS nvarchar), N' updated to spore variable ', CAST (@SPOREVARIABLEID AS nvarchar), N'.') AS Result

DELETE FROM NDB.Variables
WHERE VariableID = @POLLENVARIABLEID

SELECT CONCAT (N'Variable ', CAST (@POLLENVARIABLEID AS nvarchar), N' deleted.') AS Result






GO

-- ----------------------------
-- Procedure structure for UpdateElementSporeToPollen
-- ----------------------------



CREATE PROCEDURE [UpdateElementSporeToPollen](@TAXONID int)
AS 
DECLARE @NSPOREVARS int
SET @NSPOREVARS = (SELECT COUNT(*) FROM NDB.Variables WHERE (TaxonID = @TAXONID) AND (VariableElementID = 166))
IF (@NSPOREVARS > 1)
  BEGIN
    SELECT N'Spore variables >1. Cannot process.'
	RETURN
  END

DECLARE @SPOREVARIABLEID int
DECLARE @POLLENVARIABLEID int
DECLARE @UNITSID int
DECLARE @CONTEXTID int
SET @SPOREVARIABLEID = (SELECT VariableID FROM NDB.Variables WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 166)))
SET @UNITSID = (SELECT VariableUnitsID FROM NDB.Variables WHERE (VariableID = @SPOREVARIABLEID))
SET @CONTEXTID = (SELECT VariableContextID FROM NDB.Variables WHERE (VariableID = @SPOREVARIABLEID))
IF (@CONTEXTID IS NULL)
  BEGIN
    SET @POLLENVARIABLEID = (SELECT VariableID FROM NDB.Variables 
    WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 141) AND (VariableUnitsID = @UNITSID) AND (VariableContextID IS NULL)))
  END
ELSE
  BEGIN
    SET @POLLENVARIABLEID = (SELECT VariableID FROM NDB.Variables 
    WHERE ((TaxonID = @TAXONID) AND (VariableElementID = 141) AND (VariableUnitsID = @UNITSID) AND (VariableContextID = @CONTEXTID)))
  END

IF (@POLLENVARIABLEID IS NULL)
  BEGIN
    SELECT N'No equivalent pollen variable.'
	RETURN
  END

UPDATE NDB.Data
SET    NDB.Data.VariableID = @POLLENVARIABLEID   -- correct VariableID 
WHERE  (NDB.Data.VariableID = @SPOREVARIABLEID)  -- incorrect VariableID

SELECT CONCAT (N'Data table updated: Spore variable ', CAST (@SPOREVARIABLEID AS nvarchar), N' updated to pollen variable ', CAST (@POLLENVARIABLEID AS nvarchar), N'.') AS Result

DELETE FROM NDB.Variables
WHERE VariableID = @SPOREVARIABLEID

SELECT CONCAT (N'Variable ', CAST (@SPOREVARIABLEID AS nvarchar), N' deleted.') AS Result





GO

-- ----------------------------
-- Procedure structure for UpdateEvent
-- ----------------------------



CREATE PROCEDURE [UpdateEvent](@EVENTID int,
@EVENTTYPEID int,
@EVENTNAME nvarchar(80),
@C14AGE float = null,
@C14AGEYOUNGER float = null,
@C14AGEOLDER float = null,
@CALAGE float = null,
@CALAGEYOUNGER float = null,
@CALAGEOLDER float = null,
@NOTES nvarchar(MAX) = null)

AS UPDATE NDB.Events

Set EventTypeID = @EVENTTYPEID, EventName = @EVENTNAME, C14Age = @C14AGE, C14AgeYounger = @C14AGEYOUNGER, C14AgeOlder = @C14AGEOLDER,
    CalAge = @CALAGE, CalAgeYounger = @CALAGEYOUNGER, CalAgeOlder = @CALAGEOLDER, Notes = @NOTES                
WHERE EventID = @EVENTID







GO

-- ----------------------------
-- Procedure structure for UpdateGeochron
-- ----------------------------

CREATE PROCEDURE [UpdateGeochron](@GEOCHRONID int,
@GEOCHRONTYPEID int,
@AGETYPEID int,
@AGE float = null,
@ERROROLDER float = null,
@ERRORYOUNGER float = null,
@INFINITE bit = 0,
@LABNUMBER nvarchar(40) = null,
@MATERIALDATED nvarchar(255) = null,
@NOTES nvarchar(MAX) = null)

AS 
UPDATE NDB.Geochronology
SET GeochronTypeID = @GEOCHRONTYPEID, AgeTypeID = @AGETYPEID, Age = @AGE, ErrorOlder = @ERROROLDER, ErrorYounger = @ERRORYOUNGER,
    Infinite = @INFINITE, LabNumber = @LABNUMBER, MaterialDated = @MATERIALDATED, Notes = @NOTES
WHERE GeochronID = @GEOCHRONID 




GO

-- ----------------------------
-- Procedure structure for UpdateGeochronAnalysisUnit
-- ----------------------------


CREATE PROCEDURE [UpdateGeochronAnalysisUnit](@GEOCHRONID int, @ANALYSISUNITID int, @DEPTH float = null, @THICKNESS float = null, @ANALYSISUNITNAME nvarchar(80) = null)
AS 
/*
This procedure updates the depth, thickness, and name of the analysis unit for a geochronologic measurement. 
If no other samples are assigned to the analysis unit, then the analysis unit is simply updated. However, if
other samples are assigned to the analysis unit then either (1) the geochron sample is reassigned to another
analysis unit with the same depth, thickness, and name from the same Collection Unit, or (2) the sample is 
reassigned to a new analysis unit. The return value is the AnalysisUnitID to which the sample is assigned 
after the update. 
*/

DECLARE @GEOCHRONSAMPLEID int
DECLARE @SAMPLEID int
DECLARE @NSAMPLES int
DECLARE @COLLUNITID int
DECLARE @NANALUNITS int
DECLARE @NEWANALYSISUNITID int = NULL

SET @GEOCHRONSAMPLEID = (SELECT SampleID FROM NDB.Geochronology WHERE (GeochronID = @GEOCHRONID))
SET @NSAMPLES = (SELECT COUNT(*) FROM NDB.Samples GROUP BY AnalysisUnitID HAVING (AnalysisUnitID = @ANALYSISUNITID))
-- if analysis unit has no other sample, simply update

IF (@NSAMPLES = 1)
  BEGIN
    SET @SAMPLEID = (SELECT SampleID FROM NDB.Samples WHERE (AnalysisUnitID = @ANALYSISUNITID))  
	IF (@GEOCHRONSAMPLEID = @SAMPLEID)  -- this should always be the case, but...
	  BEGIN
	    UPDATE NDB.AnalysisUnits SET NDB.AnalysisUnits.Depth = @DEPTH WHERE (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)
		UPDATE NDB.AnalysisUnits SET NDB.AnalysisUnits.Thickness = @THICKNESS WHERE (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)
		UPDATE NDB.AnalysisUnits SET NDB.AnalysisUnits.AnalysisUnitName = @ANALYSISUNITNAME WHERE (NDB.AnalysisUnits.AnalysisUnitID = @ANALYSISUNITID)     
	  END
    ELSE
	  BEGIN
	    RAISERROR('Geochron SampleID does not match SampleID for Geochron Analysis Unit',10,1)
	  END
  END 
ELSE
  BEGIN
    -- see if another analysis unit exists with the same parameters from same collection unit
	SET @COLLUNITID = (SELECT CollectionUnitID FROM NDB.AnalysisUnits WHERE (AnalysisUnitID = @ANALYSISUNITID))
	-- see if analysis unit exists with same non-null name
	IF (@ANALYSISUNITNAME IS NOT NULL)
	  BEGIN
	    IF ((@DEPTH IS NOT NULL) AND (@THICKNESS IS NOT NULL))
		  BEGIN
	        SET @NANALUNITS = (SELECT COUNT(*) FROM NDB.AnalysisUnits
                               GROUP BY CollectionUnitID, AnalysisUnitID, AnalysisUnitName, Depth, Thickness
                               HAVING (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                  (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS))
            IF (@NANALUNITS = 1)
			  SET @NEWANALYSISUNITID = (SELECT AnalysisUnitID FROM NDB.AnalysisUnits
                                        WHERE (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                    (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS))
          END
        ELSE IF ((@DEPTH IS NOT NULL) AND (@THICKNESS IS NULL))
	      BEGIN
		    SET @NANALUNITS = (SELECT COUNT(*) FROM NDB.AnalysisUnits
                               GROUP BY CollectionUnitID, AnalysisUnitID, AnalysisUnitName, Depth, Thickness
                               HAVING (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                  (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth = @DEPTH) AND (Thickness IS NULL))
            IF (@NANALUNITS = 1)
			  SET @NEWANALYSISUNITID = (SELECT AnalysisUnitID FROM NDB.AnalysisUnits
                                        WHERE (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                    (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth = @DEPTH) AND (Thickness IS NULL))
          END
		ELSE IF ((@DEPTH IS NULL) AND (@THICKNESS IS NOT NULL))
	      BEGIN
		    SET @NANALUNITS = (SELECT COUNT(*) FROM NDB.AnalysisUnits
                               GROUP BY CollectionUnitID, AnalysisUnitID, AnalysisUnitName, Depth, Thickness
                               HAVING (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                  (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth IS NULL) AND (Thickness = @THICKNESS))
            IF (@NANALUNITS = 1)
			  SET @NEWANALYSISUNITID = (SELECT AnalysisUnitID FROM NDB.AnalysisUnits
                                        WHERE (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                    (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth IS NULL) AND (Thickness = @THICKNESS))
	      END
		ELSE IF ((@DEPTH IS NULL) AND (@THICKNESS IS NULL))
		  BEGIN
	        SET @NANALUNITS = (SELECT COUNT(*) FROM NDB.AnalysisUnits
                               GROUP BY CollectionUnitID, AnalysisUnitID, AnalysisUnitName, Depth, Thickness
                               HAVING (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                  (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth IS NULL) AND (Thickness IS NULL))
            IF (@NANALUNITS = 1)
			  SET @NEWANALYSISUNITID = (SELECT AnalysisUnitID FROM NDB.AnalysisUnits
                                        WHERE (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                    (AnalysisUnitName = @ANALYSISUNITNAME) AND (Depth IS NULL) AND (Thickness IS NULL))
		  END
	  END
    ELSE IF (@ANALYSISUNITNAME IS NULL)
	  -- note: analysis units can be the same only if thicknesses are not null
	  BEGIN
	    IF ((@DEPTH IS NOT NULL) AND (@THICKNESS IS NOT NULL))
		  BEGIN
		    SET @NANALUNITS = (SELECT COUNT(*) FROM NDB.AnalysisUnits
                               GROUP BY CollectionUnitID, AnalysisUnitID, AnalysisUnitName, Depth, Thickness
                               HAVING (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                  (AnalysisUnitName IS NULL) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS))
            IF (@NANALUNITS = 1)
			  SET @NEWANALYSISUNITID = (SELECT AnalysisUnitID FROM NDB.AnalysisUnits
                                        WHERE (CollectionUnitID = @COLLUNITID) AND (AnalysisUnitID <> @ANALYSISUNITID) AND 
					                    (AnalysisUnitName IS NULL) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS))
	      END
	  END
    IF (@NEWANALYSISUNITID IS NOT NULL)  -- assign geochron sample to new existing analysis unit
	  BEGIN
	    UPDATE NDB.Samples SET NDB.Samples.AnalysisUnitID = @NEWANALYSISUNITID WHERE (NDB.Samples.SampleID = @GEOCHRONSAMPLEID)  
		SET @ANALYSISUNITID = @NEWANALYSISUNITID
	  END
    ELSE  -- create new analysis unit and add geochron sample to it
	  BEGIN
	    INSERT INTO NDB.AnalysisUnits(CollectionUnitID, AnalysisUnitName, Depth, Thickness, Mixed)
        VALUES (@COLLUNITID, @ANALYSISUNITNAME, @DEPTH, @THICKNESS, 0)
		SET @ANALYSISUNITID = SCOPE_IDENTITY()
        UPDATE NDB.Samples SET NDB.Samples.AnalysisUnitID = @ANALYSISUNITID WHERE (NDB.Samples.SampleID = @GEOCHRONSAMPLEID) 
	  END
  END
 
SELECT @ANALYSISUNITID






GO

-- ----------------------------
-- Procedure structure for UpdateIsSurfaceSample
-- ----------------------------



CREATE PROCEDURE [UpdateIsSurfaceSample](@DATASETID int, @ISSAMP bit)
AS 
DECLARE @NULLDEPTHS int
DECLARE @MINDEPTH float
DECLARE @SAMPLEID int
DECLARE @MODERN int

IF @ISSAMP = 1
  BEGIN
    -- ensure that all analysis units have depths, otherwise top sample not determinable
    SET @NULLDEPTHS = (SELECT COUNT(*) FROM NDB.Samples INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
                      WHERE (NDB.AnalysisUnits.Depth IS NULL) AND (NDB.Samples.DatasetID = @DATASETID))
    IF @NULLDEPTHS = 0
	  BEGIN
	    SET @MINDEPTH = (SELECT MIN(NDB.AnalysisUnits.Depth) FROM NDB.Samples INNER JOIN
                        NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
                        WHERE (NDB.Samples.DatasetID = @DATASETID))
        SET @SAMPLEID = (SELECT NDB.Samples.SampleID FROM NDB.Samples INNER JOIN
                        NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
                        WHERE (NDB.AnalysisUnits.Depth = @MINDEPTH) AND (NDB.Samples.DatasetID = @DATASETID))
		SET @MODERN = (SELECT COUNT(*) FROM NDB.SampleKeywords WHERE (NDB.SampleKeywords.SampleID = @SAMPLEID) AND (NDB.SampleKeywords.KeywordID = 1))
		-- ensure modern keyword not already assigned
		IF @MODERN = 0
		  BEGIN
		    INSERT INTO NDB.SampleKeywords(SampleID, KeywordID)
            VALUES      (@SAMPLEID, 1)
		  END
	  END
  END
ELSE IF @ISSAMP = 0
  BEGIN
    DELETE k
    FROM   NDB.SampleKeywords k
      INNER JOIN NDB.Samples s ON s.SampleID = k.SampleID
    WHERE (s.DatasetID = @DATASETID) AND (k.KeywordID = 1)
  END




GO

-- ----------------------------
-- Procedure structure for UpdateLakeParam
-- ----------------------------

/*
1. In Neotoma, need to change
2. Not in Neotoma, need to add
3. In Neotoma, need to delete
*/

CREATE PROCEDURE [UpdateLakeParam](@SITEID int, @STEWARDCONTACTID int, @LAKEPARAMETER nvarchar(80), @VALUE float = null)
AS 
DECLARE @LAKEPARAMETERID int = (SELECT LakeParameterID FROM NDB.LakeParameterTypes WHERE (LakeParameter = @LAKEPARAMETER))
DECLARE @NPARAM int = (SELECT COUNT(*) AS Count FROM NDB.LakeParameters WHERE (SiteID = @SITEID) GROUP BY LakeParameterID HAVING (LakeParameterID = @LAKEPARAMETERID))
/* If @NPARAM is not null, then the LakeParameter is already in Neotoma */

IF @LAKEPARAMETERID IS NOT NULL
  BEGIN
    IF @VALUE IS NOT NULL
	  BEGIN
        IF @NPARAM IS NOT NULL  /* parameter in Neotoma, need to change */
	      BEGIN
            UPDATE NDB.LakeParameters
	        SET Value = @VALUE WHERE ((SiteID = @SITEID) AND (LakeParameterID = @LAKEPARAMETERID))
		    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation, ColumnName)
            VALUES      (@STEWARDCONTACTID, N'LakeParameters', @SITEID, @LAKEPARAMETERID, N'Update', N'Value')
	      END 
		ELSE     /* parameter not in Neotoma, need to add */
		  BEGIN
		    INSERT INTO NDB.LakeParameters (SiteID, LakeParameterID, Value)
            VALUES      (@SITEID, @LAKEPARAMETERID, @VALUE)
			INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation)
            VALUES      (@STEWARDCONTACTID, N'LakeParameters', @SITEID, @LAKEPARAMETERID, N'Insert')
		  END    
	  END
	ELSE   /* @VALUE is null */
	  BEGIN
	    IF @NPARAM IS NOT NULL  /* parameter in Neotoma, need to delete */
		  BEGIN
		    DELETE FROM NDB.LakeParameters 
			WHERE ((SiteID = @SITEID) AND (LakeParameterID = @LAKEPARAMETERID))
			INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, PK2, Operation)
            VALUES      (@STEWARDCONTACTID, N'LakeParameters', @SITEID, @LAKEPARAMETERID, N'Delete')
		  END
	  END    
  END





GO

-- ----------------------------
-- Procedure structure for UpdatePublication
-- ----------------------------


CREATE PROCEDURE [UpdatePublication](@PUBLICATIONID int,
@PUBTYPEID int,
@YEAR nvarchar(64) = null,
@CITATION nvarchar(MAX),
@TITLE nvarchar(MAX) = null,
@JOURNAL nvarchar(MAX) = null,
@VOL nvarchar(16) = null,
@ISSUE nvarchar(8) = null,
@PAGES nvarchar(24) = null,
@CITNUMBER nvarchar(24) = null,
@DOI nvarchar(128) = null,
@BOOKTITLE nvarchar(MAX) = null,
@NUMVOL nvarchar(8) = null,
@EDITION nvarchar(24) = null,
@VOLTITLE nvarchar(MAX) = null,
@SERTITLE nvarchar(MAX) = null,
@SERVOL nvarchar(16) = null,
@PUBLISHER nvarchar(255) = null,
@URL nvarchar(MAX) = null,
@CITY nvarchar(64) = null,
@STATE nvarchar(64) = null,
@COUNTRY nvarchar(64) = null,
@ORIGLANG nvarchar(64) = null,
@NOTES nvarchar(MAX) = null)

AS UPDATE NDB.Publications

Set PubTypeID = @PUBTYPEID, Year = @YEAR, Citation = @CITATION, ArticleTitle = @TITLE, Journal = @JOURNAL, Volume = @VOL,
    Issue = @ISSUE, Pages = @PAGES, CitationNumber = @CITNUMBER, DOI = @DOI, BookTitle = @BOOKTITLE, NumVolumes = @NUMVOL,
    Edition = @EDITION, VolumeTitle = @VOLTITLE, SeriesTitle = @SERTITLE, SeriesVolume = @SERVOL, Publisher = @PUBLISHER, 
    URL = @URL, City = @CITY, State = @STATE, Country = @COUNTRY, OriginalLanguage = @ORIGLANG, Notes = @NOTES                
WHERE PublicationID = @PUBLICATIONID






GO

-- ----------------------------
-- Procedure structure for UpdatePublicationAuthor
-- ----------------------------



CREATE PROCEDURE [UpdatePublicationAuthor](@AUTHORID int,
@PUBLICATIONID int,
@AUTHORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null,
@CONTACTID int)

AS UPDATE NDB.PublicationAuthors

Set PublicationID = @PUBLICATIONID, AuthorOrder = @AUTHORORDER, FamilyName = @FAMILYNAME, Initials = @INITIALS, 
    Suffix = @SUFFIX, ContactID = @CONTACTID                
WHERE AuthorID = @AUTHORID







GO

-- ----------------------------
-- Procedure structure for UpdatePublicationEditor
-- ----------------------------




CREATE PROCEDURE [UpdatePublicationEditor](@EDITORID int,
@PUBLICATIONID int,
@EDITORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null)

AS UPDATE NDB.PublicationEditors

Set PublicationID = @PUBLICATIONID, EditorOrder = @EDITORORDER, FamilyName = @FAMILYNAME, Initials = @INITIALS, Suffix = @SUFFIX                
WHERE EditorID = @EDITORID








GO

-- ----------------------------
-- Procedure structure for UpdatePublicationTranslator
-- ----------------------------





CREATE PROCEDURE [UpdatePublicationTranslator](@TRANSLATORID int,
@PUBLICATIONID int,
@TRANSLATORORDER int,
@FAMILYNAME nvarchar(64),
@INITIALS nvarchar(8) = null,
@SUFFIX nvarchar(8) = null)

AS UPDATE NDB.PublicationTranslators

Set PublicationID = @PUBLICATIONID, TranslatorOrder = @TRANSLATORORDER, FamilyName = @FAMILYNAME, Initials = @INITIALS, Suffix = @SUFFIX                
WHERE TranslatorID = @TRANSLATORID









GO

-- ----------------------------
-- Procedure structure for UpdateRadiocarbon
-- ----------------------------


CREATE PROCEDURE [UpdateRadiocarbon](@GEOCHRONID int,
@RADIOCARBONMETHODID int = null,
@PERCENTC float = null,
@PERCENTN float = null,
@DELTA13C float = null,
@DELTA15N float = null,
@PERCENTCOLLAGEN float = null,
@RESERVOIR float = null)

AS 
UPDATE NDB.Radiocarbon
SET    RadiocarbonMethodID = @RADIOCARBONMETHODID, PercentC = @PERCENTC, PercentN = @PERCENTN, Delta13C = @DELTA13C,
       Delta15N = @DELTA15N, PercentCollagen = @PERCENTCOLLAGEN, Reservoir = @RESERVOIR
WHERE  GeochronID = @GEOCHRONID

GO

-- ----------------------------
-- Procedure structure for UpdateRelativeAge
-- ----------------------------




CREATE PROCEDURE [UpdateRelativeAge](@RELATIVEAGEID int,
@RELATIVEAGEUNITID int,
@RELATIVEAGESCALEID int,
@RELATIVEAGE nvarchar(64),
@C14AGEYOUNGER float = null,
@C14AGEOLDER float = null,
@CALAGEYOUNGER float = null,
@CALAGEOLDER float = null,
@NOTES nvarchar(MAX) = null)

AS UPDATE NDB.RelativeAges

Set RelativeAgeUnitID = @RELATIVEAGEUNITID, RelativeAgeScaleID = @RELATIVEAGESCALEID, RelativeAge = @RELATIVEAGE, C14AgeYounger = @C14AGEYOUNGER, C14AgeOlder = @C14AGEOLDER,
    CalAgeYounger = @CALAGEYOUNGER, CalAgeOlder = @CALAGEOLDER, Notes = @NOTES                
WHERE RelativeAgeID = @RELATIVEAGEID





GO

-- ----------------------------
-- Procedure structure for UpdateReplacePublicationID
-- ----------------------------




CREATE PROCEDURE [UpdateReplacePublicationID](@KEEPPUBID int, @DEPOSEPUBID int)
AS 
/* Replace @DEPOSEPUBID with @KEEPPUBID and delete @DEPOSEPUBID */

DECLARE @N int
DECLARE @RESULTS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  Result nvarchar(255)
)

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

-- ----------------------------
-- Procedure structure for UpdateSampleAge
-- ----------------------------




CREATE PROCEDURE [UpdateSampleAge](@SAMPLEAGEID int, 
@AGE float = null,
@AGEYOUNGER float = null,
@AGEOLDER float = null)
AS 
IF (@AGE IS NOT NULL)
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.Age = @AGE
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END
ELSE
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.Age = NULL
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END

IF (@AGEYOUNGER IS NOT NULL)
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.AgeYounger = @AGEYOUNGER
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END
ELSE
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.AgeYounger = NULL
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END

IF (@AGEOLDER IS NOT NULL)
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.AgeOlder = @AGEOLDER
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END
ELSE
  BEGIN
    UPDATE NDB.SampleAges
    SET    NDB.SampleAges.AgeOlder = NULL
    WHERE  (NDB.SampleAges.SampleAgeID = @SAMPLEAGEID)
  END


GO

-- ----------------------------
-- Procedure structure for UpdateSampleAnalysisUnit
-- ----------------------------



CREATE PROCEDURE [UpdateSampleAnalysisUnit](@SAMPLEID int, @ANALUNITID int)
AS 
UPDATE NDB.Samples
SET AnalysisUnitID = @ANALUNITID
WHERE SampleID = @SAMPLEID





GO

-- ----------------------------
-- Procedure structure for UpdateSampleLabNumber
-- ----------------------------




CREATE PROCEDURE [UpdateSampleLabNumber](@SAMPLEID int, @LABNUMBER nvarchar(40) = null)
AS 
IF (@LABNUMBER IS NULL OR @LABNUMBER = N'')
  BEGIN
    UPDATE NDB.Samples
    SET    NDB.Samples.LabNumber = NULL
    WHERE  (NDB.Samples.SampleID = @SAMPLEID)
  END
ELSE
  BEGIN
    UPDATE NDB.Samples
    SET    NDB.Samples.LabNumber = @LABNUMBER
    WHERE  (NDB.Samples.SampleID = @SAMPLEID)
  END



GO

-- ----------------------------
-- Procedure structure for UpdateSite
-- ----------------------------




CREATE PROCEDURE [UpdateSite](@SITEID int,
@STEWARDCONTACTID int,
@SITENAME nvarchar(128), 
@EAST float = null,
@NORTH float = null,
@WEST float = null,
@SOUTH float = null,
@ALTITUDE int = null,
@AREA float = null,
@DESCRIPT nvarchar(MAX) = null,
@NOTES nvarchar(MAX) = null)

AS 
DECLARE @OldSiteName nvarchar(128) = (SELECT SiteName FROM NDB.Sites WHERE SiteID = @SITEID)
DECLARE @OldAltitude float = (SELECT Altitude FROM NDB.Sites WHERE SiteID = @SITEID)
DECLARE @OldArea float = (SELECT Area FROM NDB.Sites WHERE SiteID = @SITEID)
DECLARE @OldSiteDescription nvarchar(MAX) = (SELECT SiteDescription FROM NDB.Sites WHERE SiteID = @SITEID)
DECLARE @OldNotes nvarchar(MAX) = (SELECT Notes FROM NDB.Sites WHERE SiteID = @SITEID)
DECLARE @OldGeog geography = (SELECT geog FROM NDB.Sites WHERE SiteID = @SITEID)

IF @OldSiteName <> @SITENAME
  BEGIN
    UPDATE NDB.Sites
    SET SiteName = @SITENAME WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'SiteName')
  END

DECLARE @GEOG geography
IF ((@NORTH > @SOUTH) AND (@EAST > @WEST))
  SET @GEOG = geography::STGeomFromText('POLYGON((' + 
              CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
              CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + '))', 4326).MakeValid()
ELSE
  SET @GEOG = geography::STGeomFromText('POINT(' + CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ')', 4326).MakeValid() 
IF (@GEOG.STEquals(@OldGeog) IS NULL)
  BEGIN
    UPDATE NDB.Sites
    SET geog = @GEOG WHERE SiteID = @SITEID
	INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'geog')
  END

IF @ALTITUDE IS NULL
  BEGIN
    IF @OldAltitude IS NOT NULL
      BEGIN
        UPDATE NDB.Sites
        SET Altitude = NULL WHERE SiteID = @SITEID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Altitude')
      END
  END
ELSE IF (@OldAltitude IS NULL) OR (@ALTITUDE <> @OldAltitude)
  BEGIN
    UPDATE NDB.Sites
    SET Altitude = @ALTITUDE WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Altitude')
  END
IF @AREA IS NULL
  BEGIN
    IF @OldArea IS NOT NULL
      BEGIN
        UPDATE NDB.Sites
        SET Area = NULL WHERE SiteID = @SITEID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Area')
      END
  END
ELSE IF (@OldArea IS NULL) OR (@AREA <> @OldArea)
  BEGIN
    UPDATE NDB.Sites
    SET Area = @AREA WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Area')
  END
IF @DESCRIPT IS NULL
  BEGIN
    IF @OldSiteDescription IS NOT NULL
      BEGIN
        UPDATE NDB.Sites
        SET SiteDescription = NULL WHERE SiteID = @SITEID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'SiteDescription')
      END
  END
ELSE IF (@OldSiteDescription IS NULL) OR (@DESCRIPT <> @OldSiteDescription)
  BEGIN
    UPDATE NDB.Sites
    SET SiteDescription = @DESCRIPT WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'SiteDescription')
  END
IF @NOTES IS NULL
  BEGIN
    IF @OldNotes IS NOT NULL
      BEGIN
        UPDATE NDB.Sites
        SET Notes = NULL WHERE SiteID = @SITEID 
	    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
        VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Notes')
      END
  END
ELSE IF (@OldNotes IS NULL) OR (@NOTES <> @OldNotes)
  BEGIN
    UPDATE NDB.Sites
    SET Notes = @NOTES WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'Notes')
  END

GO

-- ----------------------------
-- Procedure structure for UpdateSiteGeoPol
-- ----------------------------

CREATE PROCEDURE [UpdateSiteGeoPol](@SITEID int, @STEWARDCONTACTID int, @OLDGEOPOLID int, @NEWGEOPOLID int)
AS 
DECLARE @SITEGEOPOLID int = (SELECT SiteGeoPoliticalID FROM NDB.SiteGeoPolitical WHERE (SiteID = @SITEID AND GeoPoliticalID = @OLDGEOPOLID))
IF @SITEGEOPOLID IS NOT NULL
BEGIN
  UPDATE NDB.SiteGeoPolitical
  SET GeoPoliticalID = @NEWGEOPOLID WHERE SiteGeoPoliticalID = @SITEGEOPOLID
  INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
  VALUES      (@STEWARDCONTACTID, N'SiteGeoPolitical', @SITEGEOPOLID, N'Update', N'GeoPoliticalID')
END



GO

-- ----------------------------
-- Procedure structure for UpdateSiteGeoPolDelete
-- ----------------------------



CREATE PROCEDURE [UpdateSiteGeoPolDelete](@STEWARDCONTACTID int, @SITEID int, @GEOPOLITICALID int)
AS 
DECLARE @SITEGEOPOLID int = (SELECT SiteGeoPoliticalID FROM NDB.SiteGeoPolitical WHERE (SiteID = @SITEID AND GeoPoliticalID = @GEOPOLITICALID))
IF @SITEGEOPOLID IS NOT NULL
  BEGIN
    DELETE FROM NDB.SiteGeoPolitical WHERE (SiteGeoPoliticalID = @SITEGEOPOLID)
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation)
    VALUES      (@STEWARDCONTACTID, N'SiteGeoPolitical', @SITEGEOPOLID, N'Delete')
  END



GO

-- ----------------------------
-- Procedure structure for UpdateSiteGeoPolInsert
-- ----------------------------




CREATE PROCEDURE [UpdateSiteGeoPolInsert](@SITEID int, @STEWARDCONTACTID int, @GEOPOLITICALID int)

AS 
INSERT INTO NDB.SiteGeoPolitical(SiteID, GeoPoliticalID)
VALUES      (@SITEID, @GEOPOLITICALID)

/*
---return id 
DECLARE @NewSiteGeoPoliticalID int = (SELECT SCOPE_IDENTITY())
SELECT @NewSiteGeoPoliticalID
*/

DECLARE @NewSiteGeoPoliticalID int = (SELECT SiteGeoPoliticalID FROM NDB.SiteGeoPolitical WHERE (SiteID = @SITEID AND GeoPoliticalID = @GEOPOLITICALID))
INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation)
VALUES      (@STEWARDCONTACTID, N'SiteGeoPolitical', @NewSiteGeoPoliticalID, N'Insert')

GO

-- ----------------------------
-- Procedure structure for UpdateSiteLatLon
-- ----------------------------



CREATE PROCEDURE [UpdateSiteLatLon](@SITEID int, @STEWARDCONTACTID int, @EAST float, @NORTH float, @WEST float, @SOUTH float)
AS 
DECLARE @OldGeog geography = (SELECT geog FROM NDB.Sites WHERE SiteID = @SITEID) 
DECLARE @GEOG geography
IF ((@NORTH > @SOUTH) AND (@EAST > @WEST))
  SET @GEOG = geography::STGeomFromText('POLYGON((' + 
              CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
              CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			  CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + '))', 4326).MakeValid()
ELSE
  SET @GEOG = geography::STGeomFromText('POINT(' + CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ')', 4326).MakeValid()  
IF (@GEOG.STEquals(@OldGeog) = 0)
  BEGIN
    UPDATE NDB.Sites
    SET    geog = @GEOG WHERE SiteID = @SITEID
    INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName)
    VALUES      (@STEWARDCONTACTID, N'Sites', @SITEID, N'Update', N'geog')
  END

GO

-- ----------------------------
-- Procedure structure for UpdateSpecimenDateTaxonID
-- ----------------------------




CREATE PROCEDURE [UpdateSpecimenDateTaxonID](@OLDTAXONID int, @NEWTAXONID int)
AS 
UPDATE NDB.SpecimenDates
Set TaxonID = @NEWTAXONID
WHERE TaxonID = @OLDTAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateSpecimenNISP
-- ----------------------------





CREATE PROCEDURE [UpdateSpecimenNISP](@SPECIMENID int, @NISP float, @CONTACTID int)
AS 
UPDATE NDB.Specimens
Set NDB.Specimens.NISP = @NISP
WHERE NDB.Specimens.SpecimenID = @SPECIMENID
INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation, ColumnName) 
VALUES (@CONTACTID, N'Specimens', @SPECIMENID, N'Update', N'NISP')

GO

-- ----------------------------
-- Procedure structure for UpdateSynonymTypeID
-- ----------------------------



CREATE PROCEDURE [UpdateSynonymTypeID](@SYNONYMID int, @SYNONYMTYPEID int)
AS 
UPDATE NDB.Synonyms
Set SynonymTypeID = @SYNONYMTYPEID
WHERE SynonymID = @SYNONYMID





GO

-- ----------------------------
-- Procedure structure for UpdateSynonymy
-- ----------------------------



CREATE PROCEDURE [UpdateSynonymy](@SYNONYMYID int,
@REFTAXONID int,
@FROMCONTRIBUTOR bit = 0,
@PUBLICATIONID int = null,
@NOTES nvarchar(MAX) = null,
@CONTACTID int = null,
@DATESYNONYMIZED date = null)

AS 
UPDATE NDB.Synonymy
Set RefTaxonID = @REFTAXONID, 
    FromContributor = @FROMCONTRIBUTOR, 
	PublicationID = @PUBLICATIONID, 
	Notes = @NOTES, 
	ContactID = @CONTACTID, 
	DateSynonymized = convert(datetime, @DATESYNONYMIZED, 105)
WHERE SynonymyID = @SYNONYMYID

INSERT INTO TI.StewardUpdates(ContactID, TableName, PK1, Operation)
VALUES      (@CONTACTID, N'Synonymy', @SYNONYMYID, N'Update')





GO

-- ----------------------------
-- Procedure structure for UpdateTaphonomicSystemNotes
-- ----------------------------




CREATE PROCEDURE [UpdateTaphonomicSystemNotes](@TAPHONOMICSYSTEMID int, @NOTES nvarchar(MAX))

AS UPDATE NDB.TaphonomicSystems

Set Notes = @NOTES                
WHERE TaphonomicSystemID = @TAPHONOMICSYSTEMID







GO

-- ----------------------------
-- Procedure structure for UpdateTaxonAuthor
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonAuthor](@TAXONID int, @AUTHOR nvarchar(128) = null)
AS 
UPDATE NDB.Taxa
Set Author = @AUTHOR
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateTaxonCode
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonCode](@TAXONID int, @TAXONCODE nvarchar(64))
AS 
UPDATE NDB.Taxa
Set TaxonCode = @TAXONCODE
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateTaxonExtinct
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonExtinct](@TAXONID int, @EXTINCT bit)
AS 
UPDATE NDB.Taxa
Set Extinct = @EXTINCT
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateTaxonHigherTaxonID
-- ----------------------------



CREATE PROCEDURE [UpdateTaxonHigherTaxonID](@TAXONID int, @HIGHERTAXONID int)
AS 
UPDATE NDB.Taxa
Set HigherTaxonID = @HIGHERTAXONID
WHERE TaxonID = @TAXONID





GO

-- ----------------------------
-- Procedure structure for UpdateTaxonHigherTaxonIDToNull
-- ----------------------------




CREATE PROCEDURE [UpdateTaxonHigherTaxonIDToNull](@TAXONID int)
AS 
UPDATE NDB.Taxa
Set HigherTaxonID = NULL
WHERE TaxonID = @TAXONID



GO

-- ----------------------------
-- Procedure structure for UpdateTaxonName
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonName](@TAXONID int, @TAXONNAME nvarchar(80))
AS 
UPDATE NDB.Taxa
Set TaxonName = @TAXONNAME
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateTaxonNotes
-- ----------------------------



CREATE PROCEDURE [UpdateTaxonNotes](@TAXONID int, @NOTES nvarchar(MAX) = null)
AS 
UPDATE NDB.Taxa
Set Notes = @NOTES
WHERE TaxonID = @TAXONID





GO

-- ----------------------------
-- Procedure structure for UpdateTaxonPublicationID
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonPublicationID](@TAXONID int, @PUBLICATIONID int = null)
AS 
UPDATE NDB.Taxa
Set PublicationID = @PUBLICATIONID
WHERE TaxonID = @TAXONID




GO

-- ----------------------------
-- Procedure structure for UpdateTaxonValidation
-- ----------------------------


CREATE PROCEDURE [UpdateTaxonValidation](@TAXONID int, @VALIDATORID int, @VALIDATEDATE nvarchar(10))
AS 
UPDATE NDB.Taxa
Set ValidatorID = @VALIDATORID, ValidateDate = @VALIDATEDATE
WHERE TaxonID = @TAXONID

/* convert(varchar(10), cast(@VALIDATEDATE AS datetime), 105)
   convert(datetime, @VALIDATEDATE, 105) */


GO

-- ----------------------------
-- Procedure structure for UpdateTaxonValidity
-- ----------------------------



CREATE PROCEDURE [UpdateTaxonValidity](@TAXONID int, @VALID bit)
AS 
UPDATE NDB.Taxa
Set Valid = @VALID
WHERE TaxonID = @TAXONID





GO

-- ----------------------------
-- Procedure structure for UpdateVariableTaxonID
-- ----------------------------


CREATE PROCEDURE [UpdateVariableTaxonID](@VARIABLEID int, @NEWTAXONID int)
AS 
UPDATE NDB.Variables
SET    TaxonID = @NEWTAXONID
WHERE  (VariableID = @VARIABLEID)



GO

-- ----------------------------
-- Procedure structure for ValidateSteward
-- ----------------------------


CREATE PROCEDURE [ValidateSteward](@USERNAME nvarchar(15), @PWD nvarchar(15))
AS 
SELECT     NDB.ConstituentDatabases.DatabaseID
FROM         TI.Stewards INNER JOIN
                      TI.StewardDatabases ON TI.Stewards.StewardID = TI.StewardDatabases.StewardID INNER JOIN
                      NDB.ConstituentDatabases ON TI.StewardDatabases.DatabaseID = NDB.ConstituentDatabases.DatabaseID
WHERE     (TI.Stewards.username = @USERNAME) AND (TI.Stewards.pwd = @PWD)





GO

-- ----------------------------
-- Procedure structure for ValidateUserName
-- ----------------------------


CREATE PROCEDURE [ValidateUserName](@USERNAME nvarchar(15))
AS 
SELECT     ContactID, TaxonomyExpert
FROM         TI.Stewards
WHERE     (username = @USERNAME)






GO
