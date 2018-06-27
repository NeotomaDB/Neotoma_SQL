/*
Navicat SQL Server Data Transfer

Source Server         : db5-emswin-neotomaDev
Source Server Version : 110000
Source Host           : db5.emswin.psu.edu:1433
Source Database       : Neotoma
Source Schema         : TI

Target Server Type    : SQL Server
Target Server Version : 110000
File Encoding         : 65001

Date: 2018-06-27 14:34:15
*/


-- ----------------------------
-- Procedure structure for EPD_GetAgeBasis
-- ----------------------------




CREATE PROCEDURE [EPD_GetAgeBasis](@ENTITYNR int, @CHRONNR int)
AS 
SELECT     TOP (100) PERCENT DepthCM, Thickness, Age, AgeUp, AgeLo, RCode
FROM         EPD.dbo.AGEBASIS
WHERE     (E# = @ENTITYNR) AND (Chron# = @CHRONNR)
ORDER BY DepthCM


GO

-- ----------------------------
-- Procedure structure for EPD_GetAllSites
-- ----------------------------





CREATE PROCEDURE [EPD_GetAllSites]
AS 
SELECT     EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, EPD.dbo.SITELOC.AreaOfSite, 
                      EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3
FROM         EPD.dbo.SITELOC LEFT OUTER JOIN
                      EPD.dbo.POLDIV3 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV3.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV3.PolDiv2 AND 
                      EPD.dbo.SITELOC.PolDiv3 = EPD.dbo.POLDIV3.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
ORDER BY EPD.dbo.SITELOC.Site#






GO

-- ----------------------------
-- Procedure structure for EPD_GetAuthors
-- ----------------------------


CREATE PROCEDURE [EPD_GetAuthors](@PUBLNR int)
AS 
SELECT     TOP (100) PERCENT EPD.dbo.AUTHORS.[Order], EPD.dbo.WORKERS.Worker# 
FROM         EPD.dbo.AUTHORS INNER JOIN
                      EPD.dbo.WORKERS ON EPD.dbo.AUTHORS.Author# = EPD.dbo.WORKERS.Worker#
WHERE     (EPD.dbo.AUTHORS.Publ# = @PUBLNR)
ORDER BY EPD.dbo.AUTHORS.[Order]




GO

-- ----------------------------
-- Procedure structure for EPD_GetC14
-- ----------------------------



CREATE PROCEDURE [EPD_GetC14](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, AgeBP, AgeSDUp, AgeSDLo, GrThanAge, Basis, LabNumber, DeltaC13, Notes
FROM         EPD.dbo.C14
WHERE     (E# = @ENTITYNR)
ORDER BY Sample#

GO

-- ----------------------------
-- Procedure structure for EPD_GetChron
-- ----------------------------




CREATE PROCEDURE [EPD_GetChron](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT EPD.dbo.CHRON.Chron#, EPD.dbo.CHRON.[Default], EPD.dbo.CHRON.Name, EPD.dbo.CHRON.DatePrepared, EPD.dbo.CHRON.Model, 
                      EPD.dbo.CHRON.Notes, EPD.dbo.CHRON_PreparedBy.NeotomaContactID, EPD.dbo.CHRON_PreparedBy.Worker#,
					  EPD.dbo.AGEBOUND.[Top], EPD.dbo.AGEBOUND.Bottom
FROM         EPD.dbo.CHRON LEFT OUTER JOIN
                      EPD.dbo.CHRON_PreparedBy ON EPD.dbo.CHRON.PreparedBy = EPD.dbo.CHRON_PreparedBy.PreparedBy LEFT OUTER JOIN
                      EPD.dbo.AGEBOUND ON EPD.dbo.CHRON.E# = EPD.dbo.AGEBOUND.E# AND EPD.dbo.CHRON.Chron# = EPD.dbo.AGEBOUND.Chron#
WHERE     (EPD.dbo.CHRON.E# = @ENTITYNR)
ORDER BY EPD.dbo.CHRON.Chron#


GO

-- ----------------------------
-- Procedure structure for EPD_GetCountriesWithSitesNotInNeotoma
-- ----------------------------




CREATE PROCEDURE [EPD_GetCountriesWithSitesNotInNeotoma]
AS 
SELECT     TOP (100) PERCENT EPD.dbo.POLDIV1.Name AS PolDiv1, NDB.GeoPoliticalUnits.GeoPoliticalID
FROM         EPD.dbo.P_ENTITY INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.P_ENTITY.E# = EPD.dbo.ENTITY.E# INNER JOIN
                      EPD.dbo.SITELOC ON EPD.dbo.ENTITY.Site# = EPD.dbo.SITELOC.Site# INNER JOIN
                      EPD.dbo.POLDIV1 INNER JOIN
                      NDB.GeoPoliticalUnits ON EPD.dbo.POLDIV1.Name = NDB.GeoPoliticalUnits.GeoPoliticalName ON 
                      EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1 LEFT OUTER JOIN
                      EPD.dbo.EntityDatasetID ON EPD.dbo.ENTITY.E# = EPD.dbo.EntityDatasetID.E#
WHERE     (EPD.dbo.EntityDatasetID.E# IS NULL) AND (EPD.dbo.ENTITY.E# > 722)
GROUP BY EPD.dbo.POLDIV1.Name, NDB.GeoPoliticalUnits.Rank, NDB.GeoPoliticalUnits.GeoPoliticalID, EPD.dbo.P_ENTITY.UseStatus
HAVING      (EPD.dbo.P_ENTITY.UseStatus = N'U') AND (NDB.GeoPoliticalUnits.Rank = 1)
ORDER BY PolDiv1

/*
SELECT     TOP (100) PERCENT EPD.dbo.POLDIV1.Name AS PolDiv1, NDB.GeoPoliticalUnits.GeoPoliticalID
FROM         EPD.dbo.P_ENTITY INNER JOIN
                      EPD.dbo.ENTITY INNER JOIN
                      EPD.dbo.SITELOC ON EPD.dbo.ENTITY.Site# = EPD.dbo.SITELOC.Site# ON EPD.dbo.P_ENTITY.E# = EPD.dbo.ENTITY.E# LEFT OUTER JOIN
                      NDB.Sites ON EPD.dbo.SITELOC.SiteName = NDB.Sites.SiteName LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 LEFT OUTER JOIN
                      NDB.GeoPoliticalUnits ON EPD.dbo.POLDIV1.Name = NDB.GeoPoliticalUnits.GeoPoliticalName ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
WHERE     (NDB.Sites.SiteID IS NULL)
GROUP BY EPD.dbo.POLDIV1.Name, NDB.GeoPoliticalUnits.Rank, NDB.GeoPoliticalUnits.GeoPoliticalID, EPD.dbo.P_ENTITY.UseStatus
HAVING      (NDB.GeoPoliticalUnits.Rank = 1) AND (EPD.dbo.P_ENTITY.UseStatus = N'U')
ORDER BY PolDiv1
*/
GO

-- ----------------------------
-- Procedure structure for EPD_GetCountry
-- ----------------------------






CREATE PROCEDURE [EPD_GetCountry](@POLDIV1 nvarchar(3))
AS 
SELECT     Name
FROM       EPD.dbo.POLDIV1
WHERE     (PolDiv1 = @POLDIV1)






GO

-- ----------------------------
-- Procedure structure for EPD_GetEntitiesBySiteNr
-- ----------------------------



CREATE PROCEDURE [EPD_GetEntitiesBySiteNr](@SITENR int)
AS 
SELECT     EPD.dbo.ENTITY.E#, EPD.dbo.ENTITY.Sigle, EPD.dbo.ENTITY.Name
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E# LEFT OUTER JOIN
                      EPD.dbo.EntityDatasetID ON EPD.dbo.ENTITY.E# = EPD.dbo.EntityDatasetID.E#
WHERE     (EPD.dbo.P_ENTITY.UseStatus = N'U') AND (EPD.dbo.SITELOC.Site# = @SITENR) AND (EPD.dbo.ENTITY.E# > 722) AND (EPD.dbo.EntityDatasetID.DatasetID IS NULL)

/*
SELECT     EPD.dbo.ENTITY.E#, EPD.dbo.ENTITY.Sigle, EPD.dbo.ENTITY.Name
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E#
WHERE     (EPD.dbo.P_ENTITY.UseStatus = N'U') AND (EPD.dbo.SITELOC.Site# = @SITENR)
*/

GO

-- ----------------------------
-- Procedure structure for EPD_GetEntity
-- ----------------------------





CREATE PROCEDURE [EPD_GetEntity](@ENTITYNR int)
AS 
SELECT     EPD.dbo.ENTITY.Sigle, EPD.dbo.ENTITY.Name, EPD.dbo.ENTITY.IsCore, EPD.dbo.ENTITY.IsSect, EPD.dbo.ENTITY.IsSSamp, EPD.dbo.DESCR.DepEnvt, EPD.dbo.ENTITY.EntLoc, EPD.dbo.ENTITY.LocalVeg, 
                      EPD.dbo.ENTITY.Coll#, EPD.dbo.ENTITY.SampDate, EPD.dbo.ENTITY.DepthAtLoc, EPD.dbo.ENTITY.SampDevice, EPD.dbo.ENTITY.CoreDiamCM, EPD.dbo.ENTITY.Notes
FROM         EPD.dbo.ENTITY INNER JOIN
                      EPD.dbo.DESCR ON EPD.dbo.ENTITY.Descriptor = EPD.dbo.DESCR.Descriptor
WHERE     (EPD.dbo.ENTITY.E# = @ENTITYNR)







GO

-- ----------------------------
-- Procedure structure for EPD_GetGeochron
-- ----------------------------




CREATE PROCEDURE [EPD_GetGeochron](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, Method, DepthCM, Thickness, MaterialDated, Publ#
FROM         EPD.dbo.GEOCHRON
WHERE     (E# = @ENTITYNR)
ORDER BY DepthCM






GO

-- ----------------------------
-- Procedure structure for EPD_GetLithology
-- ----------------------------



CREATE PROCEDURE [EPD_GetLithology](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Descript, DepthTopCM, DepthBotCM, LoBoundary
FROM         EPD.dbo.LITHOLGY
WHERE     (E# = @ENTITYNR)
ORDER BY Lith#




GO

-- ----------------------------
-- Procedure structure for EPD_GetLOI
-- ----------------------------



CREATE PROCEDURE [EPD_GetLOI](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT DepthCM, Thickness, TempLo, LOILo, TempHi, LOIHi, BulkDens
FROM         EPD.dbo.LOI
WHERE     (E# = @ENTITYNR)
ORDER BY DepthCM




GO

-- ----------------------------
-- Procedure structure for EPD_GetMADCAPAgeModel
-- ----------------------------




CREATE PROCEDURE [EPD_GetMADCAPAgeModel](@SIGLE nvarchar(255))
AS 
SELECT     AgeModelType
FROM         EPD.dbo.MADCAP_AgeModels
WHERE     (Sigle = @SIGLE)





GO

-- ----------------------------
-- Procedure structure for EPD_GetMADCAPChronControls
-- ----------------------------





CREATE PROCEDURE [EPD_GetMADCAPChronControls](@SIGLE nvarchar(255))
AS 
SELECT     DepthCM, Thickness, RCode, LabNr, Age14C, AgeCal, SD, Reservoir
FROM         EPD.dbo.MADCAP_ChronControls
WHERE     (Sigle = @SIGLE)






GO

-- ----------------------------
-- Procedure structure for EPD_GetMADCAPContactNotes
-- ----------------------------






CREATE PROCEDURE [EPD_GetMADCAPContactNotes](@SIGLE nvarchar(255))
AS 
SELECT     WorkerNr, Notes
FROM         EPD.dbo.MADCAP_ContactsNotes
WHERE     (Sigle = @SIGLE)







GO

-- ----------------------------
-- Procedure structure for EPD_GetMADCAPReliableAges
-- ----------------------------







CREATE PROCEDURE [EPD_GetMADCAPReliableAges](@SIGLE nvarchar(255))
AS 
SELECT     TOP (100) PERCENT MIN(Age) AS MinAge, MAX(Age) AS MaxAge
FROM         EPD.dbo.MADCAP_ReliableAges
WHERE     (Sigle = @SIGLE)








GO

-- ----------------------------
-- Procedure structure for EPD_GetMADCAPSampleAges
-- ----------------------------


CREATE PROCEDURE [EPD_GetMADCAPSampleAges](@SIGLE nvarchar(255))
AS 
SELECT     TOP (100) PERCENT DepthCM, Age, AgeMin, AgeMax
FROM         EPD.dbo.MADCAP_AllAges
WHERE     (Sigle = @SIGLE)
ORDER BY DepthCM





GO

-- ----------------------------
-- Procedure structure for EPD_GetPAgeDpt
-- ----------------------------




CREATE PROCEDURE [EPD_GetPAgeDpt](@ENTITYNR int, @CHRONNR int)
AS 
SELECT     Sample#, AgeBP, AgeUp, AgeLo
FROM         EPD.dbo.P_AGEDPT
WHERE     (E# = @ENTITYNR) AND (Chron# = @CHRONNR)






GO

-- ----------------------------
-- Procedure structure for EPD_GetPb210
-- ----------------------------




CREATE PROCEDURE [EPD_GetPb210](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, AgeAD, AgeSE, GrThanAge, Notes
FROM         EPD.dbo.PB210
WHERE     (E# = @ENTITYNR)
ORDER BY Sample#


GO

-- ----------------------------
-- Procedure structure for EPD_GetPCounts
-- ----------------------------





CREATE PROCEDURE [EPD_GetPCounts](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, Var#, Count
FROM         EPD.dbo.P_COUNTS
WHERE     (E# = @ENTITYNR)






GO

-- ----------------------------
-- Procedure structure for EPD_GetPEntity
-- ----------------------------



CREATE PROCEDURE [EPD_GetPEntity](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Contact#, DataSource
FROM         EPD.dbo.P_ENTITY
WHERE     (E# = @ENTITYNR)





GO

-- ----------------------------
-- Procedure structure for EPD_GetPSample
-- ----------------------------




CREATE PROCEDURE [EPD_GetPSample](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, DepthCM, Thickness, Analyst#, AnalyDate, Notes
FROM         EPD.dbo.P_SAMPLE
WHERE     (E# = @ENTITYNR)





GO

-- ----------------------------
-- Procedure structure for EPD_GetPubl
-- ----------------------------



CREATE PROCEDURE [EPD_GetPubl](@PUBLNR int)
AS 
SELECT     TOP (100) PERCENT Publ#, YearOfPubl, Citation
FROM         EPD.dbo.PUBL
WHERE     (Publ# = @PUBLNR)





GO

-- ----------------------------
-- Procedure structure for EPD_GetPublEnt
-- ----------------------------


CREATE PROCEDURE [EPD_GetPublEnt](@ENTITYNR int)
AS 
SELECT     EPD.dbo.PUBL.Publ#, EPD.dbo.PUBL.YearOfPubl, EPD.dbo.PUBL.Citation
FROM         EPD.dbo.PUBLENT INNER JOIN
                      EPD.dbo.PUBL ON EPD.dbo.PUBLENT.Publ# = EPD.dbo.PUBL.Publ#
WHERE     (EPD.dbo.PUBLENT.E# = @ENTITYNR)




GO

-- ----------------------------
-- Procedure structure for EPD_GetPVars
-- ----------------------------



CREATE PROCEDURE [EPD_GetPVars](@ENTITYNR int)
AS 

DECLARE @COUNT int
DECLARE @VARS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  Var# int,
  VarName nvarchar(80),
  TaxonCode nvarchar(64), 
  TaxonName nvarchar(80),
  Element nvarchar(255),
  Units nvarchar(64),
  Context nvarchar(64),
  Taphonomy nvarchar(64),
  EcolGroup nvarchar(4)
)

INSERT INTO @VARS (Var#, VarName, TaxonName, Element, Units, Context, Taphonomy)
  SELECT     TOP (100) PERCENT EPD.dbo.P_VARS.Var#, EPD.dbo.P_VARS.VarName, EPD.dbo.P_VARS_NeotomaTaxa.NeotomaTaxonName, EPD.dbo.P_VARS_NeotomaTaxa.Element, 
                      EPD.dbo.P_VARS_NeotomaTaxa.Units, EPD.dbo.P_VARS_NeotomaTaxa.Context, EPD.dbo.P_VARS_NeotomaTaxa.Taphonomy
  FROM         EPD.dbo.P_COUNTS INNER JOIN
                      EPD.dbo.P_VARS ON EPD.dbo.P_COUNTS.Var# = EPD.dbo.P_VARS.Var# INNER JOIN
                      EPD.dbo.P_VARS_NeotomaTaxa ON EPD.dbo.P_VARS.Var# = EPD.dbo.P_VARS_NeotomaTaxa.Var#
  GROUP BY EPD.dbo.P_COUNTS.E#, EPD.dbo.P_VARS.Var#, EPD.dbo.P_VARS.VarName, EPD.dbo.P_VARS_NeotomaTaxa.NeotomaTaxonName, EPD.dbo.P_VARS_NeotomaTaxa.Element, 
                      EPD.dbo.P_VARS_NeotomaTaxa.Units, EPD.dbo.P_VARS_NeotomaTaxa.Context, EPD.dbo.P_VARS_NeotomaTaxa.Taphonomy
  HAVING      (EPD.dbo.P_COUNTS.E# = @ENTITYNR)
  ORDER BY EPD.dbo.P_VARS_NeotomaTaxa.NeotomaTaxonName

DECLARE @NROWS int = @@ROWCOUNT
DECLARE @CURRENTID int = 0
DECLARE @VARNAME nvarchar(80)
DECLARE @TAXONNAME nvarchar(80)
DECLARE @TAXONCODE nvarchar(64)
DECLARE @ECOLGROUP nvarchar(4)
DECLARE @SYNONYM nvarchar(80)

WHILE @CURRENTID < @NROWS
  BEGIN 
    SET @CURRENTID = @CURRENTID+1
	SET @TAXONNAME = (SELECT TaxonName FROM @VARS WHERE ID = @CURRENTID) 
	SET @COUNT = (SELECT COUNT(TaxonCode) FROM NDB.Taxa WHERE (TaxonName = @TAXONNAME))
	IF @COUNT > 1
	  SET @TAXONCODE = (SELECT NDB.Taxa.TaxonCode FROM NDB.Taxa WHERE ((NDB.Taxa.TaxonName = @TAXONNAME)) AND (NDB.Taxa.TaxaGroupID = N'VPL'))
	ELSE    
	  SET @TAXONCODE = (SELECT NDB.Taxa.TaxonCode FROM NDB.Taxa WHERE (NDB.Taxa.TaxonName = @TAXONNAME))
	IF @TAXONCODE IS NOT NULL 
	  BEGIN
	    UPDATE @VARS
        SET TaxonCode = @TAXONCODE
        WHERE ID = @CURRENTID
	  END
	SET @COUNT = (SELECT COUNT(NDB.EcolGroups.EcolGroupID) FROM NDB.Taxa INNER JOIN
                  NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
                  WHERE (NDB.Taxa.TaxonName = @TAXONNAME))
	IF @COUNT > 1
	  SET @ECOLGROUP = (SELECT NDB.EcolGroups.EcolGroupID
                      FROM   NDB.Taxa INNER JOIN NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
                      WHERE  ((NDB.Taxa.TaxonName = @TAXONNAME) AND (NDB.Taxa.TaxaGroupID = N'VPL'))
					  GROUP BY NDB.EcolGroups.EcolGroupID) 
	ELSE
	  SET @ECOLGROUP = (SELECT NDB.EcolGroups.EcolGroupID
                      FROM   NDB.Taxa INNER JOIN NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
                      WHERE  (NDB.Taxa.TaxonName = @TAXONNAME)
					  GROUP BY NDB.EcolGroups.EcolGroupID) 
	IF @ECOLGROUP IS NOT NULL 
	  BEGIN
	    UPDATE @VARS
        SET EcolGroup = @ECOLGROUP
        WHERE ID = @CURRENTID
	  END
    SET @VARNAME = (SELECT VarName FROM @VARS WHERE (ID = @CURRENTID))
	SET @VARNAME = (SELECT REPLACE(@VARNAME,N'subfam.',N'subf.'))
	SET @VARNAME = (SELECT REPLACE(@VARNAME,N'subgen.',N'subg.'))
	SET @VARNAME = (SELECT REPLACE(@VARNAME,N'undifferentiated',N'undiff.'))
	IF @VARNAME = @TAXONNAME
	  BEGIN
	    UPDATE @VARS
		SET VarName = null
		WHERE ID = @CURRENTID
	  END
    ELSE
	  BEGIN
	    SET @SYNONYM = (SELECT NDB.Taxa.TaxonName FROM NDB.Taxa WHERE (NDB.Taxa.TaxonName = @VARNAME))
		BEGIN
		  UPDATE @VARS
		  SET VarName = @SYNONYM
		  WHERE ID = @CURRENTID
		END  
	  END
  END

SELECT TOP (100) PERCENT Var#, VarName, TaxonCode, TaxonName, Element, Units, Context, Taphonomy, EcolGroup
FROM @VARS
ORDER BY TaxonName


GO

-- ----------------------------
-- Procedure structure for EPD_GetSiteByName
-- ----------------------------




CREATE PROCEDURE [EPD_GetSiteByName](@SITENAME nvarchar(128))
AS 

SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3, 
                      EPD.dbo.P_ENTITY.UseStatus
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E# LEFT OUTER JOIN
                      EPD.dbo.EntityDatasetID ON EPD.dbo.ENTITY.E# = EPD.dbo.EntityDatasetID.E# LEFT OUTER JOIN
                      EPD.dbo.POLDIV3 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV3.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV3.PolDiv2 AND 
                      EPD.dbo.SITELOC.PolDiv3 = EPD.dbo.POLDIV3.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
WHERE     (EPD.dbo.EntityDatasetID.DatasetID IS NULL) AND (EPD.dbo.ENTITY.E# > 722)
GROUP BY EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name, EPD.dbo.POLDIV2.Name, EPD.dbo.POLDIV3.Name, EPD.dbo.P_ENTITY.UseStatus
HAVING      (EPD.dbo.SITELOC.SiteName LIKE @SITENAME)
ORDER BY EPD.dbo.SITELOC.Site#


/*
SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3, 
                      EPD.dbo.P_ENTITY.UseStatus
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E# LEFT OUTER JOIN
                      NDB.Sites ON EPD.dbo.SITELOC.SiteName = NDB.Sites.SiteName LEFT OUTER JOIN
                      EPD.dbo.POLDIV3 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV3.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV3.PolDiv2 AND 
                      EPD.dbo.SITELOC.PolDiv3 = EPD.dbo.POLDIV3.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
GROUP BY EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name, EPD.dbo.POLDIV2.Name, EPD.dbo.POLDIV3.Name, EPD.dbo.P_ENTITY.UseStatus, NDB.Sites.SiteID
HAVING      (NDB.Sites.SiteID IS NULL) AND (EPD.dbo.SITELOC.SiteName LIKE @SITENAME)
ORDER BY EPD.dbo.SITELOC.Site#
*/

GO

-- ----------------------------
-- Procedure structure for EPD_GetSiteDescription
-- ----------------------------



CREATE PROCEDURE [EPD_GetSiteDescription](@SITENR int)
AS 
SELECT    SiteDescript, Physiography, SurroundVeg, VegFormation
FROM      EPD.dbo.SITEDESC
WHERE     (Site# = @SITENR)








GO

-- ----------------------------
-- Procedure structure for EPD_GetSitesInNeotoma
-- ----------------------------






CREATE PROCEDURE [EPD_GetSitesInNeotoma]
AS 
SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3, TI.GeoPol1.GeoPolName1, NDB.Sites.SiteID
FROM         EPD.dbo.POLDIV3 RIGHT OUTER JOIN
                      EPD.dbo.SITELOC ON EPD.dbo.POLDIV3.PolDiv1 = EPD.dbo.SITELOC.PolDiv1 AND EPD.dbo.POLDIV3.PolDiv2 = EPD.dbo.SITELOC.PolDiv2 AND 
                      EPD.dbo.POLDIV3.PolDiv3 = EPD.dbo.SITELOC.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      NDB.Sites INNER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID INNER JOIN
                      EPD.dbo.POLDIV1 ON TI.GeoPol1.GeoPolName1 = EPD.dbo.POLDIV1.Name ON EPD.dbo.SITELOC.SiteName = NDB.Sites.SiteName AND 
                      EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
WHERE     (NDB.Sites.SiteID IS NOT NULL)
ORDER BY EPD.dbo.SITELOC.Site#







GO

-- ----------------------------
-- Procedure structure for EPD_GetSitesNotInNeotoma
-- ----------------------------






CREATE PROCEDURE [EPD_GetSitesNotInNeotoma]
AS 
SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3
FROM         EPD.dbo.POLDIV1 RIGHT OUTER JOIN
                      NDB.Sites RIGHT OUTER JOIN
                      EPD.dbo.POLDIV3 RIGHT OUTER JOIN
                      EPD.dbo.SITELOC ON EPD.dbo.POLDIV3.PolDiv1 = EPD.dbo.SITELOC.PolDiv1 AND EPD.dbo.POLDIV3.PolDiv2 = EPD.dbo.SITELOC.PolDiv2 AND 
                      EPD.dbo.POLDIV3.PolDiv3 = EPD.dbo.SITELOC.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 ON 
                      NDB.Sites.SiteName = EPD.dbo.SITELOC.SiteName ON EPD.dbo.POLDIV1.PolDiv1 = EPD.dbo.SITELOC.PolDiv1
WHERE     (NDB.Sites.SiteID IS NULL)
ORDER BY EPD.dbo.SITELOC.Site#







GO

-- ----------------------------
-- Procedure structure for EPD_GetSitesNotInNeotomaByCountry
-- ----------------------------






CREATE PROCEDURE [EPD_GetSitesNotInNeotomaByCountry](@COUNTRY nvarchar(45))
AS
SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3, 
                      EPD.dbo.P_ENTITY.UseStatus
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E# LEFT OUTER JOIN
                      EPD.dbo.EntityDatasetID ON EPD.dbo.ENTITY.E# = EPD.dbo.EntityDatasetID.E# LEFT OUTER JOIN
                      EPD.dbo.POLDIV3 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV3.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV3.PolDiv2 AND 
                      EPD.dbo.SITELOC.PolDiv3 = EPD.dbo.POLDIV3.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
WHERE     (EPD.dbo.EntityDatasetID.DatasetID IS NULL) AND (EPD.dbo.ENTITY.E# > 722)
GROUP BY EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name, EPD.dbo.POLDIV2.Name, EPD.dbo.POLDIV3.Name, EPD.dbo.P_ENTITY.UseStatus
HAVING      (EPD.dbo.POLDIV1.Name = @COUNTRY)
ORDER BY EPD.dbo.SITELOC.Site#

/* 
SELECT     TOP (100) PERCENT EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name AS PolDiv1, EPD.dbo.POLDIV2.Name AS PolDiv2, EPD.dbo.POLDIV3.Name AS PolDiv3, 
                      EPD.dbo.P_ENTITY.UseStatus
FROM         EPD.dbo.SITELOC INNER JOIN
                      EPD.dbo.ENTITY ON EPD.dbo.SITELOC.Site# = EPD.dbo.ENTITY.Site# INNER JOIN
                      EPD.dbo.P_ENTITY ON EPD.dbo.ENTITY.E# = EPD.dbo.P_ENTITY.E# LEFT OUTER JOIN
                      NDB.Sites ON EPD.dbo.SITELOC.SiteName = NDB.Sites.SiteName LEFT OUTER JOIN
                      EPD.dbo.POLDIV3 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV3.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV3.PolDiv2 AND 
                      EPD.dbo.SITELOC.PolDiv3 = EPD.dbo.POLDIV3.PolDiv3 LEFT OUTER JOIN
                      EPD.dbo.POLDIV2 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV2.PolDiv1 AND EPD.dbo.SITELOC.PolDiv2 = EPD.dbo.POLDIV2.PolDiv2 LEFT OUTER JOIN
                      EPD.dbo.POLDIV1 ON EPD.dbo.SITELOC.PolDiv1 = EPD.dbo.POLDIV1.PolDiv1
GROUP BY EPD.dbo.SITELOC.Site#, EPD.dbo.SITELOC.SiteName, EPD.dbo.SITELOC.LatDD, EPD.dbo.SITELOC.LonDD, EPD.dbo.SITELOC.Elevation, 
                      EPD.dbo.SITELOC.AreaOfSite, EPD.dbo.POLDIV1.Name, EPD.dbo.POLDIV2.Name, EPD.dbo.POLDIV3.Name, EPD.dbo.P_ENTITY.UseStatus, NDB.Sites.SiteID
HAVING      (NDB.Sites.SiteID IS NULL) AND (EPD.dbo.POLDIV1.Name = @COUNTRY)
ORDER BY EPD.dbo.SITELOC.Site#
*/

GO

-- ----------------------------
-- Procedure structure for EPD_GetSynEvent
-- ----------------------------



CREATE PROCEDURE [EPD_GetSynEvent](@ENTITYNR int)
AS 
SELECT     EPD.dbo.SYNEVENT.DepthCM, EPD.dbo.SYNEVENT.Thickness, EPD.dbo.EVENT.Name, EPD.dbo.EVENT.AgeBP, EPD.dbo.EVENT.AgeUncertUp, EPD.dbo.EVENT.AgeUncertLo
FROM         EPD.dbo.SYNEVENT INNER JOIN
                      EPD.dbo.EVENT ON EPD.dbo.SYNEVENT.Event# = EPD.dbo.EVENT.Event#
WHERE     (EPD.dbo.SYNEVENT.E# = @ENTITYNR)




GO

-- ----------------------------
-- Procedure structure for EPD_GetTL
-- ----------------------------





CREATE PROCEDURE [EPD_GetTL](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, AgeBP, ErrorLimits, GrainSize, LabNumber, Notes
FROM         EPD.dbo.TL
WHERE     (E# = @ENTITYNR)
ORDER BY Sample#



GO

-- ----------------------------
-- Procedure structure for EPD_GetUSeries
-- ----------------------------



CREATE PROCEDURE [EPD_GetUSeries](@ENTITYNR int)
AS 
SELECT     TOP (100) PERCENT Sample#, AgeBP, ErrorLimits, LabNumber, Notes
FROM         EPD.dbo.USERIES
WHERE     (E# = @ENTITYNR)
ORDER BY Sample#




GO

-- ----------------------------
-- Procedure structure for EPD_GetWorker
-- ----------------------------




CREATE PROCEDURE [EPD_GetWorker](@WORKERNR int)
AS 
SELECT     Status, LastName, Initials, FirstName, Suffix, Title, Country, Phone, Fax, EMailAddr, Address
FROM         EPD.dbo.WORKERS
WHERE     (Worker# = @WORKERNR)









GO

-- ----------------------------
-- Procedure structure for GetAgeTypeID
-- ----------------------------




CREATE PROCEDURE [GetAgeTypeID](@AGETYPE nvarchar(64))
AS 
SELECT     AgeTypeID
FROM       NDB.AgeTypes
WHERE     (AgeType = @AGETYPE)






GO

-- ----------------------------
-- Procedure structure for GetAgeTypesTable
-- ----------------------------



CREATE PROCEDURE [GetAgeTypesTable]
AS 
SELECT     AgeTypeID, AgeType, Precedence, ShortAgeType
FROM         NDB.AgeTypes






GO

-- ----------------------------
-- Procedure structure for GetAggregateChronByDatasetID
-- ----------------------------




CREATE PROCEDURE [GetAggregateChronByDatasetID](@AGGREGATEDATASETID int)
AS
SELECT     AggregateChronID, AggregateDatasetID, AgeTypeID, IsDefault, ChronologyName, AgeBoundYounger, AgeBoundOlder, Notes
FROM         NDB.AggregateChronologies
WHERE     (AggregateDatasetID = @AGGREGATEDATASETID)






GO

-- ----------------------------
-- Procedure structure for GetAggregateDatasetByName
-- ----------------------------



CREATE PROCEDURE [GetAggregateDatasetByName](@NAME nvarchar(255))
AS
SELECT     AggregateDatasetID, AggregateDatasetName, AggregateOrderTypeID, Notes
FROM       NDB.AggregateDatasets
WHERE     (AggregateDatasetName = @NAME)





GO

-- ----------------------------
-- Procedure structure for GetAggregateOrderTypes
-- ----------------------------




CREATE PROCEDURE [GetAggregateOrderTypes]
AS 
SELECT     AggregateOrderTypeID, AggregateOrderType
FROM       NDB.AggregateOrderTypes





GO

-- ----------------------------
-- Procedure structure for GetAliasContactNames
-- ----------------------------





CREATE PROCEDURE [GetAliasContactNames]
AS 
SELECT     Contacts_1.ContactID AS AliasContactID, NDB.Contacts.ContactName AS AliasContactName, NDB.Contacts.ContactID AS CurrentContactID, 
                      Contacts_1.ContactName AS CurrentContactName
FROM         NDB.Contacts INNER JOIN
                      NDB.Contacts AS Contacts_1 ON NDB.Contacts.AliasID = Contacts_1.ContactID
WHERE     (NDB.Contacts.AliasID <> NDB.Contacts.ContactID)




GO

-- ----------------------------
-- Procedure structure for GetAllDatasetAuthors
-- ----------------------------




CREATE PROCEDURE [GetAllDatasetAuthors]
AS 
SELECT     TOP (100) PERCENT NDB.Contacts.ContactName
FROM         NDB.DatasetPublications INNER JOIN
                      NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                      NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID INNER JOIN
                      NDB.Contacts ON NDB.PublicationAuthors.ContactID = NDB.Contacts.ContactID
GROUP BY NDB.Contacts.ContactName
ORDER BY NDB.Contacts.ContactName




GO

-- ----------------------------
-- Procedure structure for GetAllDatasetPIs
-- ----------------------------



CREATE PROCEDURE [GetAllDatasetPIs]
AS 
SELECT     TOP (100) PERCENT NDB.Contacts.ContactName
FROM         NDB.DatasetPIs INNER JOIN
                      NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
GROUP BY NDB.Contacts.ContactName
ORDER BY NDB.Contacts.ContactName






GO

-- ----------------------------
-- Procedure structure for GetAnalysisUnit
-- ----------------------------



CREATE PROCEDURE [GetAnalysisUnit](@COLLECTIONUNIID int, @ANALUNITNAME nvarchar(80) = null, @DEPTH float = null, @THICKNESS float = null)
AS 
IF @ANALUNITNAME IS NULL AND @DEPTH IS NOT NULL AND @THICKNESS IS NOT NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName IS NULL) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS) 
END
ELSE IF @ANALUNITNAME IS NULL AND @DEPTH IS NOT NULL AND @THICKNESS IS NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName IS NULL) AND (Depth = @DEPTH) AND (Thickness IS NULL) 
END
ELSE IF @ANALUNITNAME IS NOT NULL AND @DEPTH IS NOT NULL AND @THICKNESS IS NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName = @ANALUNITNAME) AND (Depth = @DEPTH) AND (Thickness IS NULL) 
END
ELSE IF @ANALUNITNAME IS NOT NULL AND @DEPTH IS NULL AND @THICKNESS IS NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName = @ANALUNITNAME) AND (Depth IS NULL) AND (Thickness IS NULL) 
END
ELSE IF @ANALUNITNAME IS NOT NULL AND @DEPTH IS NULL AND @THICKNESS IS NOT NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName = @ANALUNITNAME) AND (Depth IS NULL) AND (Thickness = @THICKNESS) 
END
ELSE IF @ANALUNITNAME IS NOT NULL AND @DEPTH IS NOT NULL AND @THICKNESS IS NOT NULL
BEGIN
  SELECT AnalysisUnitID
  FROM   NDB.AnalysisUnits
  WHERE  (CollectionUnitID = @COLLECTIONUNIID) AND (AnalysisUnitName = @ANALUNITNAME) AND (Depth = @DEPTH) AND (Thickness = @THICKNESS) 
END
GO

-- ----------------------------
-- Procedure structure for GetAnalysisUnitByID
-- ----------------------------



CREATE PROCEDURE [GetAnalysisUnitByID](@ANALYUNITID int)
AS 
SELECT     CollectionUnitID, AnalysisUnitName, Depth, Thickness
FROM         NDB.AnalysisUnits
WHERE     (AnalysisUnitID = @ANALYUNITID)






GO

-- ----------------------------
-- Procedure structure for GetAnalysisUnitSampleCount
-- ----------------------------



-- gets number of samples assigned to analysis unit
CREATE PROCEDURE [GetAnalysisUnitSampleCount](@ANALUNITID int)
AS 
SELECT     COUNT(AnalysisUnitID) AS Count
FROM       NDB.Samples
WHERE      (AnalysisUnitID = @ANALUNITID)



GO

-- ----------------------------
-- Procedure structure for GetAnalysisUnitsByCollUnitID
-- ----------------------------




CREATE PROCEDURE [GetAnalysisUnitsByCollUnitID](@COLLUNITID int)
AS 
SELECT     AnalysisUnitID, AnalysisUnitName, Depth, Thickness
FROM       NDB.AnalysisUnits
WHERE      (CollectionUnitID = @COLLUNITID)







GO

-- ----------------------------
-- Procedure structure for GetBiochemDatasetByID
-- ----------------------------




CREATE PROCEDURE [GetBiochemDatasetByID](@DATASETID int)
AS 

DECLARE @DATASETTYPEID int = (SELECT DatasetTypeID FROM NDB.Datasets WHERE (DatasetID = @DATASETID))
IF @DATASETTYPEID = 27
  BEGIN
    SELECT     TOP (100) PERCENT NDB.Data.SampleID, NDB.AnalysisUnits.AnalysisUnitName, NDB.Samples.SampleName, CONVERT(nvarchar(10),NDB.Samples.SampleDate,120) AS SampleDate,
	                  NDB.Taxa.TaxonName, Taxa_1.TaxonName AS Variable, NDB.VariableElements.VariableElement, NDB.VariableUnits.VariableUnits, NDB.Data.Value
    FROM         NDB.Samples INNER JOIN
                      NDB.Taxa ON NDB.Samples.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa AS Taxa_1 ON NDB.Variables.TaxonID = Taxa_1.TaxonID LEFT OUTER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE     (NDB.Samples.DatasetID = @DATASETID)
    ORDER BY NDB.Data.SampleID
  END
ELSE
  SELECT N'Dataset is not biochemistry'


GO

-- ----------------------------
-- Procedure structure for GetCalibrationCurvesTable
-- ----------------------------




CREATE PROCEDURE [GetCalibrationCurvesTable]
AS 
SELECT      CalibrationCurveID, CalibrationCurve, PublicationID
FROM          NDB.CalibrationCurves







GO

-- ----------------------------
-- Procedure structure for GetCalibrationProgramsTable
-- ----------------------------




CREATE PROCEDURE [GetCalibrationProgramsTable]
AS 
SELECT      CalibrationProgramID, CalibrationProgram, Version
FROM        NDB.CalibrationPrograms







GO

-- ----------------------------
-- Procedure structure for GetChildTaxa
-- ----------------------------



CREATE PROCEDURE [GetChildTaxa](@TAXONNAME nvarchar(80))
AS
WITH TaxaCTE 
AS 
(
  SELECT TaxonID as baseTaxonId, TaxonID, TaxonName, Author, HigherTaxonID, 0 AS level
  FROM NDB.Taxa
  WHERE TaxonName = @TAXONNAME
    
  UNION ALL
  
  SELECT parent.baseTaxonId, child.TaxonID, child.TaxonName, child.Author, child.HigherTaxonID, parent.level +1 AS level
  FROM TaxaCTE AS parent
    INNER JOIN NDB.Taxa AS child
      ON parent.TaxonID = child.HigherTaxonID
)
SELECT TaxonID, TaxonName, Author, HigherTaxonID, level 
  FROM TaxaCTE
   ORDER BY level;

   


GO

-- ----------------------------
-- Procedure structure for GetChildTaxaCount
-- ----------------------------



CREATE PROCEDURE [GetChildTaxaCount](@HIGHERTAXONID int)
AS 
SELECT     COUNT(HigherTaxonID) AS Count
FROM         NDB.Taxa
WHERE     (HigherTaxonID <> TaxonID) AND (HigherTaxonID = @HIGHERTAXONID)


GO

-- ----------------------------
-- Procedure structure for GetChildTaxaForAllSites
-- ----------------------------




CREATE PROCEDURE [GetChildTaxaForAllSites](@TAXONNAME nvarchar(80))
AS
WITH TaxaCTE 
AS 
(
  SELECT TaxonID as baseTaxonId, TaxonID, TaxonName, Author, HigherTaxonID, 0 AS level
  FROM NDB.Taxa
  WHERE TaxonName = @TAXONNAME
    
  UNION ALL
  
  SELECT parent.baseTaxonId, child.TaxonID, child.TaxonName, child.Author, child.HigherTaxonID, parent.level +1 AS level
  FROM TaxaCTE AS parent
    INNER JOIN NDB.Taxa AS child
      ON parent.TaxonID = child.HigherTaxonID
)

SELECT     TaxaCTE.TaxonID, TaxaCTE.TaxonName, NDB.Sites.SiteName
FROM         TaxaCTE INNER JOIN
                      NDB.Variables ON TaxaCTE.TaxonID = NDB.Variables.TaxonID INNER JOIN
                      NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID INNER JOIN
                      NDB.Samples ON NDB.Data.SampleID = NDB.Samples.SampleID INNER JOIN
                      NDB.Datasets ON NDB.Samples.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID
GROUP BY TaxaCTE.TaxonID, TaxaCTE.TaxonName, NDB.Sites.SiteName




GO

-- ----------------------------
-- Procedure structure for GetChronConrolTypeByName
-- ----------------------------



CREATE PROCEDURE [GetChronConrolTypeByName](@CHRONCONTROLTYPE nvarchar(64))
AS 
SELECT     ChronControlTypeID, ChronControlType, HigherChronControlTypeID
FROM         NDB.ChronControlTypes
WHERE     (ChronControlType = @CHRONCONTROLTYPE)






GO

-- ----------------------------
-- Procedure structure for GetChronControlTypeHighestID
-- ----------------------------



CREATE PROCEDURE [GetChronControlTypeHighestID](@CHRONCONTROLTYPEID int)
AS 
DECLARE @ID int
DECLARE @HIGHERID int
SET @ID = @CHRONCONTROLTYPEID
SET @HIGHERID = (SELECT HigherChronControlTypeID FROM NDB.ChronControlTypes WHERE (ChronControlTypeID = @ID))
WHILE @ID <> @HIGHERID 
BEGIN
  SET @ID = @HIGHERID
  SET @HIGHERID = (SELECT HigherChronControlTypeID FROM NDB.ChronControlTypes WHERE (ChronControlTypeID = @ID))
END
SELECT ChronControlTypeID, ChronControlType, HigherChronControlTypeID
FROM NDB.ChronControlTypes
WHERE (ChronControlTypeID = @ID)




GO

-- ----------------------------
-- Procedure structure for GetChronControlTypesTable
-- ----------------------------


CREATE PROCEDURE [GetChronControlTypesTable]
AS 
SELECT      ChronControlTypeID, ChronControlType, HigherChronControlTypeID
FROM          NDB.ChronControlTypes





GO

-- ----------------------------
-- Procedure structure for GetChronoControlsByAnalysisUnitID
-- ----------------------------




CREATE PROCEDURE [GetChronoControlsByAnalysisUnitID](@ANALUNITID int)
AS 
SELECT    ChronControlID
FROM      NDB.ChronControls
WHERE     (AnalysisUnitID = @ANALUNITID)


GO

-- ----------------------------
-- Procedure structure for GetChronoControlsByChronologyID
-- ----------------------------



CREATE PROCEDURE [GetChronoControlsByChronologyID](@CHRONOLOGYID int)
AS 
SELECT     NDB.ChronControls.ChronControlID, NDB.ChronControls.ChronControlTypeID, NDB.ChronControlTypes.ChronControlType, NDB.ChronControls.Depth, 
                      NDB.ChronControls.Thickness, NDB.ChronControls.AnalysisUnitID, NDB.AnalysisUnits.AnalysisUnitName, NDB.ChronControls.AgeTypeID, NDB.ChronControls.Age, 
                      NDB.ChronControls.AgeLimitYounger, NDB.ChronControls.AgeLimitOlder, NDB.ChronControls.Notes, NDB.CalibrationCurves.CalibrationCurve, 
                      NDB.CalibrationPrograms.CalibrationProgram, NDB.CalibrationPrograms.Version
FROM         NDB.CalibrationPrograms INNER JOIN
                      NDB.ChronControlsCal14C ON NDB.CalibrationPrograms.CalibrationProgramID = NDB.ChronControlsCal14C.CalibrationProgramID INNER JOIN
                      NDB.CalibrationCurves ON NDB.ChronControlsCal14C.CalibrationCurveID = NDB.CalibrationCurves.CalibrationCurveID RIGHT OUTER JOIN
                      NDB.ChronControls INNER JOIN
                      NDB.ChronControlTypes ON NDB.ChronControls.ChronControlTypeID = NDB.ChronControlTypes.ChronControlTypeID ON 
                      NDB.ChronControlsCal14C.ChronControlID = NDB.ChronControls.ChronControlID LEFT OUTER JOIN
                      NDB.AnalysisUnits ON NDB.ChronControls.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
WHERE     (NDB.ChronControls.ChronologyID = @CHRONOLOGYID)

GO

-- ----------------------------
-- Procedure structure for GetChronologiesByCollUnitID
-- ----------------------------


CREATE PROCEDURE [GetChronologiesByCollUnitID](@COLLECTIONUNITID int)
AS 
SELECT      TOP (100) PERCENT NDB.Chronologies.ChronologyID, NDB.AgeTypes.AgeType, NDB.Chronologies.ChronologyName, 
                      NDB.Chronologies.IsDefault, NDB.Chronologies.AgeModel, NDB.Chronologies.AgeBoundOlder, NDB.Chronologies.AgeBoundYounger,   
                      NDB.Chronologies.ContactID, CONVERT(nvarchar(10), NDB.Chronologies.DatePrepared, 120) AS DatePrepared, NDB.Chronologies.Notes
FROM         NDB.Chronologies INNER JOIN
                      NDB.AgeTypes ON NDB.Chronologies.AgeTypeID = NDB.AgeTypes.AgeTypeID
WHERE     (NDB.Chronologies.CollectionUnitID = @COLLECTIONUNITID)
ORDER BY NDB.Chronologies.ChronologyID




GO

-- ----------------------------
-- Procedure structure for GetCollectionTypeByID
-- ----------------------------


CREATE PROCEDURE [GetCollectionTypeByID](@COLLTYPEID int)
AS 
SELECT     CollTypeID, CollType
FROM         NDB.CollectionTypes
WHERE     (CollTypeID = @COLLTYPEID)





GO

-- ----------------------------
-- Procedure structure for GetCollectionTypesTable
-- ----------------------------

CREATE PROCEDURE [GetCollectionTypesTable]
AS 
SELECT     CollTypeID, CollType
FROM         NDB.CollectionTypes




GO

-- ----------------------------
-- Procedure structure for GetCollector
-- ----------------------------





CREATE PROCEDURE [GetCollector](@COLLECTIONUNITID int)
AS 
SELECT     NDB.Contacts.ContactID, NDB.Contacts.AliasID, NDB.Contacts.ContactName, NDB.Contacts.ContactStatusID, NDB.Contacts.FamilyName, 
                      NDB.Contacts.LeadingInitials, NDB.Contacts.GivenNames, NDB.Contacts.Suffix, NDB.Contacts.Title, NDB.Contacts.Phone, NDB.Contacts.Fax, NDB.Contacts.Email, 
                      NDB.Contacts.URL, NDB.Contacts.Address, NDB.Contacts.Notes
FROM         NDB.Collectors INNER JOIN
                      NDB.Contacts ON NDB.Collectors.ContactID = NDB.Contacts.ContactID
WHERE     (NDB.Collectors.CollectionUnitID = @COLLECTIONUNITID)







GO

-- ----------------------------
-- Procedure structure for GetCollUnitByID
-- ----------------------------




CREATE PROCEDURE [GetCollUnitByID](@COLLECTIONUNITID int)
AS                                                                                
SELECT     CollectionUnitID, Handle, SiteID, CollTypeID, DepEnvtID, CollUnitName, CONVERT(nvarchar(10),CollDate,120) AS CollDate, CollDevice, GPSLatitude, GPSLongitude, GPSAltitude, 
                      GPSError, WaterDepth, SubstrateID, SlopeAspect, SlopeAngle, Location, Notes
FROM         NDB.CollectionUnits
WHERE     (CollectionUnitID = @COLLECTIONUNITID)



GO

-- ----------------------------
-- Procedure structure for GetCollUnitHandleCount
-- ----------------------------


CREATE PROCEDURE [GetCollUnitHandleCount](@HANDLE nvarchar(10))
AS 
SELECT     COUNT(Handle) AS Count
FROM       NDB.CollectionUnits
WHERE      (Handle = @HANDLE)



GO

-- ----------------------------
-- Procedure structure for GetCollUnitsBySiteID
-- ----------------------------





CREATE PROCEDURE [GetCollUnitsBySiteID](@SITEID int)
AS                                                                                
SELECT     NDB.Sites.SiteID, NDB.CollectionUnits.CollectionUnitID, NDB.CollectionUnits.Handle, NDB.CollectionUnits.SiteID, NDB.CollectionUnits.CollTypeID, 
                      NDB.CollectionUnits.DepEnvtID, NDB.CollectionUnits.CollUnitName, CONVERT(nvarchar(10),NDB.CollectionUnits.CollDate,120) AS CollDate, NDB.CollectionUnits.CollDevice, NDB.CollectionUnits.GPSLatitude, 
                      NDB.CollectionUnits.GPSLongitude, NDB.CollectionUnits.GPSAltitude, NDB.CollectionUnits.GPSError, NDB.CollectionUnits.WaterDepth, 
                      NDB.CollectionUnits.SubstrateID, NDB.CollectionUnits.SlopeAspect, NDB.CollectionUnits.SlopeAngle, NDB.CollectionUnits.Location, NDB.CollectionUnits.Notes
FROM         NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID
WHERE     (NDB.Sites.SiteID = @SITEID)


GO

-- ----------------------------
-- Procedure structure for GetCollUnitSummaryBySiteID
-- ----------------------------






CREATE PROCEDURE [GetCollUnitSummaryBySiteID](@SITEID int)
AS 
SELECT     NDB.CollectionUnits.CollectionUnitID, NDB.CollectionUnits.Handle, NDB.CollectionUnits.CollUnitName, NDB.CollectionTypes.CollType, 
                      CONVERT(nvarchar(10),NDB.CollectionUnits.CollDate,120) AS CollDate
FROM         NDB.CollectionUnits INNER JOIN
                      NDB.CollectionTypes ON NDB.CollectionUnits.CollTypeID = NDB.CollectionTypes.CollTypeID
WHERE     (NDB.CollectionUnits.SiteID = @SITEID)



GO

-- ----------------------------
-- Procedure structure for GetConstituentDatabaseNameByID
-- ----------------------------



CREATE PROCEDURE [GetConstituentDatabaseNameByID](@DATABASEID int)
AS 
SELECT      NDB.ConstituentDatabases.DatabaseName
FROM        NDB.ConstituentDatabases
WHERE       (NDB.ConstituentDatabases.DatabaseID = @DATABASEID)





GO

-- ----------------------------
-- Procedure structure for GetConstituentDatabases
-- ----------------------------


CREATE PROCEDURE [GetConstituentDatabases]
AS SELECT      NDB.ConstituentDatabases.DatabaseID, NDB.ConstituentDatabases.DatabaseName
FROM          NDB.ConstituentDatabases





GO

-- ----------------------------
-- Procedure structure for GetContactByContactName
-- ----------------------------





CREATE PROCEDURE [GetContactByContactName](@CONTACTNAME nvarchar(80))
AS SELECT      ContactID, AliasID, ContactName, ContactStatusID, FamilyName, LeadingInitials, GivenNames, Suffix, Title, Phone, Fax, Email, URL, Address, Notes
FROM          NDB.Contacts
WHERE      (ContactName = @CONTACTNAME)







GO

-- ----------------------------
-- Procedure structure for GetContactByFamilyName
-- ----------------------------

CREATE PROCEDURE [GetContactByFamilyName](@FAMILYNAME nvarchar(80))
AS 
SELECT      ContactID, AliasID, ContactName, ContactStatusID, FamilyName, LeadingInitials, GivenNames, Suffix, Title, Phone, Fax, Email, URL, Address, Notes
FROM          NDB.Contacts
WHERE      (FamilyName LIKE @FAMILYNAME)





GO

-- ----------------------------
-- Procedure structure for GetContactByFamilyNameAndInitials
-- ----------------------------


CREATE PROCEDURE [GetContactByFamilyNameAndInitials](@FAMILYNAME nvarchar(80),@INITIALS nvarchar(16))
AS SELECT     NDB.Contacts.* 
FROM          NDB.Contacts
WHERE      (FamilyName LIKE @FAMILYNAME) AND (LeadingInitials LIKE @INITIALS)






GO

-- ----------------------------
-- Procedure structure for GetContactByID
-- ----------------------------




CREATE PROCEDURE [GetContactByID](@CONTACTID int)
AS SELECT      ContactID, AliasID, ContactName, ContactStatusID, FamilyName, LeadingInitials, GivenNames, Suffix, Title, Phone, Fax, Email, URL, Address, Notes
FROM          NDB.Contacts
WHERE      (ContactID = @CONTACTID)






GO

-- ----------------------------
-- Procedure structure for GetContactDatasets
-- ----------------------------

CREATE PROCEDURE [GetContactDatasets](@CONTACTID int)
AS SELECT      NDB.DatasetPIs.ContactID, NDB.DatasetTypes.DatasetType, NDB.Sites.SiteName, TI.GeoPol1.GeoPolName1 AS GeoPol1, 
                        TI.GeoPol2.GeoPolName2 AS GeoPol2
FROM          NDB.Datasets INNER JOIN
                        NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID INNER JOIN
                        NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID INNER JOIN
                        NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                        NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                        TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID LEFT OUTER JOIN
                        TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID
WHERE      (NDB.DatasetPIs.ContactID = @CONTACTID)



GO

-- ----------------------------
-- Procedure structure for GetContactLinks
-- ----------------------------



CREATE PROCEDURE [GetContactLinks](@CONTACTID int)
AS 
DECLARE @LINKEDTABLES TABLE
(
  LinkID int not null identity(1,1) primary key,
  TableName nvarchar(255),
  Number int
)

DECLARE @Count int

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.Chronologies WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'Chronologies', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.Collectors WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'Collectors', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.ConstituentDatabases WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'ConstituentDatabases', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.DataProcessors WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'DataProcessors', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.DatasetPIs WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'DatasetPIs', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.PublicationAuthors WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'PublicationAuthors', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.SampleAnalysts WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'SampleAnalysts', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM NDB.SiteImages WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'SiteImages', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM TI.Stewards WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'Stewards', @Count)
END

SET @Count = (SELECT COUNT(ContactID) AS Count FROM TI.StewardUpdates WHERE (ContactID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'StewardUpdates', @Count)
END

SET @Count = (SELECT COUNT(ValidatorID) AS Count FROM NDB.Taxa WHERE (ValidatorID = @CONTACTID))
IF (@Count > 0)
BEGIN
  INSERT INTO @LINKEDTABLES(TableName, Number) VALUES(N'Taxa', @Count)
END


SELECT TableName, Number
FROM   @LINKEDTABLES



GO

-- ----------------------------
-- Procedure structure for GetContactPublications
-- ----------------------------

CREATE PROCEDURE [GetContactPublications](@CONTACTID int)
AS SELECT      NDB.PublicationAuthors.ContactID, NDB.Publications.Citation, NDB.Publications.Year, NDB.Publications.ArticleTitle, NDB.Publications.Journal, 
                        NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, NDB.Publications.CitationNumber, NDB.Publications.DOI, 
                        NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, 
                        NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, NDB.Publications.City, NDB.Publications.State, 
                        NDB.Publications.Country, NDB.Publications.OriginalLanguage
FROM          NDB.PublicationAuthors INNER JOIN
                        NDB.Publications ON NDB.PublicationAuthors.PublicationID = NDB.Publications.PublicationID
WHERE      (NDB.PublicationAuthors.ContactID = @CONTACTID)





GO

-- ----------------------------
-- Procedure structure for GetContactsTable
-- ----------------------------

CREATE PROCEDURE [GetContactsTable]
AS SELECT      *
FROM          NDB.Contacts



GO

-- ----------------------------
-- Procedure structure for GetContactStatusesTable
-- ----------------------------


CREATE PROCEDURE [GetContactStatusesTable]
AS 
SELECT      ContactStatusID, ContactStatus, StatusDescription
FROM          NDB.ContactStatuses




GO

-- ----------------------------
-- Procedure structure for GetContextDatasetTypeCount
-- ----------------------------


CREATE PROCEDURE [GetContextDatasetTypeCount](@DATASETTYPEID int, @VARIABLECONTEXTID int)
AS 
SELECT     COUNT(DatasetTypeID) AS Count
FROM         NDB.ContextsDatasetTypes
WHERE     (DatasetTypeID = @DATASETTYPEID) AND (VariableContextID = @VARIABLECONTEXTID)




GO

-- ----------------------------
-- Procedure structure for GetContextsDatasetTypesTable
-- ----------------------------


CREATE PROCEDURE [GetContextsDatasetTypesTable]
AS SELECT     NDB.ContextsDatasetTypes.DatasetTypeID, NDB.ContextsDatasetTypes.VariableContextID
FROM          NDB.ContextsDatasetTypes




GO

-- ----------------------------
-- Procedure structure for GetDataProcessor
-- ----------------------------






CREATE PROCEDURE [GetDataProcessor](@DATASETID int)
AS 
SELECT     NDB.Contacts.ContactID, NDB.Contacts.AliasID, NDB.Contacts.ContactName, NDB.Contacts.ContactStatusID, NDB.Contacts.FamilyName, 
                      NDB.Contacts.LeadingInitials, NDB.Contacts.GivenNames, NDB.Contacts.Suffix, NDB.Contacts.Title, NDB.Contacts.Phone, NDB.Contacts.Fax, NDB.Contacts.Email, 
                      NDB.Contacts.URL, NDB.Contacts.Address, NDB.Contacts.Notes
FROM         NDB.DataProcessors INNER JOIN
                      NDB.Contacts ON NDB.DataProcessors.ContactID = NDB.Contacts.ContactID
WHERE     (NDB.DataProcessors.DatasetID = @DATASETID)







GO

-- ----------------------------
-- Procedure structure for GetDatasetAuthorsDatasetTypes
-- ----------------------------




CREATE PROCEDURE [GetDatasetAuthorsDatasetTypes](@DATASETTYPEIDLIST nvarchar(MAX) = null)
AS 
IF @DATASETTYPEIDLIST IS NULL
  BEGIN
    SELECT NDB.Contacts.ContactID, NDB.Datasets.DatasetTypeID, NDB.Datasets.DatasetID, NDB.Contacts.ContactName
    FROM   NDB.Datasets INNER JOIN
               NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
               NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
               NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID INNER JOIN
               NDB.Contacts ON NDB.PublicationAuthors.ContactID = NDB.Contacts.ContactID
    GROUP BY NDB.Contacts.ContactID, NDB.Datasets.DatasetTypeID, NDB.Datasets.DatasetID, NDB.Contacts.ContactName
  END
ELSE
  BEGIN
    SELECT NDB.Contacts.ContactID, NDB.Datasets.DatasetTypeID, NDB.Datasets.DatasetID, NDB.Contacts.ContactName
    FROM   NDB.Datasets INNER JOIN
               NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
               NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
               NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID INNER JOIN
               NDB.Contacts ON NDB.PublicationAuthors.ContactID = NDB.Contacts.ContactID
    GROUP BY NDB.Contacts.ContactID, NDB.Datasets.DatasetTypeID, NDB.Datasets.DatasetID, NDB.Contacts.ContactName
    HAVING (NDB.Datasets.DatasetTypeID IN (SELECT Value FROM TI.func_NvarcharListToIN(@DATASETTYPEIDLIST,',')))
  END

GO

-- ----------------------------
-- Procedure structure for GetDatasetChrons
-- ----------------------------






CREATE PROCEDURE [GetDatasetChrons](@DATASETID int)
AS 
SELECT     TOP (100) PERCENT NDB.Chronologies.ChronologyID, NDB.Chronologies.ChronologyName, NDB.AgeTypes.ShortAgeType
FROM         NDB.Datasets INNER JOIN
                      NDB.Chronologies ON NDB.Datasets.CollectionUnitID = NDB.Chronologies.CollectionUnitID INNER JOIN
                      NDB.AgeTypes ON NDB.Chronologies.AgeTypeID = NDB.AgeTypes.AgeTypeID
WHERE     (NDB.Datasets.DatasetID = @DATASETID)
ORDER BY NDB.Chronologies.ChronologyID

 






GO

-- ----------------------------
-- Procedure structure for GetDatasetCitations
-- ----------------------------


CREATE PROCEDURE [GetDatasetCitations](@DATASETID int)
AS SELECT      NDB.DatasetPublications.PrimaryPub, NDB.Publications.PublicationID, NDB.Publications.Citation
FROM          NDB.DatasetPublications INNER JOIN
                        NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID
WHERE      (NDB.DatasetPublications.DatasetID = @DATASETID)




GO

-- ----------------------------
-- Procedure structure for GetDatasetCountByCollUnitType
-- ----------------------------



CREATE PROCEDURE [GetDatasetCountByCollUnitType](@COLLUNITTYPEID int)
AS 
SELECT     TOP (100) PERCENT NDB.DatasetTypes.DatasetType, COUNT(NDB.Datasets.DatasetID) AS Count
FROM         NDB.CollectionUnits INNER JOIN
                      NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                      NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
GROUP BY NDB.CollectionUnits.CollTypeID, NDB.DatasetTypes.DatasetType
HAVING      (NDB.CollectionUnits.CollTypeID = @COLLUNITTYPEID)
ORDER BY Count DESC





GO

-- ----------------------------
-- Procedure structure for GetDatasetData
-- ----------------------------



CREATE PROCEDURE [GetDatasetData](@DATASETID int)
AS 
SELECT     NDB.Data.DataID, NDB.Data.SampleID, NDB.Data.VariableID, NDB.Data.Value, NDB.SummaryDataTaphonomy.TaphonomicTypeID
FROM         NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID LEFT OUTER JOIN
                      NDB.SummaryDataTaphonomy ON NDB.Data.DataID = NDB.SummaryDataTaphonomy.DataID
WHERE     (NDB.Samples.DatasetID = @DATASETID)



GO

-- ----------------------------
-- Procedure structure for GetDatasetDatabase
-- ----------------------------




CREATE PROCEDURE [GetDatasetDatabase](@DATASETID int)
AS 
SELECT     NDB.ConstituentDatabases.DatabaseID, NDB.ConstituentDatabases.DatabaseName
FROM       NDB.Datasets INNER JOIN
                      NDB.DatasetSubmissions ON NDB.Datasets.DatasetID = NDB.DatasetSubmissions.DatasetID INNER JOIN
                      NDB.ConstituentDatabases ON NDB.DatasetSubmissions.DatabaseID = NDB.ConstituentDatabases.DatabaseID
WHERE     (NDB.Datasets.DatasetID = @DATASETID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetIDByCollUnitAndType
-- ----------------------------




CREATE PROCEDURE [GetDatasetIDByCollUnitAndType](@COLLUNITID int, @DATASETTYPEID int)
AS 
SELECT    DatasetID
FROM      NDB.Datasets
WHERE     (DatasetTypeID = @DATASETTYPEID) AND (CollectionUnitID = @COLLUNITID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetIDsByTaxonID
-- ----------------------------





CREATE PROCEDURE [GetDatasetIDsByTaxonID](@TAXONID int)
AS 
SELECT     NDB.Datasets.DatasetID
FROM         NDB.Datasets INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID
GROUP BY NDB.Datasets.DatasetID, NDB.Variables.TaxonID
HAVING      (NDB.Variables.TaxonID = @TAXONID)




GO

-- ----------------------------
-- Procedure structure for GetDatasetPIs
-- ----------------------------


CREATE PROCEDURE [GetDatasetPIs](@DATASETID int)
AS SELECT      NDB.DatasetPIs.PIOrder, NDB.Contacts.FamilyName, NDB.Contacts.LeadingInitials
FROM          NDB.DatasetPIs INNER JOIN
                        NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
WHERE      (NDB.DatasetPIs.DatasetID = @DATASETID)
ORDER BY NDB.DatasetPIs.PIOrder





GO

-- ----------------------------
-- Procedure structure for GetDatasetPIsDatasetTypes
-- ----------------------------



CREATE PROCEDURE [GetDatasetPIsDatasetTypes](@DATASETTYPEIDLIST nvarchar(MAX) = null)
AS 
IF @DATASETTYPEIDLIST IS NULL
  BEGIN
    SELECT NDB.DatasetPIs.ContactID, NDB.Datasets.DatasetTypeID, NDB.DatasetPIs.DatasetID, NDB.Contacts.ContactName
    FROM   NDB.DatasetPIs INNER JOIN
               NDB.Datasets ON NDB.DatasetPIs.DatasetID = NDB.Datasets.DatasetID INNER JOIN
               NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
  END
ELSE 
  BEGIN
    SELECT NDB.DatasetPIs.ContactID, NDB.Datasets.DatasetTypeID, NDB.DatasetPIs.DatasetID, NDB.Contacts.ContactName
    FROM   NDB.DatasetPIs INNER JOIN
               NDB.Datasets ON NDB.DatasetPIs.DatasetID = NDB.Datasets.DatasetID INNER JOIN
               NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
    wHERE  (NDB.Datasets.DatasetTypeID IN (SELECT Value FROM TI.func_NvarcharListToIN(@DATASETTYPEIDLIST,',')))
  END

GO

-- ----------------------------
-- Procedure structure for GetDatasetPublicationIDs
-- ----------------------------





CREATE PROCEDURE [GetDatasetPublicationIDs](@DATASETID int)
AS 
SELECT     PublicationID
FROM       NDB.DatasetPublications
WHERE     (DatasetID = @DATASETID)






GO

-- ----------------------------
-- Procedure structure for GetDatasetPublications
-- ----------------------------



CREATE PROCEDURE [GetDatasetPublications](@DATASETID int)
AS 
SELECT     NDB.Publications.PublicationID, NDB.Publications.PubTypeID, NDB.Publications.Year, NDB.Publications.Citation, NDB.Publications.ArticleTitle, 
                      NDB.Publications.Journal, NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, NDB.Publications.CitationNumber, NDB.Publications.DOI, 
                      NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, 
                      NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, NDB.Publications.City, NDB.Publications.State, NDB.Publications.Country, 
                      NDB.Publications.OriginalLanguage, NDB.Publications.Notes
FROM         NDB.DatasetPublications INNER JOIN
                      NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.DatasetPublications.DatasetID = @DATASETID)




GO

-- ----------------------------
-- Procedure structure for GetDatasetPublicationStatus
-- ----------------------------




CREATE PROCEDURE [GetDatasetPublicationStatus](@DATASETID int, @PUBLICATIONID int)
AS 
SELECT     PrimaryPub
FROM       NDB.DatasetPublications
WHERE      (DatasetID = @DATASETID) AND (PublicationID = @PUBLICATIONID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetRepository
-- ----------------------------



CREATE PROCEDURE [GetDatasetRepository](@DATASETID int)
AS 
SELECT     NDB.RepositoryInstitutions.RepositoryID, NDB.RepositoryInstitutions.Acronym, NDB.RepositoryInstitutions.Repository, NDB.RepositoryInstitutions.Notes
FROM         NDB.RepositorySpecimens INNER JOIN
                      NDB.RepositoryInstitutions ON NDB.RepositorySpecimens.RepositoryID = NDB.RepositoryInstitutions.RepositoryID
WHERE     (NDB.RepositorySpecimens.DatasetID = @DATASETID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetRepositorySpecimenNotes
-- ----------------------------




CREATE PROCEDURE [GetDatasetRepositorySpecimenNotes](@DATASETID int)
AS 
SELECT RepositoryID, Notes
FROM   NDB.RepositorySpecimens
WHERE  (DatasetID = @DATASETID)






GO

-- ----------------------------
-- Procedure structure for GetDatasetSampleAnalysts
-- ----------------------------




CREATE PROCEDURE [GetDatasetSampleAnalysts](@DATASETID int)
AS 
SELECT     NDB.SampleAnalysts.SampleID, NDB.SampleAnalysts.ContactID
FROM         NDB.Samples INNER JOIN
                      NDB.SampleAnalysts ON NDB.Samples.SampleID = NDB.SampleAnalysts.SampleID
WHERE     (NDB.Samples.DatasetID = @DATASETID)

 




GO

-- ----------------------------
-- Procedure structure for GetDatasetSampleDepAgents
-- ----------------------------






CREATE PROCEDURE [GetDatasetSampleDepAgents](@DATASETID int)
AS 
SELECT     NDB.Samples.SampleID, NDB.DepAgentTypes.DepAgent
FROM         NDB.DepAgents INNER JOIN
                      NDB.Samples ON NDB.DepAgents.AnalysisUnitID = NDB.Samples.AnalysisUnitID INNER JOIN
                      NDB.DepAgentTypes ON NDB.DepAgents.DepAgentID = NDB.DepAgentTypes.DepAgentID
WHERE     (NDB.Samples.DatasetID = @DATASETID)
 






GO

-- ----------------------------
-- Procedure structure for GetDatasetSampleIDs
-- ----------------------------




CREATE PROCEDURE [GetDatasetSampleIDs](@DATASETID int)
AS 
SELECT     TOP (100) PERCENT SampleID
FROM         NDB.Samples
WHERE     (DatasetID = @DATASETID)
ORDER BY SampleID





GO

-- ----------------------------
-- Procedure structure for GetDatasetSampleKeywords
-- ----------------------------





CREATE PROCEDURE [GetDatasetSampleKeywords](@DATASETID int)
AS 
SELECT     NDB.SampleKeywords.SampleID, NDB.Keywords.Keyword
FROM         NDB.Samples INNER JOIN
                      NDB.SampleKeywords ON NDB.Samples.SampleID = NDB.SampleKeywords.SampleID INNER JOIN
                      NDB.Keywords ON NDB.SampleKeywords.KeywordID = NDB.Keywords.KeywordID
WHERE     (NDB.Samples.DatasetID = @DATASETID)

 





GO

-- ----------------------------
-- Procedure structure for GetDatasetSamples
-- ----------------------------



CREATE PROCEDURE [GetDatasetSamples](@DATASETID int)
AS 
SELECT     NDB.Samples.SampleID, NDB.Samples.SampleName, CONVERT(nvarchar(10),NDB.Samples.SampleDate,120) AS SampleDate, 
                      CONVERT(nvarchar(10),NDB.Samples.AnalysisDate,120) AS AnalysisDate, NDB.Samples.LabNumber, 
                      NDB.Samples.PreparationMethod, NDB.Samples.Notes AS SampleNotes, NDB.AnalysisUnits.AnalysisUnitID, NDB.AnalysisUnits.AnalysisUnitName, 
					  NDB.AnalysisUnits.Depth, NDB.AnalysisUnits.Thickness, NDB.AnalysisUnits.FaciesID, NDB.FaciesTypes.Facies, NDB.AnalysisUnits.Mixed, 
					  NDB.AnalysisUnits.IGSN, NDB.AnalysisUnits.Notes AS AnalUnitNotes
FROM         NDB.Samples INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID LEFT OUTER JOIN
                      NDB.FaciesTypes ON NDB.AnalysisUnits.FaciesID = NDB.FaciesTypes.FaciesID
WHERE     (NDB.Samples.DatasetID = @DATASETID)

 



GO

-- ----------------------------
-- Procedure structure for GetDatasetsByContactID
-- ----------------------------



CREATE PROCEDURE [GetDatasetsByContactID](@CONTACTID int)
AS SELECT     TOP (100) PERCENT NDB.DatasetPIs.DatasetID, NDB.DatasetTypes.DatasetType, NDB.Sites.SiteID, NDB.Sites.SiteName, TI.GeoPol1.GeoPolName1, 
                      TI.GeoPol2.GeoPolName2, TI.GeoPol3.GeoPolName3
FROM         NDB.DatasetPIs INNER JOIN
                      NDB.Datasets ON NDB.DatasetPIs.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                      NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID LEFT OUTER JOIN
                      TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                      TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID LEFT OUTER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID
WHERE     (NDB.DatasetPIs.ContactID = @CONTACTID)
ORDER BY NDB.Sites.SiteName





GO

-- ----------------------------
-- Procedure structure for GetDatasetsByID
-- ----------------------------



CREATE PROCEDURE [GetDatasetsByID](@DATASETS nvarchar(MAX))
AS 
SELECT     NDB.Datasets.DatasetID, NDB.Datasets.CollectionUnitID, NDB.Datasets.DatasetTypeID, NDB.DatasetTypes.DatasetType, NDB.Datasets.DatasetName, 
                      NDB.Datasets.Notes
FROM         NDB.Datasets INNER JOIN
                      NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
WHERE (DatasetID IN (
		            SELECT Value
		            FROM TI.func_NvarcharListToIN(@DATASETS,'$')
                    ))


GO

-- ----------------------------
-- Procedure structure for GetDatasetsBySiteID
-- ----------------------------


CREATE PROCEDURE [GetDatasetsBySiteID](@SITEID int)
AS SELECT      NDB.CollectionUnits.CollectionUnitID, NDB.CollectionUnits.CollUnitName, NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType
FROM          NDB.Sites INNER JOIN
                        NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                        NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                        NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
WHERE      (NDB.Sites.SiteID = @SITEID)




GO

-- ----------------------------
-- Procedure structure for GetDatasetsBySiteName
-- ----------------------------


CREATE PROCEDURE [GetDatasetsBySiteName](@SITENAME nvarchar(128))
AS 
SELECT     NDB.Sites.SiteID, NDB.Sites.SiteName, NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType
FROM         NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                      NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                      NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
WHERE      (NDB.Sites.SiteName LIKE @SITENAME)





GO

-- ----------------------------
-- Procedure structure for GetDatasetsByTaxon
-- ----------------------------





CREATE PROCEDURE [GetDatasetsByTaxon](@TAXON nvarchar(80))
AS 
SELECT     NDB.Taxa.TaxonName, NDB.VariableElements.VariableElement, NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType, NDB.CollectionUnits.CollectionUnitID, 
                      NDB.Sites.SiteID, NDB.Sites.SiteName
FROM         NDB.Taxa INNER JOIN
                      NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID INNER JOIN
                      NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID INNER JOIN
                      NDB.Samples ON NDB.Data.SampleID = NDB.Samples.SampleID INNER JOIN
                      NDB.Datasets ON NDB.Samples.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID LEFT OUTER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
GROUP BY NDB.Taxa.TaxonName, NDB.VariableElements.VariableElement, NDB.Datasets.DatasetID, NDB.CollectionUnits.CollectionUnitID, NDB.Sites.SiteID, 
                      NDB.Sites.SiteName, NDB.DatasetTypes.DatasetType
HAVING      (NDB.Taxa.TaxonName = @TAXON)






GO

-- ----------------------------
-- Procedure structure for GetDatasetSpecimenDates
-- ----------------------------



CREATE PROCEDURE [GetDatasetSpecimenDates](@DATASETID int)
AS 
SELECT     TOP (100) PERCENT NDB.Specimens.SpecimenID, NDB.AnalysisUnits.AnalysisUnitName, NDB.AnalysisUnits.Depth, NDB.AnalysisUnits.Thickness, 
                      NDB.Taxa.TaxonName, NDB.VariableUnits.VariableUnits, NDB.VariableContexts.VariableContext, NDB.ElementTypes.ElementType, 
                      NDB.ElementSymmetries.Symmetry, NDB.ElementPortions.Portion, NDB.ElementMaturities.Maturity, NDB.SpecimenSexTypes.Sex, 
                      NDB.SpecimenDomesticStatusTypes.DomesticStatus, NDB.Specimens.NISP, NDB.Specimens.Preservative, NDB.RepositoryInstitutions.Repository, 
                      NDB.Specimens.SpecimenNr, NDB.Specimens.FieldNr, NDB.Specimens.ArctosNr, NDB.SpecimenGenBank.GenBankNr, NDB.Specimens.Notes, 
                      NDB.GeochronTypes.GeochronType, NDB.Geochronology.LabNumber, NDB.FractionDated.Fraction, NDB.Geochronology.Age, NDB.Geochronology.ErrorOlder, 
                      NDB.Geochronology.ErrorYounger, NDB.Geochronology.Infinite, NDB.SpecimenDatesCal.CalAgeOlder, NDB.SpecimenDatesCal.CalAgeYounger, 
                      NDB.CalibrationCurves.CalibrationCurve, NDB.CalibrationPrograms.CalibrationProgram, NDB.CalibrationPrograms.Version
FROM         NDB.SpecimenGenBank RIGHT OUTER JOIN
                      NDB.Datasets INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Specimens ON NDB.Data.DataID = NDB.Specimens.DataID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID ON NDB.SpecimenGenBank.SpecimenID = NDB.Specimens.SpecimenID LEFT OUTER JOIN
                      NDB.CalibrationCurves INNER JOIN
                      NDB.SpecimenDatesCal ON NDB.CalibrationCurves.CalibrationCurveID = NDB.SpecimenDatesCal.CalibrationCurveID INNER JOIN
                      NDB.CalibrationPrograms ON NDB.SpecimenDatesCal.CalibrationProgramID = NDB.CalibrationPrograms.CalibrationProgramID RIGHT OUTER JOIN
                      NDB.GeochronTypes INNER JOIN
                      NDB.Geochronology ON NDB.GeochronTypes.GeochronTypeID = NDB.Geochronology.GeochronTypeID INNER JOIN
                      NDB.FractionDated INNER JOIN
                      NDB.SpecimenDates ON NDB.FractionDated.FractionID = NDB.SpecimenDates.FractionID ON NDB.Geochronology.GeochronID = NDB.SpecimenDates.GeochronID ON 
                      NDB.SpecimenDatesCal.SpecimenDateID = NDB.SpecimenDates.SpecimenDateID ON 
                      NDB.Specimens.SpecimenID = NDB.SpecimenDates.SpecimenID LEFT OUTER JOIN
                      NDB.RepositoryInstitutions ON NDB.Specimens.RepositoryID = NDB.RepositoryInstitutions.RepositoryID LEFT OUTER JOIN
                      NDB.SpecimenDomesticStatusTypes ON NDB.Specimens.DomesticStatusID = NDB.SpecimenDomesticStatusTypes.DomesticStatusID LEFT OUTER JOIN
                      NDB.SpecimenSexTypes ON NDB.Specimens.SexID = NDB.SpecimenSexTypes.SexID LEFT OUTER JOIN
                      NDB.ElementSymmetries ON NDB.Specimens.SymmetryID = NDB.ElementSymmetries.SymmetryID LEFT OUTER JOIN
                      NDB.ElementMaturities ON NDB.Specimens.MaturityID = NDB.ElementMaturities.MaturityID LEFT OUTER JOIN
                      NDB.ElementPortions ON NDB.Specimens.PortionID = NDB.ElementPortions.PortionID LEFT OUTER JOIN
                      NDB.ElementTypes ON NDB.Specimens.ElementTypeID = NDB.ElementTypes.ElementTypeID LEFT OUTER JOIN
                      NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
WHERE     (NDB.Datasets.DatasetID = @DATASETID)
ORDER BY NDB.Specimens.SpecimenID






GO

-- ----------------------------
-- Procedure structure for GetDatasetSpecimenGenBankNrs
-- ----------------------------







CREATE PROCEDURE [GetDatasetSpecimenGenBankNrs](@DATASETID int)
AS
SELECT     NDB.Specimens.SpecimenID, NDB.SpecimenGenBank.GenBankNr
FROM         NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Specimens ON NDB.Data.DataID = NDB.Specimens.DataID INNER JOIN
                      NDB.SpecimenGenBank ON NDB.Specimens.SpecimenID = NDB.SpecimenGenBank.SpecimenID
WHERE     (NDB.Samples.DatasetID = @DATASETID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetSpecimens
-- ----------------------------






CREATE PROCEDURE [GetDatasetSpecimens](@DATASETID int)
AS
SELECT     NDB.Specimens.SpecimenID, NDB.Specimens.DataID, NDB.ElementTypes.ElementType, NDB.ElementSymmetries.Symmetry, NDB.ElementPortions.Portion, 
                      NDB.ElementMaturities.Maturity, NDB.SpecimenSexTypes.Sex, NDB.SpecimenDomesticStatusTypes.DomesticStatus, NDB.Specimens.Preservative, 
                      NDB.Specimens.NISP, NDB.RepositoryInstitutions.Repository, NDB.Specimens.SpecimenNr, NDB.Specimens.FieldNr, NDB.Specimens.ArctosNr, 
                      NDB.Specimens.Notes, NDB.Taxa.TaxonName, NDB.TaxaGroupTypes.TaxaGroup
FROM         NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Specimens ON NDB.Data.DataID = NDB.Specimens.DataID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.TaxaGroupTypes ON NDB.Taxa.TaxaGroupID = NDB.TaxaGroupTypes.TaxaGroupID LEFT OUTER JOIN
                      NDB.RepositoryInstitutions ON NDB.Specimens.RepositoryID = NDB.RepositoryInstitutions.RepositoryID LEFT OUTER JOIN
                      NDB.SpecimenDomesticStatusTypes ON NDB.Specimens.DomesticStatusID = NDB.SpecimenDomesticStatusTypes.DomesticStatusID LEFT OUTER JOIN
                      NDB.SpecimenSexTypes ON NDB.Specimens.SexID = NDB.SpecimenSexTypes.SexID LEFT OUTER JOIN
                      NDB.ElementMaturities ON NDB.Specimens.MaturityID = NDB.ElementMaturities.MaturityID LEFT OUTER JOIN
                      NDB.ElementSymmetries ON NDB.Specimens.SymmetryID = NDB.ElementSymmetries.SymmetryID LEFT OUTER JOIN
                      NDB.ElementTypes ON NDB.Specimens.ElementTypeID = NDB.ElementTypes.ElementTypeID LEFT OUTER JOIN
                      NDB.ElementPortions ON NDB.Specimens.PortionID = NDB.ElementPortions.PortionID
WHERE     (NDB.Samples.DatasetID = @DATASETID)




GO

-- ----------------------------
-- Procedure structure for GetDatasetSpecimenTaphonomy
-- ----------------------------








CREATE PROCEDURE [GetDatasetSpecimenTaphonomy](@DATASETID int)
AS
SELECT    NDB.Specimens.SpecimenID, NDB.TaphonomicSystems.TaphonomicSystem, NDB.TaphonomicTypes.TaphonomicType
FROM         NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Specimens ON NDB.Data.DataID = NDB.Specimens.DataID INNER JOIN
                      NDB.SpecimenTaphonomy ON NDB.Specimens.SpecimenID = NDB.SpecimenTaphonomy.SpecimenID INNER JOIN
                      NDB.TaphonomicTypes ON NDB.SpecimenTaphonomy.TaphonomicTypeID = NDB.TaphonomicTypes.TaphonomicTypeID INNER JOIN
                      NDB.TaphonomicSystems ON NDB.TaphonomicTypes.TaphonomicSystemID = NDB.TaphonomicSystems.TaphonomicSystemID
WHERE     (NDB.Samples.DatasetID = @DATASETID)





GO

-- ----------------------------
-- Procedure structure for GetDatasetSynonyms
-- ----------------------------


CREATE PROCEDURE [GetDatasetSynonyms](@DATASETID int)
AS 
SELECT     TOP (100) PERCENT NDB.Synonymy.SynonymyID, NDB.Taxa.TaxonName AS ValidName, Taxa_1.TaxonName AS RefName, NDB.Synonymy.FromContributor, 
                      NDB.Synonymy.PublicationID, NDB.Synonymy.Notes
FROM         NDB.Synonymy INNER JOIN
                      NDB.Taxa ON NDB.Synonymy.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.Taxa AS Taxa_1 ON NDB.Synonymy.RefTaxonID = Taxa_1.TaxonID
WHERE     (NDB.Synonymy.DatasetID = @DATASETID)
ORDER BY NDB.Synonymy.SynonymyID



GO

-- ----------------------------
-- Procedure structure for GetDatasetTaxonNotes
-- ----------------------------



CREATE PROCEDURE [GetDatasetTaxonNotes](@DATASETID int)
AS 
SELECT     NDB.DatasetTaxonNotes.TaxonID, NDB.Taxa.TaxonName, NDB.DatasetTaxonNotes.Notes
FROM         NDB.DatasetTaxonNotes INNER JOIN
                      NDB.Taxa ON NDB.DatasetTaxonNotes.TaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.DatasetTaxonNotes.DatasetID = @DATASETID)

GO

-- ----------------------------
-- Procedure structure for GetDatasetTaxonNotesByTaxonID
-- ----------------------------




CREATE PROCEDURE [GetDatasetTaxonNotesByTaxonID](@DATASETID int, @TAXONID int)
AS 
SELECT     NDB.DatasetTaxonNotes.TaxonID, NDB.Taxa.TaxonName, NDB.DatasetTaxonNotes.Notes
FROM         NDB.DatasetTaxonNotes INNER JOIN
                      NDB.Taxa ON NDB.DatasetTaxonNotes.TaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.DatasetTaxonNotes.DatasetID = @DATASETID AND NDB.DatasetTaxonNotes.TaxonID = @TAXONID)


GO

-- ----------------------------
-- Procedure structure for GetDatasetTopTaxa
-- ----------------------------


CREATE PROCEDURE [GetDatasetTopTaxa](@DATASETID int, @TOPX int, @GROUPTAXA nvarchar(MAX) = null, @ALWAYSSHOWTAXA nvarchar(MAX) = null)
AS 
/*
@GROUPTAXA are taxa to be lumped, for example: N'Picea$Pinus$Fraxinus'
@ALWAYSSHOWTAXA are taxa to always show, for example: N'Fagus$Amaranthaceae'
*/

DECLARE @GROUPEDTAXA TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80)
)

IF @GROUPTAXA IS NOT NULL
BEGIN
  INSERT INTO @GROUPEDTAXA (TaxonName)
  SELECT TaxonName
  FROM NDB.Taxa
  WHERE (TaxonName IN (
		              SELECT Value
		              FROM TI.func_NvarcharListToIN(@GROUPTAXA,'$')
                      ))
END

DECLARE @ALWAYSSHOW TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80)
)

IF @ALWAYSSHOWTAXA IS NOT NULL
BEGIN
  INSERT INTO @ALWAYSSHOW (TaxonName)
  SELECT TaxonName
  FROM NDB.Taxa
  WHERE (TaxonName IN (
		              SELECT Value
		              FROM TI.func_NvarcharListToIN(@ALWAYSSHOWTAXA,'$')
                      ))
END

DECLARE @POLLENSUMS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  PollenSum float,
  EcolGroupID nvarchar(4)
)

DECLARE @NEWPOLLENSUMS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  PollenSum float,
  EcolGroupID nvarchar(4)
)

DECLARE @TAXALIST TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4)
)

DECLARE @TOPTAXA TABLE
(
  ID int NOT NULL primary key,
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4)
)

DECLARE @THEREST TABLE
(
  ID int NOT NULL primary key,
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4)
)

DECLARE @LUMPTAXA TABLE  
(
  ID int NOT NULL primary key identity(1,1),
  TaxonID int,
  TaxonName nvarchar(80),
  Author nvarchar(128),
  HigherTaxonID int,
  level int
)

DECLARE @CURRENTID int
DECLARE @MAXGROUPID int
DECLARE @LUMPSUM float
DECLARE @TAXONNAME nvarchar(80)
DECLARE @COUNT int
DECLARE @COUNT1 int
DECLARE @ITR int
DECLARE @MAXID int 
DECLARE @TAXONID int
DECLARE @ECOLGROUPID nvarchar(4)
DECLARE @LUMPEDTAXON nvarchar(80)
DECLARE @NGROUPED int
DECLARE @NALWAYS int
DECLARE @TOPTAXAMAXID int
DECLARE @TRSH float = 0
DECLARE @UPHE float = 0
DECLARE @VACR float = 0

SELECT     TOP (100) PERCENT NDB.Taxa.TaxonName, SUM(NDB.Data.Value) AS PollenSum, NDB.EcolGroups.EcolGroupID
FROM       NDB.Samples INNER JOIN
             NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
             NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
             NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
WHERE     (NDB.Variables.VariableElementID = 141) AND (NDB.Samples.DatasetID = @DATASETID) OR
             (NDB.Variables.VariableElementID = 166) AND (NDB.Samples.DatasetID = @DATASETID)
GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.Taxa.TaxonName, NDB.Variables.VariableUnitsID
HAVING    (NDB.EcolGroups.EcolSetID = 1) AND (NDB.EcolGroups.EcolGroupID = N'TRSH' OR
             NDB.EcolGroups.EcolGroupID = N'UPHE') AND (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28) OR
             (NDB.EcolGroups.EcolSetID = 1) AND (NDB.EcolGroups.EcolGroupID = N'VACR') AND (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28)
ORDER BY PollenSum DESC

INSERT INTO @TAXALIST (TaxonName, EcolGroupID)
SELECT TOP (100) PERCENT TaxonName, EcolGroupID
FROM @POLLENSUMS

SET @NGROUPED = (SELECT COUNT(*) AS Count FROM @GROUPEDTAXA)

IF (@NGROUPED > 0)
BEGIN
  SET @CURRENTID = (SELECT MIN(ID) FROM @GROUPEDTAXA)
  SET @MAXGROUPID = (SELECT MAX(ID) FROM @GROUPEDTAXA)
  WHILE(@CURRENTID <= @MAXGROUPID)
    BEGIN
	  SET @LUMPEDTAXON = (SELECT TaxonName FROM @GROUPEDTAXA WHERE (ID = @CURRENTID))
	  
	  INSERT INTO @LUMPTAXA (TaxonID, TaxonName, Author, HigherTaxonID, level)
      EXEC TI.GetChildTaxa @LUMPEDTAXON

	  SET @LUMPSUM = 0
      SET @ITR = (SELECT MIN(ID) FROM @POLLENSUMS)
      SET @MAXID = (SELECT MAX(ID) FROM @POLLENSUMS)
      
	  WHILE (@ITR <= @MAXID)
        BEGIN
		  SET @TAXONNAME = (SELECT TaxonName FROM @POLLENSUMS WHERE ID = @ITR)
          SET @COUNT = (SELECT COUNT(TaxonName) FROM @LUMPTAXA WHERE (TaxonName = @TAXONNAME))
          IF (@COUNT > 0) 
            BEGIN
			  SET @LUMPSUM = @LUMPSUM + (SELECT PollenSum FROM @POLLENSUMS WHERE ID = @ITR)
	          DELETE FROM @POLLENSUMS WHERE (ID = @ITR)  
	        END
          SET @ITR = @ITR + 1        
        END
      	  	  
      IF (@LUMPSUM > 0)
        BEGIN
          SET @TAXONID = (SELECT TaxonID FROM @LUMPTAXA WHERE TaxonName = @LUMPEDTAXON)
	      SET @ECOLGROUPID = (SELECT EcolGroupID FROM NDB.EcolGroups WHERE (NDB.EcolGroups.TaxonID = @TAXONID) AND (NDB.EcolGroups.EcolSetID = 1))
          INSERT INTO @POLLENSUMS (TaxonName, PollenSum, EcolGroupID) VALUES (@LUMPEDTAXON, @LUMPSUM, @ECOLGROUPID)  
        END

      DELETE FROM @LUMPTAXA WHERE (ID <= @MAXID)
      SET @CURRENTID = @CURRENTID + 1 
    END
END

INSERT INTO @NEWPOLLENSUMS (TaxonName, PollenSum, EcolGroupID)
SELECT TOP (100) PERCENT TaxonName, PollenSum, EcolGroupID
FROM @POLLENSUMS  
ORDER BY PollenSum DESC

INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID)
SELECT     ID, TaxonName, EcolGroupID
FROM @NEWPOLLENSUMS
WHERE (ID <= @TOPX)

INSERT INTO @THEREST (ID, TaxonName, EcolGroupID)
SELECT     ID, TaxonName, EcolGroupID
FROM @NEWPOLLENSUMS
WHERE (ID > @TOPX)

SET @TOPTAXAMAXID = (SELECT MAX(ID) FROM @TOPTAXA)

SET @NALWAYS = (SELECT COUNT(*) AS Count FROM @ALWAYSSHOW)
IF (@NALWAYS > 0)
  BEGIN
    SET @ITR = (SELECT MIN(ID) FROM @ALWAYSSHOW)
    SET @MAXID = (SELECT MAX(ID) FROM @ALWAYSSHOW)
	WHILE (@ITR <= @MAXID)
	  BEGIN
	    SET @TAXONNAME = (SELECT TaxonName FROM @ALWAYSSHOW WHERE (ID = @ITR))
        SET @COUNT = (SELECT COUNT(TaxonName) FROM @TAXALIST WHERE (TaxonName = @TAXONNAME))
		IF (@COUNT > 0)
		  BEGIN
		    SET @COUNT1 = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME)) 
			IF (@COUNT1 = 0)
			  BEGIN
			    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
				SET @ECOLGROUPID = (SELECT EcolGroupID FROM @TAXALIST WHERE (TaxonName = @TAXONNAME))
	            INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, @TAXONNAME, @ECOLGROUPID)  
			  END   
		  END
		SET @ITR = @ITR + 1  
	  END
  END

SET @ITR = (SELECT MIN(ID) FROM @THEREST)
SET @MAXID = (SELECT MAX(ID) FROM @THEREST)
WHILE (@ITR <= @MAXID)
  BEGIN
	SET @ECOLGROUPID = (SELECT EcolGroupID FROM @THEREST WHERE (ID = @ITR))	  
    IF (@ECOLGROUPID = N'TRSH')
	  BEGIN
	    SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		IF (@COUNT = 0)
		  SET @TRSH = @TRSH + (SELECT PollenSum FROM @POLLENSUMS WHERE (TaxonName = @TAXONNAME))  
	  END
	ELSE IF (@ECOLGROUPID = N'UPHE')
	  BEGIN
	    SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		IF (@COUNT = 0)
		  SET @UPHE = @UPHE + (SELECT PollenSum FROM @POLLENSUMS WHERE (TaxonName = @TAXONNAME))  
	  END
    ELSE IF (@ECOLGROUPID = N'VACR')
	  BEGIN
	    SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		IF (@COUNT = 0)
		  SET @VACR = @VACR + (SELECT PollenSum FROM @POLLENSUMS WHERE (TaxonName = @TAXONNAME))  
	  END
	SET @ITR = @ITR + 1        
  END
  

IF (@TRSH > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Trees and Shrubs', N'TRSH')
  END
IF (@UPHE > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Upland Herbs', N'UPHE')
  END
IF (@TRSH > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Terrestrial Vascular Cryptogams', N'VACR')
  END

SELECT ID, TaxonName, EcolGroupID
FROM @TOPTAXA
ORDER BY ID

GO

-- ----------------------------
-- Procedure structure for GetDatasetTopTaxaData
-- ----------------------------


CREATE PROCEDURE [GetDatasetTopTaxaData](@DATASETID int, @TOPX int = 15, @GROUPTAXA nvarchar(MAX) = null, @ALWAYSSHOWTAXA nvarchar(MAX) = null
)
AS 

-- Coded by Eric C. Grimm
-- Last Modification 15 April 2017
-- @GROUPTAXA: taxa to be lumped, for example: N'Picea$Pinus$Fraxinus'
-- @ALWAYSSHOWTAXA: taxa to always show, for example: N'Fagus$Larix' (but will not be listed if taxon does not occur in dataset at all)

DECLARE @DATASETTYPEID int = (SELECT DatasetTypeID FROM NDB.Datasets WHERE (DatasetID = @DATASETID))

IF (@DATASETTYPEID NOT IN(2,3,9,11))  -- LOI, pollen, ostracodes, diatoms
  BEGIN
    DECLARE @DATASETTYPE nvarchar(64) = (SELECT NDB.DatasetTypes.DatasetType
                                         FROM NDB.Datasets INNER JOIN
                                           NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
                                         WHERE (NDB.Datasets.DatasetID = @DATASETID))
	-- DECLARE @ERROR TABLE (Error nvarchar(255))
	-- INSERT INTO @ERROR (Error) VALUES (@DATASETTYPE + ' dataset type not supported')
	-- SELECT Error FROM @ERROR
	DECLARE @ERRMSG nvarchar(255) = @DATASETTYPE + ' dataset type not supported'
	RAISERROR(@ERRMSG, 16, 1);
    RETURN
  END


DECLARE @GROUPEDTAXA TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80)
)

IF @GROUPTAXA IS NOT NULL
BEGIN
  INSERT INTO @GROUPEDTAXA (TaxonName)
  SELECT TaxonName
  FROM NDB.Taxa
  WHERE (TaxonName IN (
		              SELECT Value
		              FROM TI.func_NvarcharListToIN(@GROUPTAXA,'$')
                      ))
END

DECLARE @ALWAYSSHOW TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80)
)

IF @ALWAYSSHOWTAXA IS NOT NULL
BEGIN
  INSERT INTO @ALWAYSSHOW (TaxonName)
  SELECT TaxonName
  FROM NDB.Taxa
  WHERE (TaxonName IN (
		              SELECT Value
		              FROM TI.func_NvarcharListToIN(@ALWAYSSHOWTAXA,'$')
                      ))
END

DECLARE @SUMS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  PollenSum float,
  EcolGroupID nvarchar(4),
  Element nvarchar(255),
  Units nvarchar(64)
)

DECLARE @NEWSUMS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  PollenSum float,
  EcolGroupID nvarchar(4),
  Element nvarchar(255),
  Units nvarchar(64)
)

DECLARE @TAXALIST TABLE
(
  ID int NOT NULL primary key identity(1,1),
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4),
  Element nvarchar(255),
  Units nvarchar(64)
)

DECLARE @TOPTAXA TABLE
(
  ID int NOT NULL primary key,
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4),
  Element nvarchar(255),
  Units nvarchar(64)
)

DECLARE @THEREST TABLE
(
  ID int NOT NULL primary key,
  TaxonName nvarchar(80),
  EcolGroupID nvarchar(4)
)

DECLARE @LUMPTAXA TABLE  
(
  ID int NOT NULL primary key identity(1,1),
  TaxonID int,
  TaxonName nvarchar(80),
  Author nvarchar(128),
  HigherTaxonID int,
  level int
)

DECLARE @SUMMEDTAXA TABLE
(
  ID int NOT NULL primary key identity(1,1),
  SumName nvarchar(80),
  TaxonName nvarchar(80)
)

DECLARE @ALLSUMS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  SumName nvarchar(80),
  SumStr nvarchar(MAX)
)

DECLARE @SUMVALUES TABLE
(
  ID int NOT NULL primary key identity(1,1),
  SampleID int,
  SumName nvarchar(80),
  Value float
)

DECLARE @DATA TABLE  
(
  ID int NOT NULL primary key identity(1,1),
  SampleID int,
  TaxonName nvarchar(80),
  Units nvarchar(64),
  EcolGroupID nvarchar(4), 
  Value float, 
  Depth float,
  ChronologyID int,
  ChronologyName nvarchar(80),
  Age float
)

DECLARE @TEMPDATA TABLE  
(
  ID int NOT NULL primary key identity(1,1),
  SampleID int,
  TaxonName nvarchar(80),
  Units nvarchar(64),
  EcolGroupID nvarchar(4), 
  Value float default 0, 
  Depth float,
  ChronologyID int,
  ChronologyName nvarchar(80),
  Age float
)

DECLARE @CHRONS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  ChronologyID int,
  NAges int
)

DECLARE @DEPTHS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  SampleID int,
  Depth float
)

DECLARE @TAXADEPTHS TABLE
(
  ID int NOT NULL primary key identity(1,1),
  Depth float
)

DECLARE @CURRENTID int
DECLARE @MAXGROUPID int
DECLARE @LUMPSUM float
DECLARE @TAXONNAME nvarchar(80)
DECLARE @COUNT int
DECLARE @COUNT1 int
DECLARE @ITR int
DECLARE @ITR1 int
DECLARE @MINID int
DECLARE @MAXID int
DECLARE @MAXID1 int
DECLARE @TAXONID int
DECLARE @ECOLGROUPID nvarchar(4)
DECLARE @LUMPEDTAXON nvarchar(80)
DECLARE @NGROUPED int
DECLARE @NALWAYS int
DECLARE @TOPTAXAMAXID int
DECLARE @TRSH float = 0
DECLARE @PALM float = 0
DECLARE @MANG float = 0
DECLARE @SUCC float = 0
DECLARE @UPHE float = 0
DECLARE @VACR float = 0
DECLARE @DIAT float = 0 -- new
DECLARE @BNTH float = 0 -- new
DECLARE @COSM float = 0 -- new
DECLARE @INTR float = 0 -- new
DECLARE @MARI float = 0 -- new
DECLARE @NEKT float = 0 -- new
DECLARE @OCOD float = 0 -- new
DECLARE @NSAMPLES int
DECLARE @NDEPTHS int
DECLARE @DATAMINID int
DECLARE @NAGES int
DECLARE @CHRONID int
DECLARE @CHRONNAME nvarchar(80)
DECLARE @MAXDEPTHID int 
DECLARE @SQL nvarchar(MAX)
DECLARE @SQLTEXT nvarchar(MAX)

IF (@DATASETTYPEID = 3)  -- pollen
  BEGIN
    INSERT INTO @SUMS (TaxonName, PollenSum, EcolGroupID)
    
	SELECT TOP (100) PERCENT NDB.Taxa.TaxonName, SUM(NDB.Data.Value) AS PollenSum, NDB.EcolGroups.EcolGroupID
    FROM   NDB.Samples INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
    WHERE    ((NDB.Variables.VariableElementID = 141) AND (NDB.Variables.VariableContextID IS NULL) AND (NDB.Samples.DatasetID = @DATASETID)) OR
             ((NDB.Variables.VariableElementID = 166) AND (NDB.Variables.VariableContextID IS NULL) AND (NDB.Samples.DatasetID = @DATASETID))
    GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.Taxa.TaxonName, NDB.Variables.VariableUnitsID
    HAVING   (NDB.EcolGroups.EcolSetID = 1) AND (NDB.EcolGroups.EcolGroupID IN (N'TRSH', N'UPHE', N'PALM', N'MANG', N'SUCC')) AND (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28) OR
             (NDB.EcolGroups.EcolSetID = 1) AND (NDB.EcolGroups.EcolGroupID = N'VACR') AND (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28)
    ORDER BY PollenSum DESC
  END
ELSE IF (@DATASETTYPEID = 9)  -- ostracodes
  BEGIN
    INSERT INTO @SUMS (TaxonName, PollenSum, EcolGroupID)
	SELECT TOP (100) PERCENT NDB.Taxa.TaxonName, SUM(NDB.Data.Value) AS PollenSum, NDB.EcolGroups.EcolGroupID
    FROM   NDB.Samples INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
    WHERE    (NDB.Samples.DatasetID = @DATASETID)
    GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.Taxa.TaxonName, NDB.Variables.VariableUnitsID
    HAVING   (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28) AND (NDB.EcolGroups.EcolSetID = 4)
    ORDER BY PollenSum DESC
  END
ELSE IF (@DATASETTYPEID = 11)  -- diatoms
  BEGIN
    INSERT INTO @SUMS (TaxonName, PollenSum, EcolGroupID)
	SELECT TOP (100) PERCENT NDB.Taxa.TaxonName, SUM(NDB.Data.Value) AS PollenSum, NDB.EcolGroups.EcolGroupID
    FROM   NDB.Samples INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
    WHERE    (NDB.Samples.DatasetID = @DATASETID)
    GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.Taxa.TaxonName, NDB.Variables.VariableUnitsID
    HAVING   (NDB.Variables.VariableUnitsID = 19 OR
             NDB.Variables.VariableUnitsID = 28) AND (NDB.EcolGroups.EcolSetID = 8)
    ORDER BY PollenSum DESC
  END
ELSE IF (@DATASETTYPEID = 2)  -- LOI
  BEGIN
    INSERT INTO @SUMS (TaxonName, PollenSum, EcolGroupID, Element, Units)
	SELECT TOP (100) PERCENT NDB.Taxa.TaxonName, SUM(NDB.Data.Value) AS PollenSum, NDB.EcolGroups.EcolGroupID, 
	       NDB.VariableElements.VariableElement, NDB.VariableUnits.VariableUnits
    FROM   NDB.Samples INNER JOIN
             NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
             NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
             NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
    WHERE    (NDB.Samples.DatasetID = @DATASETID)
    GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.Variables.VariableUnitsID, 
                      NDB.VariableElements.VariableElement, NDB.Taxa.TaxonName, NDB.VariableUnits.VariableUnits
    ORDER BY PollenSum DESC
  END

  
INSERT INTO @TAXALIST (TaxonName, EcolGroupID, Element, Units)
SELECT TOP (100) PERCENT TaxonName, EcolGroupID, Element, Units
FROM @SUMS

SET @NGROUPED = (SELECT COUNT(*) AS Count FROM @GROUPEDTAXA)

IF (@NGROUPED > 0)
BEGIN
  SET @CURRENTID = (SELECT MIN(ID) FROM @GROUPEDTAXA)
  SET @MAXGROUPID = (SELECT MAX(ID) FROM @GROUPEDTAXA)
  WHILE(@CURRENTID <= @MAXGROUPID)
    BEGIN
	  SET @LUMPEDTAXON = (SELECT TaxonName FROM @GROUPEDTAXA WHERE (ID = @CURRENTID))
	  
	  INSERT INTO @LUMPTAXA (TaxonID, TaxonName, Author, HigherTaxonID, level)
      EXEC TI.GetChildTaxa @LUMPEDTAXON

	  SET @LUMPSUM = 0
      SET @ITR = (SELECT MIN(ID) FROM @SUMS)
      SET @MAXID = (SELECT MAX(ID) FROM @SUMS)
      
	  WHILE (@ITR <= @MAXID)
        BEGIN
		  SET @TAXONNAME = (SELECT TaxonName FROM @SUMS WHERE ID = @ITR)
          SET @COUNT = (SELECT COUNT(TaxonName) FROM @LUMPTAXA WHERE (TaxonName = @TAXONNAME))
          IF (@COUNT > 0) 
            BEGIN
			  SET @LUMPSUM = @LUMPSUM + (SELECT PollenSum FROM @SUMS WHERE ID = @ITR)
	          DELETE FROM @SUMS WHERE (ID = @ITR) 
			  INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (@LUMPEDTAXON, @TAXONNAME) 
	        END
          SET @ITR = @ITR + 1        
        END
      	  	  
      IF (@LUMPSUM > 0)
        BEGIN
          SET @TAXONID = (SELECT TaxonID FROM @LUMPTAXA WHERE TaxonName = @LUMPEDTAXON)
	      SET @ECOLGROUPID = (SELECT EcolGroupID FROM NDB.EcolGroups WHERE (NDB.EcolGroups.TaxonID = @TAXONID) AND (NDB.EcolGroups.EcolSetID = 1))
          INSERT INTO @SUMS (TaxonName, PollenSum, EcolGroupID) VALUES (@LUMPEDTAXON, @LUMPSUM, @ECOLGROUPID)  
        END

      DELETE FROM @LUMPTAXA WHERE (ID <= @MAXID)
      SET @CURRENTID = @CURRENTID + 1 
    END
END

INSERT INTO @NEWSUMS (TaxonName, PollenSum, EcolGroupID, Element, Units)
SELECT TOP (100) PERCENT TaxonName, PollenSum, EcolGroupID, Element, Units
FROM @SUMS  
ORDER BY PollenSum DESC

INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID, Element, Units)
SELECT     ID, TaxonName, EcolGroupID, Element, Units
FROM @NEWSUMS
WHERE (ID <= @TOPX)

INSERT INTO @THEREST (ID, TaxonName, EcolGroupID)
SELECT     ID, TaxonName, EcolGroupID
FROM @NEWSUMS
WHERE (ID > @TOPX)

SET @TOPTAXAMAXID = (SELECT MAX(ID) FROM @TOPTAXA)

SET @NALWAYS = (SELECT COUNT(*) AS Count FROM @ALWAYSSHOW)
IF (@NALWAYS > 0)
  BEGIN
    SET @ITR = (SELECT MIN(ID) FROM @ALWAYSSHOW)
    SET @MAXID = (SELECT MAX(ID) FROM @ALWAYSSHOW)
	WHILE (@ITR <= @MAXID)
	  BEGIN
	    SET @TAXONNAME = (SELECT TaxonName FROM @ALWAYSSHOW WHERE (ID = @ITR))
        SET @COUNT = (SELECT COUNT(TaxonName) FROM @TAXALIST WHERE (TaxonName = @TAXONNAME))
		IF (@COUNT > 0)
		  BEGIN
		    SET @COUNT1 = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME)) 
			IF (@COUNT1 = 0)
			  BEGIN
			    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
				SET @ECOLGROUPID = (SELECT EcolGroupID FROM @TAXALIST WHERE (TaxonName = @TAXONNAME))
	            INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, @TAXONNAME, @ECOLGROUPID)  
			  END   
		  END
		SET @ITR = @ITR + 1  
	  END
  END


-- sum up the 'other' types
SET @ITR = (SELECT MIN(ID) FROM @THEREST)
SET @MAXID = (SELECT MAX(ID) FROM @THEREST)
WHILE (@ITR <= @MAXID)
  BEGIN
	IF (@DATASETTYPEID = 3) -- pollen
	  BEGIN
	    SET @ECOLGROUPID = (SELECT EcolGroupID FROM @THEREST WHERE (ID = @ITR))	  
        IF (@ECOLGROUPID = N'TRSH')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @TRSH = @TRSH + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Trees and Shrubs', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'PALM')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @PALM = @PALM + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Palms', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'MANG')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @MANG = @MANG + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Mangroves', @TAXONNAME) 
              END
	      END 
        IF (@ECOLGROUPID = N'SUCC')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @SUCC = @SUCC + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Succulents', @TAXONNAME) 
              END
	      END
	    ELSE IF (@ECOLGROUPID = N'UPHE')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @UPHE = @UPHE + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
		        INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Upland Herbs', @TAXONNAME) 
		      END
	      END
        ELSE IF (@ECOLGROUPID = N'VACR')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0)
		      BEGIN
		        SET @VACR = @VACR + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))
		        INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Terrestrial Vascular Cryptogams', @TAXONNAME) 
		      END
	      END
	  END
    ELSE IF (@DATASETTYPEID = 9)  -- ostracodes
	  BEGIN
	    SET @ECOLGROUPID = (SELECT EcolGroupID FROM @THEREST WHERE (ID = @ITR))	  
        IF (@ECOLGROUPID = N'BNTH')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @BNTH = @BNTH + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Benthic', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'COSM')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @COSM = @COSM + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Cosmopolitan', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'INTR')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @INTR = @INTR + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Interstitial', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'MARI')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @MARI = @MARI + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Marine', @TAXONNAME) 
              END
	      END
        IF (@ECOLGROUPID = N'NEKT')
	      BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @NEKT = @NEKT + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Nektonic', @TAXONNAME) 
              END
	      END
        BEGIN
	      SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0) 
		      BEGIN
		        SET @OCOD = @OCOD + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))  
			    INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Undifferentiated', @TAXONNAME) 
              END
	      END
	  END
	ELSE IF (@DATASETTYPEID = 11)  -- diatoms
	  BEGIN
	    SET @ECOLGROUPID = (SELECT EcolGroupID FROM @THEREST WHERE (ID = @ITR))	  
		IF (@ECOLGROUPID = N'DIAT')
		  BEGIN
		    SET @TAXONNAME = (SELECT TaxonName FROM @THEREST WHERE (ID = @ITR))	 
		    SET @COUNT = (SELECT COUNT(TaxonName) FROM @TOPTAXA WHERE (TaxonName = @TAXONNAME))
		    IF (@COUNT = 0)
		      BEGIN
		        SET @DIAT = @DIAT + (SELECT PollenSum FROM @SUMS WHERE (TaxonName = @TAXONNAME))
		        INSERT INTO @SUMMEDTAXA (SumName, TaxonName) VALUES (N'Other Diatoms', @TAXONNAME) 
		      END
		  END
	  END
	SET @ITR = @ITR + 1        
  END

-- SELECT @DIAT AS 'DIAT'

IF (@TRSH > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Trees and Shrubs', N'TRSH')
  END
IF (@PALM > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Palms', N'PALM')
  END
IF (@MANG > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Mangroves', N'MANG')
  END
IF (@SUCC > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Succulents', N'SUCC')
  END
IF (@UPHE > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Upland Herbs', N'UPHE')
  END
IF (@VACR > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Terrestrial Vascular Cryptogams', N'VACR')
  END
IF (@DIAT > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Diatoms', N'DIAT')
  END
IF (@BNTH > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Benthic', N'BNTH')
  END
IF (@COSM > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Cosmopolitan', N'COSM')
  END
IF (@INTR > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Interstitial', N'INTR')
  END
IF (@MARI > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Marine', N'MARI')
  END
IF (@NEKT > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Nektonic', N'NEKT')
  END
IF (@OCOD > 0)
  BEGIN
    SET @TOPTAXAMAXID = @TOPTAXAMAXID + 1
	INSERT INTO @TOPTAXA (ID, TaxonName, EcolGroupID) VALUES (@TOPTAXAMAXID, N'Other Undifferentiated', N'OCOD')
  END


SET @NSAMPLES = (SELECT COUNT(NDB.AnalysisUnits.Depth)
                 FROM NDB.Samples INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
                 WHERE (NDB.Samples.DatasetID = @DATASETID))

SET @NDEPTHS = (SELECT COUNT(NDB.AnalysisUnits.Depth)
                FROM NDB.Samples INNER JOIN
                     NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
                WHERE (NDB.Samples.DatasetID = @DATASETID)
                HAVING (COUNT(NDB.AnalysisUnits.Depth) IS NOT NULL))

INSERT INTO @DEPTHS (SampleID, Depth)
SELECT TOP (100) PERCENT NDB.Samples.SampleID, NDB.AnalysisUnits.Depth
FROM   NDB.Samples INNER JOIN
         NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID AND 
         NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
WHERE (NDB.Samples.DatasetID = @DATASETID)
ORDER BY NDB.AnalysisUnits.Depth

SET @MAXDEPTHID = (SELECT MAX(ID) FROM @DEPTHS)

-- get data by depth 

IF (@NDEPTHS = @NSAMPLES)
  BEGIN
    -- get all values for non-lumped and non-sum taxa 
    IF (@DATASETTYPEID = 3) -- pollen
	  BEGIN
	    INSERT INTO @DATA (SampleID, TaxonName, EcolGroupID, Value, Depth)
	    SELECT TOP (100) PERCENT NDB.Samples.SampleID, NDB.Taxa.TaxonName, NDB.EcolGroups.EcolGroupID, NDB.Data.Value, NDB.AnalysisUnits.Depth
        FROM NDB.Samples INNER JOIN
           NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
           @TOPTAXA ON NDB.Taxa.TaxonName = [@TOPTAXA].TaxonName
        WHERE (NDB.Samples.DatasetID = @DATASETID) AND (NDB.EcolGroups.EcolSetID = 1) AND 
	      ((NDB.Variables.VariableElementID = 141 AND NDB.Variables.VariableContextID IS NULL) OR 
		  (NDB.Variables.VariableElementID = 166 AND NDB.Variables.VariableContextID IS NULL)) AND 
		  ((NDB.Variables.VariableUnitsID = 19 OR NDB.Variables.VariableUnitsID = 28))
        ORDER BY NDB.Taxa.TaxonName, NDB.AnalysisUnits.Depth
	  END
    ELSE IF (@DATASETTYPEID = 9) -- ostracodes
	  BEGIN
	    INSERT INTO @DATA (SampleID, TaxonName, EcolGroupID, Value, Depth)
	    SELECT TOP (100) PERCENT NDB.Samples.SampleID, NDB.Taxa.TaxonName, NDB.EcolGroups.EcolGroupID, NDB.Data.Value, NDB.AnalysisUnits.Depth
        FROM NDB.Samples INNER JOIN
           NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
           @TOPTAXA ON NDB.Taxa.TaxonName = [@TOPTAXA].TaxonName
        WHERE (NDB.Samples.DatasetID = @DATASETID) AND (NDB.EcolGroups.EcolSetID = 4) AND 
		      ((NDB.Variables.VariableUnitsID = 19 OR NDB.Variables.VariableUnitsID = 28))
        ORDER BY NDB.Taxa.TaxonName, NDB.AnalysisUnits.Depth
	  END
	ELSE IF (@DATASETTYPEID = 11) -- diatoms
	  BEGIN
	    INSERT INTO @DATA (SampleID, TaxonName, EcolGroupID, Value, Depth)
	    SELECT TOP (100) PERCENT NDB.Samples.SampleID, NDB.Taxa.TaxonName, NDB.EcolGroups.EcolGroupID, NDB.Data.Value, NDB.AnalysisUnits.Depth
        FROM NDB.Samples INNER JOIN
           NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
           NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
           NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
           NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
           NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
           @TOPTAXA ON NDB.Taxa.TaxonName = [@TOPTAXA].TaxonName
        WHERE (NDB.Samples.DatasetID = @DATASETID) AND (NDB.EcolGroups.EcolSetID = 8) AND 
		      ((NDB.Variables.VariableUnitsID = 19 OR NDB.Variables.VariableUnitsID = 28))
        ORDER BY NDB.Taxa.TaxonName, NDB.AnalysisUnits.Depth
	  END
	ELSE IF (@DATASETTYPEID = 2) -- LOI
	  BEGIN
	    -- element is null
	    INSERT INTO @DATA (SampleID, TaxonName, EcolGroupID, Value, Depth, Units)
	    SELECT TOP (100) PERCENT NDB.Samples.SampleID, [@TOPTAXA].TaxonName, NDB.EcolGroups.EcolGroupID, NDB.Data.Value, NDB.AnalysisUnits.Depth, [@TOPTAXA].Units
        FROM  @TOPTAXA INNER JOIN
                NDB.Taxa ON [@TOPTAXA].TaxonName = NDB.Taxa.TaxonName INNER JOIN
                NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID AND NDB.Taxa.TaxonID = NDB.Variables.TaxonID INNER JOIN
                NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID AND NDB.Variables.VariableID = NDB.Data.VariableID INNER JOIN
                NDB.Samples ON NDB.Data.SampleID = NDB.Samples.SampleID AND NDB.Data.SampleID = NDB.Samples.SampleID INNER JOIN
                NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID AND 
                NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
                NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID AND NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
        WHERE (NDB.Samples.DatasetID = @DATASETID) AND ([@TOPTAXA].Element IS NULL)
        ORDER BY [@TOPTAXA].TaxonName, NDB.AnalysisUnits.Depth
		-- element is not null
		INSERT INTO @DATA (SampleID, TaxonName, EcolGroupID, Value, Depth, Units)
		SELECT TOP (100) PERCENT NDB.Samples.SampleID, CASE WHEN [@TOPTAXA].Element IS NOT NULL 
                      THEN [@TOPTAXA].TaxonName + N' ' + [@TOPTAXA].Element ELSE [@TOPTAXA].TaxonName END AS TaxonName, NDB.EcolGroups.EcolGroupID, 
                      NDB.Data.Value, NDB.AnalysisUnits.Depth, [@TOPTAXA].Units
        FROM  @TOPTAXA INNER JOIN
                NDB.Taxa ON [@TOPTAXA].TaxonName = NDB.Taxa.TaxonName INNER JOIN
                NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID AND NDB.Taxa.TaxonID = NDB.Variables.TaxonID INNER JOIN
                NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID AND NDB.Variables.VariableID = NDB.Data.VariableID INNER JOIN
                NDB.Samples ON NDB.Data.SampleID = NDB.Samples.SampleID AND NDB.Data.SampleID = NDB.Samples.SampleID INNER JOIN
                NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID AND 
                NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
                NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID AND 
                NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID AND 
                [@TOPTAXA].Element = NDB.VariableElements.VariableElement INNER JOIN
                NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID AND NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID
        WHERE (NDB.Samples.DatasetID = @DATASETID)
        ORDER BY TaxonName, NDB.AnalysisUnits.Depth
	  END

    IF (@DATASETTYPEID IN(3,9,11)) -- pollen, ostracodes, diatoms
	  BEGIN
	    -- add zero values -- will also add zero place holder values for lumped and summed taxa 
	    SET @ITR = (SELECT MIN(ID) FROM @TOPTAXA)
        SET @MAXID = (SELECT MAX(ID) FROM @TOPTAXA)
	    WHILE (@ITR <= @MAXID)
          BEGIN
	        SET @TAXONNAME = (SELECT TaxonName FROM @TOPTAXA WHERE (ID = @ITR))
		    SET @ECOLGROUPID = (SELECT EcolGroupID FROM @TOPTAXA WHERE (ID = @ITR))
        
		    INSERT INTO @TAXADEPTHS (Depth)
		    SELECT Depth FROM @DATA WHERE (TaxonName = @TAXONNAME)
		
		    INSERT INTO @TEMPDATA (Depth, TaxonName, EcolGroupID) 
		    SELECT Depth, @TAXONNAME, @ECOLGROUPID 
            FROM @DEPTHS
            WHERE NOT EXISTS (SELECT Depth FROM @TAXADEPTHS WHERE [@DEPTHS].Depth = [@TAXADEPTHS].Depth)

		    UPDATE @TEMPDATA
            SET [@TEMPDATA].SampleID = [@DEPTHS].SampleID
            FROM @DEPTHS
            WHERE ([@DEPTHS].Depth = [@TEMPDATA].Depth)

		    INSERT INTO @DATA(SampleID, TaxonName, EcolGroupID, Value, Depth)
            SELECT SampleID, TaxonName, EcolGroupID, Value, Depth
            FROM   @TEMPDATA

		    DELETE FROM @TEMPDATA WHERE (ID <= (SELECT MAX(ID) FROM @TEMPDATA))
		    DELETE FROM @TAXADEPTHS WHERE (ID <= (SELECT MAX(ID) FROM @TAXADEPTHS)) 
	        SET @ITR = @ITR + 1  
	      END
	  
        -- add summed taxa

	    -- get list of all sums: grouped taxa + others  
	    INSERT INTO @ALLSUMS (SumName)
        SELECT SumName FROM @SUMMEDTAXA GROUP BY SumName

	    SET @ITR = (SELECT MIN(ID) FROM @ALLSUMS)
        SET @MAXID = (SELECT MAX(ID) FROM @ALLSUMS) 
	    WHILE (@ITR <= @MAXID)
          BEGIN 
	        SET @LUMPEDTAXON = (SELECT SumName FROM @ALLSUMS WHERE (ID = @ITR))
	        DELETE FROM @TAXALIST WHERE (ID <= (SELECT MAX(ID) FROM @TAXALIST)) 
		    INSERT INTO @TAXALIST (TaxonName) SELECT TaxonName FROM @SUMMEDTAXA WHERE (SumName = @LUMPEDTAXON) 
		    SET @SQLTEXT = N''
		    SET @MINID = (SELECT MIN(ID) FROM @TAXALIST)
		    SET @ITR1 = @MINID
            SET @MAXID1 = (SELECT MAX(ID) FROM @TAXALIST) 
		    WHILE (@ITR1 <= @MAXID1)
              BEGIN
		        IF (@ITR1 > @MINID)
			      SET @SQLTEXT = @SQLTEXT + N', '
                SET @TAXONNAME = (SELECT TaxonName FROM @TAXALIST WHERE (ID = @ITR1))
			    SET @SQLTEXT = @SQLTEXT + N'N''' + @TAXONNAME + N''''
			    SET @ITR1 = @ITR1 + 1 
		      END 
            UPDATE @ALLSUMS SET SumStr = @SQLTEXT WHERE (ID = @ITR)
		    SET @ITR = @ITR + 1 
	      END
      
        SET @ITR = (SELECT MIN(ID) FROM @ALLSUMS)
        SET @MAXID = (SELECT MAX(ID) FROM @ALLSUMS) 
        WHILE (@ITR <= @MAXID)
          BEGIN
	        SET @LUMPEDTAXON = (SELECT SumName FROM @ALLSUMS WHERE (ID = @ITR))
		    SET @SQLTEXT = (SELECT SumStr FROM @ALLSUMS WHERE (ID = @ITR))
		
		    IF (@DATASETTYPEID = 3) -- pollen
		      BEGIN
		        SET @SQL = N'SELECT TOP (100) PERCENT NDB.Data.SampleID, SUM(NDB.Data.Value)
                           FROM NDB.Samples INNER JOIN
                              NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                              NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                              NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID
                           WHERE (NDB.Taxa.TaxonName IN (' + @SQLTEXT + N')) AND 
		                      ((NDB.Variables.VariableElementID = 141 AND NDB.Variables.VariableContextID IS NULL) OR 
							  (NDB.Variables.VariableElementID = 166 AND NDB.Variables.VariableContextID IS NULL)) AND 
						      ((NDB.Variables.VariableUnitsID = 19 OR NDB.Variables.VariableUnitsID = 28))
                           GROUP BY NDB.Samples.DatasetID, NDB.Data.SampleID
                           HAVING (NDB.Samples.DatasetID = @DATASETID)'
		      END
            ELSE IF (@DATASETTYPEID = 9 OR @DATASETTYPEID = 11) -- ostracodes, diatoms
		      BEGIN
		        SET @SQL = N'SELECT TOP (100) PERCENT NDB.Data.SampleID, SUM(NDB.Data.Value)
                           FROM NDB.Samples INNER JOIN
                              NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                              NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                              NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID
                           WHERE (NDB.Taxa.TaxonName IN (' + @SQLTEXT + N')) AND 
						      ((NDB.Variables.VariableUnitsID = 19 OR NDB.Variables.VariableUnitsID = 28))
                           GROUP BY NDB.Samples.DatasetID, NDB.Data.SampleID
                           HAVING (NDB.Samples.DatasetID = @DATASETID)'
		      END
		
		    INSERT INTO @SUMVALUES (SampleID, Value)
		    EXEC sp_executesql @SQL, N'@DATASETID int', @DATASETID
		    UPDATE @SUMVALUES SET SumName = @LUMPEDTAXON WHERE (SumName IS NULL)
		    SET @ITR = @ITR + 1
	      END
       
	    UPDATE @DATA
        SET [@DATA].Value = [@SUMVALUES].Value
        FROM @SUMVALUES
        WHERE ([@DATA].SampleID = [@SUMVALUES].SampleID) AND ([@DATA].TaxonName = [@SUMVALUES].SumName)
	  END
  END
    
-- get data by age

INSERT INTO @CHRONS (ChronologyID, NAges)
SELECT NDB.SampleAges.ChronologyID, COUNT(NDB.SampleAges.SampleID) AS NAges
FROM   NDB.Samples INNER JOIN
         NDB.SampleAges ON NDB.Samples.SampleID = NDB.SampleAges.SampleID
WHERE  (NDB.Samples.DatasetID = @DATASETID)
GROUP BY NDB.SampleAges.ChronologyID

SET @ITR = (SELECT MIN(ID) FROM @CHRONS)
SET @MAXID = (SELECT MAX(ID) FROM @CHRONS)
WHILE (@ITR <= @MAXID)
  BEGIN
    SET @NAGES = (SELECT NAges FROM @CHRONS WHERE (ID = @ITR))
	IF (@NAGES = @NSAMPLES)
	  BEGIN
        SET @DATAMINID = (SELECT MAX(ID) FROM @DATA)
		IF (@DATAMINID IS NULL)
		  SET @DATAMINID = 1
        ELSE
		  SET @DATAMINID = @DATAMINID + 1

		SET @CHRONID = (SELECT ChronologyID FROM @CHRONS WHERE (ID = @ITR))  
		SET @CHRONNAME = (SELECT ChronologyName FROM NDB.Chronologies WHERE (ChronologyID = @CHRONID))
		
		IF ((SELECT COUNT(*) FROM @DATA) > 0)  -- samples by depth or another chron already exist
		  BEGIN
		    INSERT INTO @TEMPDATA (SampleID, TaxonName, Units, EcolGroupID, Value, Depth, ChronologyID, ChronologyName)
			SELECT SampleID, TaxonName, Units, EcolGroupID, Value, Depth, @CHRONID, @CHRONNAME 
            FROM   @DATA
            GROUP BY SampleID, TaxonName, Units, EcolGroupID, Value, Depth
			ORDER BY TaxonName, Depth

			UPDATE @TEMPDATA
            SET [@TEMPDATA].Age = NDB.SampleAges.Age
            FROM NDB.SampleAges
            WHERE (([@TEMPDATA].SampleID = NDB.SampleAges.SampleID) AND ([@TEMPDATA].ChronologyID = NDB.SampleAges.ChronologyID))
			
			INSERT INTO @DATA(SampleID, TaxonName, Units, EcolGroupID, Value, Depth, ChronologyID, ChronologyName, Age)
            SELECT SampleID, TaxonName, Units, EcolGroupID, Value, Depth, ChronologyID, ChronologyName, Age
            FROM   @TEMPDATA

			DELETE FROM @TEMPDATA WHERE (ID <= (SELECT MAX(ID) FROM @TEMPDATA)) 
		  END
	  END
	SET @ITR = @ITR + 1
  END

IF (@DATASETTYPEID IN(3,9,11))
  BEGIN
    SELECT SampleID, TaxonName, EcolGroupID, Value, Depth, ChronologyID, ChronologyName, Age
    FROM @DATA
    ORDER BY ChronologyID, TaxonName, Age, Depth
  END
ELSE IF (@DATASETTYPEID = 2)
  BEGIN
    SELECT SampleID, TaxonName, Units, EcolGroupID, Value, Depth, ChronologyID, ChronologyName, Age
    FROM @DATA
    ORDER BY ChronologyID, TaxonName, Age, Depth
  END
GO

-- ----------------------------
-- Procedure structure for GetDatasetTypes
-- ----------------------------

CREATE PROCEDURE [GetDatasetTypes]
AS SELECT     DatasetTypeID, DatasetType
FROM          NDB.DatasetTypes


GO

-- ----------------------------
-- Procedure structure for GetDatasetTypesByName
-- ----------------------------




CREATE PROCEDURE [GetDatasetTypesByName](@DATASETTYPE nvarchar(64))
AS 
DECLARE @DT nvarchar(80) = @DATASETTYPE + N'%'
SELECT     DatasetTypeID, DatasetType
FROM         NDB.DatasetTypes
WHERE     (DatasetType LIKE @DT)







GO

-- ----------------------------
-- Procedure structure for GetDatasetTypesByTaxaGroupID
-- ----------------------------



CREATE PROCEDURE [GetDatasetTypesByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS 
SELECT     NDB.DatasetTaxaGroupTypes.DatasetTypeID, NDB.DatasetTypes.DatasetType
FROM         NDB.DatasetTaxaGroupTypes INNER JOIN
                      NDB.DatasetTypes ON NDB.DatasetTaxaGroupTypes.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
WHERE     (NDB.DatasetTaxaGroupTypes.TaxaGroupID = @TAXAGROUPID)






GO

-- ----------------------------
-- Procedure structure for GetDatasetTypesHavingData
-- ----------------------------


CREATE PROCEDURE [GetDatasetTypesHavingData]
AS 
SELECT     NDB.DatasetTypes.DatasetTypeID, NDB.DatasetTypes.DatasetType
FROM         NDB.DatasetTypes INNER JOIN
                      NDB.Datasets ON NDB.DatasetTypes.DatasetTypeID = NDB.Datasets.DatasetTypeID
GROUP BY NDB.DatasetTypes.DatasetTypeID, NDB.DatasetTypes.DatasetType



GO

-- ----------------------------
-- Procedure structure for GetDatasetVariables
-- ----------------------------



CREATE PROCEDURE [GetDatasetVariables](@DATASETID int)
AS 
SELECT     NDB.Data.VariableID, NDB.Taxa.TaxonCode, NDB.Taxa.TaxonName, NDB.Taxa.Author, NDB.VariableElements.VariableElement, NDB.VariableUnits.VariableUnits, 
                      NDB.VariableContexts.VariableContext
FROM         NDB.VariableElements RIGHT OUTER JOIN
                      NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
                      NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID ON 
                      NDB.VariableElements.VariableElementID = NDB.Variables.VariableElementID
WHERE     (NDB.Samples.DatasetID = @DATASETID)
GROUP BY NDB.Data.VariableID, NDB.Taxa.TaxonCode, NDB.Taxa.TaxonName, NDB.Taxa.Author, NDB.VariableElements.VariableElement, NDB.VariableUnits.VariableUnits, 
                      NDB.VariableContexts.VariableContext




GO

-- ----------------------------
-- Procedure structure for GetDatasetVariableSynonyms
-- ----------------------------



CREATE PROCEDURE [GetDatasetVariableSynonyms](@DATASETID int, @VARIABLEID int)
AS 
SELECT     TOP (100) PERCENT NDB.Synonymy.SynonymyID, NDB.Taxa.TaxonName AS RefTaxonName, NDB.Synonymy.FromContributor, NDB.Synonymy.PublicationID, 
                      NDB.Synonymy.Notes
FROM         NDB.Synonymy INNER JOIN
                      NDB.Taxa ON NDB.Synonymy.RefTaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.Samples INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID ON NDB.Synonymy.DatasetID = NDB.Samples.DatasetID AND 
                      NDB.Synonymy.TaxonID = NDB.Variables.TaxonID
WHERE     (NDB.Samples.DatasetID = @DATASETID) AND (NDB.Data.VariableID = @VARIABLEID)
GROUP BY NDB.Synonymy.SynonymyID, NDB.Taxa.TaxonName, NDB.Synonymy.PublicationID, NDB.Synonymy.Notes, NDB.Synonymy.FromContributor
ORDER BY NDB.Synonymy.SynonymyID




GO

-- ----------------------------
-- Procedure structure for GetDatasetVariableUnits
-- ----------------------------




CREATE PROCEDURE [GetDatasetVariableUnits](@DATASETID int)
AS 
SELECT     TOP (100) PERCENT NDB.VariableUnits.VariableUnitsID, NDB.VariableUnits.VariableUnits
FROM         NDB.Datasets INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
GROUP BY NDB.Datasets.DatasetID, NDB.VariableUnits.VariableUnits, NDB.VariableUnits.VariableUnitsID
HAVING      (NDB.Datasets.DatasetID = @DATASETID)


GO

-- ----------------------------
-- Procedure structure for GetDepAgentByName
-- ----------------------------


CREATE PROCEDURE [GetDepAgentByName](@DEPAGENT nvarchar(64))
AS 
SELECT      DepAgentID, DepAgent 
FROM          NDB.DepAgentTypes
WHERE      (DepAgent = @DEPAGENT)



GO

-- ----------------------------
-- Procedure structure for GetDepAgentsTypesTable
-- ----------------------------



CREATE PROCEDURE [GetDepAgentsTypesTable]
AS SELECT     DepAgentID, DepAgent 
FROM          NDB.DepAgentTypes






GO

-- ----------------------------
-- Procedure structure for GetDepEnvtByID
-- ----------------------------






CREATE PROCEDURE [GetDepEnvtByID](@DEPENVTID int)
AS 
SELECT     DepEnvtID, DepEnvt, DepEnvtHigherID
FROM         NDB.DepEnvtTypes
WHERE     (DepEnvtID = @DEPENVTID)







GO

-- ----------------------------
-- Procedure structure for GetDepEnvtTypesTable
-- ----------------------------

CREATE PROCEDURE [GetDepEnvtTypesTable]
AS SELECT      DepEnvtID, DepEnvt, DepEnvtHigherID
FROM          NDB.DepEnvtTypes




GO

-- ----------------------------
-- Procedure structure for GetEcolGroupsByEcolSetID
-- ----------------------------





CREATE PROCEDURE [GetEcolGroupsByEcolSetID](@ECOLSETID int)
AS 
SELECT     TOP (100) PERCENT NDB.EcolGroups.EcolGroupID, NDB.EcolGroupTypes.EcolGroup
FROM         NDB.EcolGroupTypes INNER JOIN
                      NDB.EcolGroups ON NDB.EcolGroupTypes.EcolGroupID = NDB.EcolGroups.EcolGroupID
GROUP BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID, NDB.EcolGroupTypes.EcolGroup
HAVING      (NDB.EcolGroups.EcolSetID = @ECOLSETID)
ORDER BY NDB.EcolGroups.EcolGroupID







GO

-- ----------------------------
-- Procedure structure for GetEcolGroupsByTaxaGroupIDList
-- ----------------------------



CREATE PROCEDURE [GetEcolGroupsByTaxaGroupIDList](@TAXAGROUPLIST nvarchar(MAX))
AS 
SELECT NDB.EcolGroups.*
FROM         NDB.EcolGroups INNER JOIN NDB.Taxa ON NDB.EcolGroups.TaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.Taxa.TaxaGroupID IN (
		                           SELECT Value
		                           FROM TI.func_NvarcharListToIN(@TAXAGROUPLIST,'$')             
                                   ))





GO

-- ----------------------------
-- Procedure structure for GetEcolGroupsByVariableIDList
-- ----------------------------




CREATE PROCEDURE [GetEcolGroupsByVariableIDList](@VARIABLEIDS nvarchar(MAX))
AS
SELECT     NDB.Variables.VariableID, NDB.Taxa.TaxaGroupID, NDB.EcolSetTypes.EcolSetName, NDB.EcolGroupTypes.EcolGroupID
FROM         NDB.Variables INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
                      NDB.EcolGroupTypes ON NDB.EcolGroups.EcolGroupID = NDB.EcolGroupTypes.EcolGroupID INNER JOIN
                      NDB.EcolSetTypes ON NDB.EcolGroups.EcolSetID = NDB.EcolSetTypes.EcolSetID
WHERE     (NDB.Variables.VariableID IN (
                                       SELECT Value
                                       FROM TI.func_IntListToIN(@VARIABLEIDS,'$') 
                                       ))

                        





GO

-- ----------------------------
-- Procedure structure for GetEcolGroupsTable
-- ----------------------------

CREATE PROCEDURE [GetEcolGroupsTable]
AS SELECT      TaxonID, EcolSetID, EcolGroupID
FROM          NDB.EcolGroups



GO

-- ----------------------------
-- Procedure structure for GetEcolGroupTypesTable
-- ----------------------------



CREATE PROCEDURE [GetEcolGroupTypesTable]
AS SELECT      EcolGroupID, EcolGroup
FROM          NDB.EcolGroupTypes





GO

-- ----------------------------
-- Procedure structure for GetEcolSetCountsByTaxaGroupID
-- ----------------------------





CREATE PROCEDURE [GetEcolSetCountsByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS 
SELECT     TOP (100) PERCENT NDB.EcolGroups.EcolSetID, NDB.EcolSetTypes.EcolSetName, COUNT(*) AS Count
FROM         NDB.EcolGroups INNER JOIN
                      NDB.Taxa ON NDB.EcolGroups.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.EcolSetTypes ON NDB.EcolGroups.EcolSetID = NDB.EcolSetTypes.EcolSetID
GROUP BY NDB.Taxa.TaxaGroupID, NDB.EcolGroups.EcolSetID, NDB.EcolSetTypes.EcolSetName
HAVING      (NDB.Taxa.TaxaGroupID = @TAXAGROUPID)
ORDER BY NDB.EcolSetTypes.EcolSetName






GO

-- ----------------------------
-- Procedure structure for GetEcolSetsGroupsByTaxonID
-- ----------------------------




CREATE PROCEDURE [GetEcolSetsGroupsByTaxonID](@TAXONID int)
AS 
SELECT     TOP (100) PERCENT NDB.EcolGroups.TaxonID, NDB.EcolGroups.EcolSetID, NDB.EcolSetTypes.EcolSetName, NDB.EcolGroups.EcolGroupID, 
                      NDB.EcolGroupTypes.EcolGroup
FROM         NDB.EcolGroups INNER JOIN
                      NDB.EcolSetTypes ON NDB.EcolGroups.EcolSetID = NDB.EcolSetTypes.EcolSetID INNER JOIN
                      NDB.EcolGroupTypes ON NDB.EcolGroups.EcolGroupID = NDB.EcolGroupTypes.EcolGroupID
WHERE     (NDB.EcolGroups.TaxonID = @TAXONID)
ORDER BY NDB.EcolGroups.EcolSetID, NDB.EcolGroups.EcolGroupID






GO

-- ----------------------------
-- Procedure structure for GetEcolSetTypesTable
-- ----------------------------


CREATE PROCEDURE [GetEcolSetTypesTable]
AS SELECT     EcolSetID, EcolSetName
FROM          NDB.EcolSetTypes




GO

-- ----------------------------
-- Procedure structure for GetElementDatasetTaxaGroupCount
-- ----------------------------




CREATE PROCEDURE [GetElementDatasetTaxaGroupCount](@DATASETTYPEID int, @TAXAGROUPID nvarchar(3), @ELEMENTTYPEID int)
AS 
SELECT     COUNT(ElementTypeID) AS Count
FROM         NDB.ElementDatasetTaxaGroups
WHERE     (DatasetTypeID = @DATASETTYPEID) AND (TaxaGroupID = @TAXAGROUPID) AND (ElementTypeID = @ELEMENTTYPEID)



GO

-- ----------------------------
-- Procedure structure for GetElementDatasetTaxaGroupsTable
-- ----------------------------


CREATE PROCEDURE [GetElementDatasetTaxaGroupsTable]
AS 
SELECT     TOP (2147483647) DatasetTypeID, TaxaGroupID, ElementTypeID
FROM         NDB.ElementDatasetTaxaGroups
ORDER BY DatasetTypeID, TaxaGroupID, ElementTypeID



GO

-- ----------------------------
-- Procedure structure for GetElementMaturitiesTable
-- ----------------------------





CREATE PROCEDURE [GetElementMaturitiesTable]
AS SELECT     MaturityID, Maturity
FROM          NDB.ElementMaturities







GO

-- ----------------------------
-- Procedure structure for GetElementMaturityByName
-- ----------------------------



CREATE PROCEDURE [GetElementMaturityByName](@MATURITY nvarchar(36))
AS 
SELECT      MaturityID, Maturity 
FROM          NDB.ElementMaturities
WHERE      (Maturity = @MATURITY)





GO

-- ----------------------------
-- Procedure structure for GetElementPartID
-- ----------------------------




CREATE PROCEDURE [GetElementPartID](@PARTNAME nvarchar(36))
AS 
DECLARE @ElementParts TABLE
(
  SymmetryID int,
  PortionID int,
  MaturityID int
)

INSERT INTO @ElementParts (SymmetryID)
  SELECT  NDB.ElementSymmetries.SymmetryID
  FROM    NDB.ElementSymmetries 
  WHERE   NDB.ElementSymmetries.Symmetry = @PARTNAME
INSERT INTO @ElementParts (PortionID)
  SELECT  NDB.ElementPortions.PortionID
  FROM    NDB.ElementPortions 
  WHERE   NDB.ElementPortions.Portion = @PARTNAME
INSERT INTO @ElementParts (MaturityID)
  SELECT  NDB.ElementMaturities.MaturityID
  FROM    NDB.ElementMaturities
  WHERE   NDB.ElementMaturities.Maturity = @PARTNAME
   
SELECT SymmetryID, PortionID, MaturityID
FROM @ElementParts


GO

-- ----------------------------
-- Procedure structure for GetElementPortionByName
-- ----------------------------



CREATE PROCEDURE [GetElementPortionByName](@PORTION nvarchar(48))
AS 
SELECT      PortionID, Portion 
FROM          NDB.ElementPortions
WHERE      (Portion = @PORTION)





GO

-- ----------------------------
-- Procedure structure for GetElementPortionsTable
-- ----------------------------





CREATE PROCEDURE [GetElementPortionsTable]
AS 
SELECT      PortionID, Portion
FROM        NDB.ElementPortions







GO

-- ----------------------------
-- Procedure structure for GetElementsByTaxonID
-- ----------------------------



CREATE PROCEDURE [GetElementsByTaxonID](@TAXONID int)
AS 
SELECT     TOP (100) PERCENT NDB.VariableElements.VariableElementID, NDB.ElementTypes.ElementType, NDB.ElementSymmetries.Symmetry, NDB.ElementPortions.Portion, 
                      NDB.ElementMaturities.Maturity
FROM         NDB.Variables INNER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID LEFT OUTER JOIN
                      NDB.ElementMaturities ON NDB.VariableElements.MaturityID = NDB.ElementMaturities.MaturityID LEFT OUTER JOIN
                      NDB.ElementPortions ON NDB.VariableElements.PortionID = NDB.ElementPortions.PortionID LEFT OUTER JOIN
                      NDB.ElementSymmetries ON NDB.VariableElements.SymmetryID = NDB.ElementSymmetries.SymmetryID LEFT OUTER JOIN
                      NDB.ElementTypes ON NDB.VariableElements.ElementTypeID = NDB.ElementTypes.ElementTypeID
GROUP BY NDB.Variables.TaxonID, NDB.ElementTypes.ElementType, NDB.ElementSymmetries.Symmetry, NDB.ElementPortions.Portion, NDB.ElementMaturities.Maturity, 
                      NDB.VariableElements.VariableElementID
HAVING      (NDB.Variables.TaxonID = @TAXONID)
ORDER BY NDB.ElementTypes.ElementType, NDB.ElementSymmetries.Symmetry, NDB.ElementPortions.Portion, NDB.ElementMaturities.Maturity




GO

-- ----------------------------
-- Procedure structure for GetElementSymmetriesTable
-- ----------------------------





CREATE PROCEDURE [GetElementSymmetriesTable]
AS SELECT     SymmetryID, Symmetry
FROM          NDB.ElementSymmetries







GO

-- ----------------------------
-- Procedure structure for GetElementSymmetryByName
-- ----------------------------



CREATE PROCEDURE [GetElementSymmetryByName](@SYMMETRY nvarchar(24))
AS 
SELECT      SymmetryID, Symmetry 
FROM          NDB.ElementSymmetries
WHERE      (Symmetry = @SYMMETRY)





GO

-- ----------------------------
-- Procedure structure for GetElementTaxaGroupID
-- ----------------------------






CREATE PROCEDURE [GetElementTaxaGroupID](@TAXAGROUPID nvarchar(3), @ELEMENTTYPEID int)
AS
SELECT     ElementTaxaGroupID
FROM         NDB.ElementTaxaGroups
WHERE     (TaxaGroupID = @TAXAGROUPID) AND (ElementTypeID = @ELEMENTTYPEID)








GO

-- ----------------------------
-- Procedure structure for GetElementTaxaGroupMaturitiesTable
-- ----------------------------





CREATE PROCEDURE [GetElementTaxaGroupMaturitiesTable]
AS SELECT     ElementTaxaGroupID, MaturityID
FROM          NDB.ElementTaxaGroupMaturities







GO

-- ----------------------------
-- Procedure structure for GetElementTaxaGroupPortionsTable
-- ----------------------------





CREATE PROCEDURE [GetElementTaxaGroupPortionsTable]
AS SELECT     ElementTaxaGroupID, PortionID
FROM          NDB.ElementTaxaGroupPortions







GO

-- ----------------------------
-- Procedure structure for GetElementTaxaGroupsTable
-- ----------------------------






CREATE PROCEDURE [GetElementTaxaGroupsTable]
AS SELECT     ElementTaxaGroupID, TaxaGroupID, ElementTypeID
FROM          NDB.ElementTaxaGroups








GO

-- ----------------------------
-- Procedure structure for GetElementTaxaGroupSymmetriesTable
-- ----------------------------





CREATE PROCEDURE [GetElementTaxaGroupSymmetriesTable]
AS SELECT     ElementTaxaGroupID, SymmetryID
FROM          NDB.ElementTaxaGroupSymmetries







GO

-- ----------------------------
-- Procedure structure for GetElementTypeByDatasetTypeID
-- ----------------------------





CREATE PROCEDURE [GetElementTypeByDatasetTypeID](@DATASETTYPEID int)
AS 
SELECT     TOP (100) PERCENT NDB.ElementTypes.ElementTypeID, NDB.ElementTypes.ElementType, NDB.ElementDatasetTaxaGroups.TaxaGroupID
FROM         NDB.ElementDatasetTaxaGroups INNER JOIN
                      NDB.ElementTypes ON NDB.ElementDatasetTaxaGroups.ElementTypeID = NDB.ElementTypes.ElementTypeID
WHERE     (NDB.ElementDatasetTaxaGroups.DatasetTypeID = 5)
ORDER BY NDB.ElementDatasetTaxaGroups.TaxaGroupID, NDB.ElementTypes.ElementType






GO

-- ----------------------------
-- Procedure structure for GetElementTypeByName
-- ----------------------------


CREATE PROCEDURE [GetElementTypeByName](@ELEMENTTYPE nvarchar(64))
AS 
SELECT      ElementTypeID, ElementType
FROM          NDB.ElementTypes
WHERE      (ElementType = @ELEMENTTYPE)




GO

-- ----------------------------
-- Procedure structure for GetElementTypeFromVariableElement
-- ----------------------------



CREATE PROCEDURE [GetElementTypeFromVariableElement](@VARIABLEELEMENT nvarchar(64))
AS 
DECLARE @SEMICOLON nvarchar(1) = N';'
IF CHARINDEX(N';',@VARIABLEELEMENT) = 0
  BEGIN
    SELECT ElementTypeID, ElementType
    FROM   NDB.ElementTypes
	WHERE  (ElementType = @VARIABLEELEMENT)
  END
ELSE
  BEGIN
    SELECT TOP(1) ElementTypeID, ElementType
    FROM  NDB.ElementTypes
    WHERE (ElementType = LEFT(@VARIABLEELEMENT, LEN(ElementType)) AND SUBSTRING(@VARIABLEELEMENT, LEN(ElementType)+1, 1) = @SEMICOLON) 
    ORDER BY LEN(ElementType) DESC
  END

GO

-- ----------------------------
-- Procedure structure for GetElementTypesByNameList
-- ----------------------------



CREATE PROCEDURE [GetElementTypesByNameList](@ELEMENTTYPES nvarchar(MAX))
AS 
SELECT ElementTypeID, ElementType
FROM NDB.ElementTypes
WHERE (ElementType IN (
		            SELECT Value
		            FROM TI.func_NvarcharListToIN(@ELEMENTTYPES,'$')
                    ))
                    




GO

-- ----------------------------
-- Procedure structure for GetElementTypesByTaxaGroupID
-- ----------------------------




CREATE PROCEDURE [GetElementTypesByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS 
SELECT     NDB.ElementTaxaGroups.ElementTypeID, NDB.ElementTypes.ElementType
FROM         NDB.ElementTaxaGroups INNER JOIN
                      NDB.ElementTypes ON NDB.ElementTaxaGroups.ElementTypeID = NDB.ElementTypes.ElementTypeID
WHERE     (NDB.ElementTaxaGroups.TaxaGroupID = @TAXAGROUPID)




GO

-- ----------------------------
-- Procedure structure for GetElementTypesTable
-- ----------------------------




CREATE PROCEDURE [GetElementTypesTable]
AS SELECT      ElementTypeID, ElementType
FROM          NDB.ElementTypes






GO

-- ----------------------------
-- Procedure structure for GetEventByName
-- ----------------------------





CREATE PROCEDURE [GetEventByName](@EVENTNAME nvarchar(80))
AS 
SELECT     EventID, EventTypeID, EventName, C14Age, C14AgeOlder, C14AgeYounger, CalAge, CalAgeYounger, CalAgeOlder, Notes
FROM         NDB.Events
WHERE     (EventName = @EVENTNAME)


GO

-- ----------------------------
-- Procedure structure for GetEventChronControlTypeID
-- ----------------------------



CREATE PROCEDURE [GetEventChronControlTypeID](@EVENTNAME nvarchar(80))
AS 
SELECT     NDB.Events.EventID, NDB.EventTypes.ChronControlTypeID
FROM         NDB.EventTypes INNER JOIN
                      NDB.Events ON NDB.EventTypes.EventTypeID = NDB.Events.EventTypeID
WHERE     (NDB.Events.EventName = @EVENTNAME)




GO

-- ----------------------------
-- Procedure structure for GetEventPublications
-- ----------------------------





CREATE PROCEDURE [GetEventPublications](@EVENTID int)
AS 
SELECT      NDB.Publications.PublicationID, NDB.Publications.PubTypeID, NDB.Publications.Year, NDB.Publications.Citation, NDB.Publications.ArticleTitle, 
                      NDB.Publications.Journal, NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, NDB.Publications.CitationNumber, NDB.Publications.DOI, 
                      NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, 
                      NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, NDB.Publications.City, NDB.Publications.State, NDB.Publications.Country, 
                      NDB.Publications.OriginalLanguage, NDB.Publications.Notes
FROM         NDB.EventPublications INNER JOIN
                      NDB.Publications ON NDB.EventPublications.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.EventPublications.EventID = @EVENTID)


GO

-- ----------------------------
-- Procedure structure for GetEventsByChronologyID
-- ----------------------------




CREATE PROCEDURE [GetEventsByChronologyID](@CHRONOLOGYID int)
AS 
SELECT     NDB.EventChronology.ChronControlID, NDB.Events.EventName
FROM         NDB.ChronControls INNER JOIN
                      NDB.Chronologies ON NDB.ChronControls.ChronologyID = NDB.Chronologies.ChronologyID INNER JOIN
                      NDB.EventChronology ON NDB.ChronControls.ChronControlID = NDB.EventChronology.ChronControlID INNER JOIN
                      NDB.Events ON NDB.EventChronology.EventID = NDB.Events.EventID
WHERE     (NDB.Chronologies.ChronologyID = @CHRONOLOGYID) AND (NDB.EventChronology.ChronControlID IS NOT NULL)




GO

-- ----------------------------
-- Procedure structure for GetEventsTable
-- ----------------------------




CREATE PROCEDURE [GetEventsTable]
AS 
SELECT     EventID, EventTypeID, EventName, C14Age, C14AgeOlder, C14AgeYounger, CalAge, CalAgeYounger, CalAgeOlder, Notes
FROM          NDB.Events

GO

-- ----------------------------
-- Procedure structure for GetEventTypeByName
-- ----------------------------






CREATE PROCEDURE [GetEventTypeByName](@EVENTTYPE nvarchar(40))
AS 
SELECT     EventTypeID, EventType
FROM         NDB.EventTypes
WHERE     (EventType = @EVENTTYPE)



GO

-- ----------------------------
-- Procedure structure for GetEventTypesTable
-- ----------------------------



CREATE PROCEDURE [GetEventTypesTable]
AS SELECT      EventTypeID, EventType, ChronControlTypeID
FROM          NDB.EventTypes






GO

-- ----------------------------
-- Procedure structure for GetFaciesTypeByName
-- ----------------------------




CREATE PROCEDURE [GetFaciesTypeByName](@FACIES nvarchar(64))
AS 
SELECT      FaciesID, Facies 
FROM          NDB.FaciesTypes
WHERE      (Facies = @FACIES)






GO

-- ----------------------------
-- Procedure structure for GetFaciesTypesTable
-- ----------------------------


CREATE PROCEDURE [GetFaciesTypesTable]
AS SELECT      FaciesID, Facies
FROM          NDB.FaciesTypes





GO

-- ----------------------------
-- Procedure structure for GetFAUNMAP1RelativeAgesByChronControlIDList
-- ----------------------------



CREATE PROCEDURE [GetFAUNMAP1RelativeAgesByChronControlIDList](@CHRONCONTROLIDS nvarchar(MAX))
AS 
SELECT     NDB.ChronControls.ChronControlID, NDB.RelativeAgeScales.RelativeAgeScale, NDB.RelativeAgeUnits.RelativeAgeUnit, NDB.RelativeAges.RelativeAge, 
                      NDB.RelativeAges.C14AgeOlder, NDB.RelativeAges.C14AgeYounger, NDB.RelativeAges.CalAgeOlder, NDB.RelativeAges.CalAgeYounger
FROM         NDB.RelativeChronology INNER JOIN
                      NDB.RelativeAges ON NDB.RelativeChronology.RelativeAgeID = NDB.RelativeAges.RelativeAgeID INNER JOIN
                      NDB.ChronControls ON NDB.RelativeChronology.AnalysisUnitID = NDB.ChronControls.AnalysisUnitID INNER JOIN
                      NDB.RelativeAgeScales ON NDB.RelativeAges.RelativeAgeScaleID = NDB.RelativeAgeScales.RelativeAgeScaleID INNER JOIN
                      NDB.RelativeAgeUnits ON NDB.RelativeAges.RelativeAgeUnitID = NDB.RelativeAgeUnits.RelativeAgeUnitID
WHERE (ChronControlID IN (
		                 SELECT Value
		                 FROM TI.func_NvarcharListToIN(@CHRONCONTROLIDS,'$')
                         ))
                    




GO

-- ----------------------------
-- Procedure structure for GetFractionDatedTable
-- ----------------------------



CREATE PROCEDURE [GetFractionDatedTable]
AS SELECT      NDB.FractionDated.*
FROM          NDB.FractionDated






GO

-- ----------------------------
-- Procedure structure for GetFractionsDatedByList
-- ----------------------------



CREATE PROCEDURE [GetFractionsDatedByList](@FRACTIONS nvarchar(MAX))
AS 
SELECT FractionID, Fraction
FROM NDB.FractionDated
WHERE (Fraction IN (
		            SELECT Value
		            FROM TI.func_NvarcharListToIN(@FRACTIONS,'$')
                    ))
                    




GO

-- ----------------------------
-- Procedure structure for GetGeochronAnalysisUnit
-- ----------------------------




CREATE PROCEDURE [GetGeochronAnalysisUnit](@GEOCHRONID int)
AS 
SELECT     NDB.Samples.SampleID, NDB.AnalysisUnits.CollectionUnitID, NDB.AnalysisUnits.AnalysisUnitID, NDB.AnalysisUnits.AnalysisUnitName, NDB.AnalysisUnits.Depth, 
             NDB.AnalysisUnits.Thickness 
FROM       NDB.Geochronology INNER JOIN
                      NDB.Samples ON NDB.Geochronology.SampleID = NDB.Samples.SampleID INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
WHERE     (NDB.Geochronology.GeochronID = @GEOCHRONID)






GO

-- ----------------------------
-- Procedure structure for GetGeochronByDatasetID
-- ----------------------------




CREATE PROCEDURE [GetGeochronByDatasetID](@DATASETID int)
AS 
SELECT     NDB.Geochronology.GeochronID, NDB.Geochronology.GeochronTypeID, NDB.GeochronTypes.GeochronType, NDB.AgeTypes.AgeType, NDB.AnalysisUnits.Depth, 
                      NDB.AnalysisUnits.Thickness, NDB.AnalysisUnits.AnalysisUnitName, NDB.Geochronology.Age, NDB.Geochronology.ErrorOlder, NDB.Geochronology.ErrorYounger, 
                      NDB.Geochronology.Infinite, NDB.Geochronology.LabNumber, NDB.Geochronology.MaterialDated, NDB.Geochronology.Notes
FROM         NDB.Geochronology INNER JOIN
                      NDB.Samples ON NDB.Geochronology.SampleID = NDB.Samples.SampleID INNER JOIN
                      NDB.Datasets ON NDB.Samples.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.GeochronTypes ON NDB.Geochronology.GeochronTypeID = NDB.GeochronTypes.GeochronTypeID INNER JOIN
                      NDB.AgeTypes ON NDB.Geochronology.AgeTypeID = NDB.AgeTypes.AgeTypeID INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID
WHERE     (NDB.Datasets.DatasetID = @DATASETID)






GO

-- ----------------------------
-- Procedure structure for GetGeochronByGeochronID
-- ----------------------------





CREATE PROCEDURE [GetGeochronByGeochronID](@GEOCHRONID int)
AS 
SELECT     SampleID, GeochronTypeID, AgeTypeID, Age, ErrorOlder, ErrorYounger, Infinite, LabNumber, MaterialDated, Notes
FROM       NDB.Geochronology
WHERE     (GeochronID = @GEOCHRONID)





GO

-- ----------------------------
-- Procedure structure for GetGeochronControlCount
-- ----------------------------




-- gets number of ChronControls assigned to GeochronID
CREATE PROCEDURE [GetGeochronControlCount](@GEOCHRONID int)
AS 
SELECT     COUNT(ChronControlID) AS Count
FROM       NDB.GeoChronControls
WHERE     (GeochronID = @GEOCHRONID)



GO

-- ----------------------------
-- Procedure structure for GetGeoChronControlsByChronologyID
-- ----------------------------




CREATE PROCEDURE [GetGeoChronControlsByChronologyID](@CHRONOLOGYID int)
AS 
SELECT     NDB.GeoChronControls.ChronControlID, NDB.GeoChronControls.GeochronID
FROM         NDB.GeoChronControls INNER JOIN
                      NDB.ChronControls ON NDB.GeoChronControls.ChronControlID = NDB.ChronControls.ChronControlID
WHERE     (NDB.ChronControls.ChronologyID = @CHRONOLOGYID)
 




GO

-- ----------------------------
-- Procedure structure for GetGeochronCounts
-- ----------------------------





CREATE PROCEDURE [GetGeochronCounts]
AS 
SELECT     TOP (100) PERCENT NDB.GeochronTypes.GeochronType, COUNT(NDB.GeochronTypes.GeochronType) AS Count
FROM         NDB.Geochronology INNER JOIN
                      NDB.GeochronTypes ON NDB.Geochronology.GeochronTypeID = NDB.GeochronTypes.GeochronTypeID
GROUP BY NDB.GeochronTypes.GeochronType
ORDER BY Count DESC






GO

-- ----------------------------
-- Procedure structure for GetGeochronIDCount
-- ----------------------------




-- gets number of samples assigned to analysis unit
CREATE PROCEDURE [GetGeochronIDCount](@GEOCHRONID int)
AS 
SELECT     COUNT(GeochronID) AS Count
FROM       NDB.Radiocarbon
WHERE     (GeochronID = @GEOCHRONID)




GO

-- ----------------------------
-- Procedure structure for GetGeochronTypeID
-- ----------------------------





CREATE PROCEDURE [GetGeochronTypeID](@GEOCHRONTYPE nvarchar(64))
AS 
SELECT     GeochronTypeID
FROM       NDB.GeochronTypes
WHERE     (GeochronType = @GEOCHRONTYPE)







GO

-- ----------------------------
-- Procedure structure for GetGeochronTypesTable
-- ----------------------------



CREATE PROCEDURE [GetGeochronTypesTable]
AS SELECT     GeochronTypeID, GeochronType 
FROM          NDB.GeochronTypes






GO

-- ----------------------------
-- Procedure structure for GetGeoPolBySiteName
-- ----------------------------

CREATE PROCEDURE [GetGeoPolBySiteName](@SITENAME nvarchar(128), @EAST float, @NORTH float, @WEST float, @SOUTH float)
AS 
DECLARE @SITE1 geography
IF ((@NORTH > @SOUTH) AND (@EAST > @WEST))
  BEGIN
    SET @SITE1 = geography::STGeomFromText('POLYGON((' + 
                 CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
                 CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			     CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			     CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			     CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + '))', 4326)
    END
ELSE
  BEGIN
    SET @SITE1 = geography::STGeomFromText('POINT(' + CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ')', 4326)  
  END

  SELECT   NDB.Sites.SiteID, NDB.Sites.SiteName, @SITE1.EnvelopeCenter().STDistance(geography::STGeomFromText(geog.ToString(), 4326).EnvelopeCenter())/1000 AS DistKm,
           TI.GeoPol1.GeoPolName1 + 
           IIF(TI.GeoPol2.GeoPolName2 IS NOT NULL, N'|' + TI.GeoPol2.GeoPolName2 + 
		       IIF(TI.GeoPol3.GeoPolName3 IS NOT NULL, N'|' + TI.GeoPol3.GeoPolName3, N'') + 
			   IIF(TI.GeoPol4.GeoPolName4 IS NOT NULL, N'|' + TI.GeoPol4.GeoPolName4, N''),N'') AS Geopolitical
  FROM     NDB.Sites LEFT OUTER JOIN
                    TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID LEFT OUTER JOIN
                    TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID LEFT OUTER JOIN
                    TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                    TI.GeoPol4 ON NDB.Sites.SiteID = TI.GeoPol4.SiteID 
  WHERE   (NDB.Sites.SiteName LIKE @SITENAME)
  ORDER BY DistKm 
GO

-- ----------------------------
-- Procedure structure for GetGeoPoliticalUnitsTable
-- ----------------------------

CREATE PROCEDURE [GetGeoPoliticalUnitsTable]
AS SELECT     NDB.GeoPoliticalUnits.*
FROM          NDB.GeoPoliticalUnits



GO

-- ----------------------------
-- Procedure structure for GetGeoPolNumberOfSubdivs
-- ----------------------------


CREATE PROCEDURE [GetGeoPolNumberOfSubdivs](@HIGHERGEOPOLID int)
AS SELECT      COUNT(GeoPoliticalID) AS NumberOfSubdivs
FROM          NDB.GeoPoliticalUnits
GROUP BY HigherGeoPoliticalID
HAVING       (HigherGeoPoliticalID = @HIGHERGEOPOLID)




GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitByHigherID
-- ----------------------------



CREATE PROCEDURE [GetGeoPolUnitByHigherID](@HIGHERGEOPOLID int)
AS SELECT      GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM          NDB.GeoPoliticalUnits
WHERE      (HigherGeoPoliticalID = @HIGHERGEOPOLID)





GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitByID
-- ----------------------------



CREATE PROCEDURE [GetGeoPolUnitByID](@GEOPOLID int)
AS SELECT      GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM          NDB.GeoPoliticalUnits
WHERE      (GeoPoliticalID = @GEOPOLID)





GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitByNameAndHigherID
-- ----------------------------


CREATE PROCEDURE [GetGeoPolUnitByNameAndHigherID](@GEOPOLNAME nvarchar(255),
@HIGHERGEOPOLID int)
AS SELECT      GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM          NDB.GeoPoliticalUnits
WHERE      (GeoPoliticalName = @GEOPOLNAME) AND (HigherGeoPoliticalID = @HIGHERGEOPOLID)




GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitByNameAndRank
-- ----------------------------


CREATE PROCEDURE [GetGeoPolUnitByNameAndRank](@GEOPOLNAME nvarchar(255),
@RANK int)
AS SELECT      GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM          NDB.GeoPoliticalUnits
WHERE      (GeoPoliticalName = @GEOPOLNAME) AND (Rank = @RANK)




GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitByRank
-- ----------------------------



CREATE PROCEDURE [GetGeoPolUnitByRank](@RANK int)
AS 
SELECT     TOP (100) PERCENT GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM         NDB.GeoPoliticalUnits
WHERE     (Rank = @RANK)
ORDER BY GeoPoliticalName





GO

-- ----------------------------
-- Procedure structure for GetGeoPolUnitsBySiteID
-- ----------------------------


CREATE PROCEDURE [GetGeoPolUnitsBySiteID](@SITEID int)
AS SELECT      NDB.GeoPoliticalUnits.GeoPoliticalID, NDB.GeoPoliticalUnits.GeoPoliticalName, NDB.GeoPoliticalUnits.GeoPoliticalUnit, 
                        NDB.GeoPoliticalUnits.Rank, NDB.GeoPoliticalUnits.HigherGeoPoliticalID
FROM          NDB.SiteGeoPolitical INNER JOIN
                        NDB.GeoPoliticalUnits ON NDB.SiteGeoPolitical.GeoPoliticalID = NDB.GeoPoliticalUnits.GeoPoliticalID
WHERE      (NDB.SiteGeoPolitical.SiteID = @SITEID)
ORDER BY NDB.GeoPoliticalUnits.Rank




GO

-- ----------------------------
-- Procedure structure for GetInvalidTaxaByTaxaGroupID
-- ----------------------------




CREATE PROCEDURE [GetInvalidTaxaByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, ValidatorID, 
               CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 0) AND (TaxaGroupID = @TAXAGROUPID)






GO

-- ----------------------------
-- Procedure structure for GetInvalidTaxaByTaxaGroupIDList
-- ----------------------------



CREATE PROCEDURE [GetInvalidTaxaByTaxaGroupIDList](@TAXAGROUPLIST nvarchar(MAX))
AS
SELECT     TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
           ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 0) AND (TaxaGroupID IN (
		                    SELECT Value
		                    FROM TI.func_NvarcharListToIN(@TAXAGROUPLIST,'$')             
                            ))
                                     




GO

-- ----------------------------
-- Procedure structure for GetInvalidTaxonByName
-- ----------------------------


CREATE PROCEDURE [GetInvalidTaxonByName](@TAXONNAME nvarchar(80))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
               ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 0) AND (NDB.Taxa.TaxonName LIKE @TAXONNAME)







GO

-- ----------------------------
-- Procedure structure for GetInvalidTaxonSynonymyCount
-- ----------------------------


CREATE PROCEDURE [GetInvalidTaxonSynonymyCount](@REFTAXONID int)
AS 
SELECT     COUNT(RefTaxonID) AS Count
FROM         NDB.Synonymy
WHERE     (RefTaxonID = @REFTAXONID)





GO

-- ----------------------------
-- Procedure structure for GetInvestigator
-- ----------------------------






CREATE PROCEDURE [GetInvestigator](@DATASETID int)
AS 
SELECT     NDB.Contacts.ContactID, NDB.Contacts.AliasID, NDB.Contacts.ContactName, NDB.Contacts.ContactStatusID, NDB.Contacts.FamilyName, 
                      NDB.Contacts.LeadingInitials, NDB.Contacts.GivenNames, NDB.Contacts.Suffix, NDB.Contacts.Title, NDB.Contacts.Phone, NDB.Contacts.Fax, NDB.Contacts.Email, 
                      NDB.Contacts.URL, NDB.Contacts.Address, NDB.Contacts.Notes
FROM         NDB.DatasetPIs INNER JOIN
                      NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
WHERE     (NDB.DatasetPIs.DatasetID = @DATASETID)








GO

-- ----------------------------
-- Procedure structure for GetIsoBioMarkers
-- ----------------------------






CREATE PROCEDURE [GetIsoBioMarkers]
AS 
SELECT     TOP (100) PERCENT NDB.IsoBioMarkerTypes.IsoBioMarkerType, NDB.IsoBioMarkerBandTypes.IsoBioMarkerBandType
FROM         NDB.IsoBioMarkerTypes INNER JOIN
                      NDB.IsoBioMarkerBandTypes ON NDB.IsoBioMarkerTypes.IsoBioMarkerTypeID = NDB.IsoBioMarkerBandTypes.IsoBioMarkerTypeID
ORDER BY NDB.IsoBioMarkerTypes.IsoBioMarkerType, NDB.IsoBioMarkerBandTypes.IsoBioMarkerBandType

GO

-- ----------------------------
-- Procedure structure for GetIsoInstrumentationTypes
-- ----------------------------


CREATE PROCEDURE [GetIsoInstrumentationTypes]
AS 
SELECT     IsoInstrumentationTypeID, IsoInstrumentationType
FROM         NDB.IsoInstrumentationTypes
GO

-- ----------------------------
-- Procedure structure for GetIsoMaterialAnalyzedAndSubstrate
-- ----------------------------





CREATE PROCEDURE [GetIsoMaterialAnalyzedAndSubstrate]
AS 
SELECT     TOP (100) PERCENT NDB.IsoMaterialAnalyzedTypes.IsoMaterialAnalyzedType, NDB.IsoSubstrateTypes.IsoSubstrateType
FROM         NDB.IsoMaterialAnalyzedTypes INNER JOIN
                      NDB.IsoMatAnalSubstrate ON NDB.IsoMaterialAnalyzedTypes.IsoMatAnalTypeID = NDB.IsoMatAnalSubstrate.IsoMatAnalTypeID INNER JOIN
                      NDB.IsoSubstrateTypes ON NDB.IsoMatAnalSubstrate.IsoSubstrateTypeID = NDB.IsoSubstrateTypes.IsoSubstrateTypeID
ORDER BY NDB.IsoMaterialAnalyzedTypes.IsoMaterialAnalyzedType, NDB.IsoSubstrateTypes.IsoSubstrateType



GO

-- ----------------------------
-- Procedure structure for GetIsoMaterialAnalyzedTypes
-- ----------------------------



CREATE PROCEDURE [GetIsoMaterialAnalyzedTypes]
AS 
SELECT     IsoMatAnalTypeID, IsoMaterialAnalyzedType
FROM         NDB.IsoMaterialAnalyzedTypes




GO

-- ----------------------------
-- Procedure structure for GetIsoPretreatmentTypes
-- ----------------------------






CREATE PROCEDURE [GetIsoPretreatmentTypes]
AS 
SELECT     IsoPretreatmentTypeID, IsoPretreatmentType, IsoPretreatmentQualifier
FROM         NDB.IsoPretratmentTypes







GO

-- ----------------------------
-- Procedure structure for GetIsoSampleIntroSystemTypes
-- ----------------------------








CREATE PROCEDURE [GetIsoSampleIntroSystemTypes]
AS 
SELECT     IsoSampleIntroSystemTypeID, IsoSampleIntroSystemType
FROM         NDB.IsoSampleIntroSystemTypes









GO

-- ----------------------------
-- Procedure structure for GetIsoSampleOriginTypes
-- ----------------------------







CREATE PROCEDURE [GetIsoSampleOriginTypes]
AS 
SELECT     IsoSampleOriginTypeID, IsoSampleOriginType
FROM         NDB.IsoSampleOriginTypes








GO

-- ----------------------------
-- Procedure structure for GetIsoStandardTypes
-- ----------------------------




CREATE PROCEDURE [GetIsoStandardTypes]
AS 
SELECT     IsoStandardTypeID, IsoStandardType, IsoStandardMaterial
FROM         NDB.IsoStandardTypes










GO

-- ----------------------------
-- Procedure structure for GetIsoSubstrates
-- ----------------------------



CREATE PROCEDURE [GetIsoSubstrates]
AS 
SELECT     TOP (100) PERCENT NDB.IsoSubstrateTypes.IsoSubstrateTypeID, NDB.IsoMaterialAnalyzedTypes.IsoMatAnalTypeID, NDB.IsoSubstrateTypes.IsoSubstrateType
FROM         NDB.IsoMaterialAnalyzedTypes INNER JOIN
                      NDB.IsoMatAnalSubstrate ON NDB.IsoMaterialAnalyzedTypes.IsoMatAnalTypeID = NDB.IsoMatAnalSubstrate.IsoMatAnalTypeID INNER JOIN
                      NDB.IsoSubstrateTypes ON NDB.IsoMatAnalSubstrate.IsoSubstrateTypeID = NDB.IsoSubstrateTypes.IsoSubstrateTypeID
ORDER BY NDB.IsoSubstrateTypes.IsoSubstrateTypeID


GO

-- ----------------------------
-- Procedure structure for GetIsoVariableScaleIDs
-- ----------------------------




CREATE PROCEDURE [GetIsoVariableScaleIDs]
AS 
SELECT     NDB.Taxa.TaxonName AS IsoVariable, NDB.IsoVariableScaleTypes.IsoScaleTypeID, NDB.IsoScaleTypes.IsoScaleAcronym
FROM         NDB.IsoVariableScaleTypes INNER JOIN
                      NDB.IsoScaleTypes ON NDB.IsoVariableScaleTypes.IsoScaleTypeID = NDB.IsoScaleTypes.IsoScaleTypeID INNER JOIN
                      NDB.Taxa INNER JOIN
                      NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID ON NDB.IsoVariableScaleTypes.VariableID = NDB.Variables.VariableID
ORDER BY IsoVariable

GO

-- ----------------------------
-- Procedure structure for GetIsoVariableScaleTypes
-- ----------------------------



CREATE PROCEDURE [GetIsoVariableScaleTypes]
AS 
SELECT     TOP (100) PERCENT NDB.Taxa.TaxonName AS IsoVariable, NDB.IsoScaleTypes.IsoScaleAcronym
FROM         NDB.IsoVariableScaleTypes INNER JOIN
                      NDB.IsoScaleTypes ON NDB.IsoVariableScaleTypes.IsoScaleTypeID = NDB.IsoScaleTypes.IsoScaleTypeID INNER JOIN
                      NDB.Taxa INNER JOIN
                      NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID ON NDB.IsoVariableScaleTypes.VariableID = NDB.Variables.VariableID
ORDER BY NDB.Taxa.TaxonName, NDB.IsoScaleTypes.IsoScaleAcronym


GO

-- ----------------------------
-- Procedure structure for GetKeywordsTable
-- ----------------------------


CREATE PROCEDURE [GetKeywordsTable]
AS SELECT     KeywordID, Keyword
FROM          NDB.Keywords





GO

-- ----------------------------
-- Procedure structure for GetLakeParameterTypesTable
-- ----------------------------


CREATE PROCEDURE [GetLakeParameterTypesTable]
AS SELECT      *
FROM          NDB.LakeParameterTypes




GO

-- ----------------------------
-- Procedure structure for GetLakeParamsBySiteID
-- ----------------------------



CREATE PROCEDURE [GetLakeParamsBySiteID](@SITEID int)
AS 
SELECT     NDB.LakeParameterTypes.LakeParameter, NDB.LakeParameters.Value
FROM         NDB.LakeParameters INNER JOIN
                      NDB.LakeParameterTypes ON NDB.LakeParameters.LakeParameterID = NDB.LakeParameterTypes.LakeParameterID
WHERE     (NDB.LakeParameters.SiteID = @SITEID)
ORDER BY NDB.LakeParameterTypes.LakeParameter




GO

-- ----------------------------
-- Procedure structure for GetLithologyByCollUnitID
-- ----------------------------



CREATE PROCEDURE [GetLithologyByCollUnitID](@COLLUNITID int)
AS 
SELECT    LithologyID, DepthTop, DepthBottom, LowerBoundary, Description
FROM      NDB.Lithology
WHERE     (CollectionUnitID = @COLLUNITID)

GO

-- ----------------------------
-- Procedure structure for GetMaxPubIDByPubIDType
-- ----------------------------




CREATE PROCEDURE [GetMaxPubIDByPubIDType](@PUBTYPEID int)
AS 
SELECT     MAX(PublicationID) AS MaxPubID
FROM         NDB.Publications
GROUP BY PubTypeID
HAVING      (PubTypeID = @PUBTYPEID)






GO

-- ----------------------------
-- Procedure structure for GetMinPubIDByPubIDType
-- ----------------------------




CREATE PROCEDURE [GetMinPubIDByPubIDType](@PUBTYPEID int)
AS 
SELECT     MIN(PublicationID) AS MinPubID
FROM         NDB.Publications
GROUP BY PubTypeID
HAVING      (PubTypeID = @PUBTYPEID)






GO

-- ----------------------------
-- Procedure structure for GetNearestSites
-- ----------------------------

CREATE PROCEDURE [GetNearestSites](@EAST float, @NORTH float, @WEST float, @SOUTH float, @DISTKM float)
AS 
DECLARE @DISTM int = 1000*@DISTKM
DECLARE @SITE1 geography
IF ((@NORTH > @SOUTH) AND (@EAST > @WEST))
  SET @SITE1 = geography::STGeomFromText('POLYGON((' + 
               CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
               CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			   CAST(CAST(@EAST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			   CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ', ' +
			   CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@SOUTH AS decimal(20,15)) AS varchar(20)) + '))', 4326)
ELSE
  SET @SITE1 = geography::STGeomFromText('POINT(' + CAST(CAST(@WEST AS decimal(20,15)) AS varchar(20)) + ' ' + CAST(CAST(@NORTH AS decimal(20,15)) AS varchar(20)) + ')', 4326)  

SELECT     NDB.Sites.SiteID, NDB.Sites.SiteName, @SITE1.EnvelopeCenter().STDistance(geog.EnvelopeCenter())/1000 AS DistKm,
           TI.GeoPol1.GeoPolName1 + 
           IIF(TI.GeoPol2.GeoPolName2 IS NOT NULL, N'|' + TI.GeoPol2.GeoPolName2 + 
		       IIF(TI.GeoPol3.GeoPolName3 IS NOT NULL, N'|' + TI.GeoPol3.GeoPolName3, N'') + 
			   IIF(TI.GeoPol4.GeoPolName4 IS NOT NULL, N'|' + TI.GeoPol4.GeoPolName4, N''),N'') AS Geopolitical
FROM       NDB.Sites LEFT OUTER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID LEFT OUTER JOIN
                      TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID LEFT OUTER JOIN
                      TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                      TI.GeoPol4 ON NDB.Sites.SiteID = TI.GeoPol4.SiteID 
WHERE  @SITE1.EnvelopeCenter().STDistance(geog.EnvelopeCenter()) <= @DISTM
ORDER BY DistKm

GO

-- ----------------------------
-- Procedure structure for GetNextLowerGeoPolCountByNames
-- ----------------------------




CREATE PROCEDURE [GetNextLowerGeoPolCountByNames](@NAME1 nvarchar(255), @RANK1 int, @NAME2 nvarchar(255), @RANK2 int)
AS 
SELECT     COUNT(GeoPoliticalUnits_1.GeoPoliticalName) AS Count
FROM         NDB.GeoPoliticalUnits INNER JOIN
                      NDB.GeoPoliticalUnits AS GeoPoliticalUnits_1 ON NDB.GeoPoliticalUnits.GeoPoliticalID = GeoPoliticalUnits_1.HigherGeoPoliticalID
WHERE     (NDB.GeoPoliticalUnits.GeoPoliticalName = @NAME1) AND (NDB.GeoPoliticalUnits.Rank = @RANK1) AND 
                      (GeoPoliticalUnits_1.GeoPoliticalName = @NAME2) AND (GeoPoliticalUnits_1.Rank = @RANK2) 
                      






GO

-- ----------------------------
-- Procedure structure for GetNextPublicationByID
-- ----------------------------



CREATE PROCEDURE [GetNextPublicationByID](@PUBLICATIONID int)
AS 

DECLARE @NEXTPUBID int;
SELECT  @NEXTPUBID = MIN(PublicationID) 
FROM         NDB.Publications
WHERE     (PublicationID > @PUBLICATIONID)

SELECT      NDB.Publications.*
FROM          NDB.Publications
WHERE      (PublicationID = @NEXTPUBID)





GO

-- ----------------------------
-- Procedure structure for GetNextPublicationByIDAndPubTypeID
-- ----------------------------




CREATE PROCEDURE [GetNextPublicationByIDAndPubTypeID](@PUBLICATIONID int, @PUBTYPEID int)
AS 

DECLARE @NEXTPUBID int;
SELECT  @NEXTPUBID = MIN(PublicationID) 
FROM         NDB.Publications
WHERE     (PublicationID > @PUBLICATIONID AND PubTypeID = @PUBTYPEID)

SELECT      NDB.Publications.*
FROM          NDB.Publications
WHERE      (PublicationID = @NEXTPUBID)






GO

-- ----------------------------
-- Procedure structure for GetPollenSporeHigherTaxa
-- ----------------------------



CREATE PROCEDURE [GetPollenSporeHigherTaxa](@TAXAIDLIST nvarchar(MAX))
AS 
DECLARE @PlantTaxa TABLE (ID int NOT NULL primary key identity(1,1), TaxonID int, HigherTaxonID int)

INSERT INTO @PlantTaxa (TaxonID) SELECT Value FROM TI.func_NvarcharListToIN(@TAXAIDLIST,'$')

DECLARE @NRows int = @@ROWCOUNT
DECLARE @TAXONID int
DECLARE @NEXTTAXONID int
DECLARE @HIGHERID int
DECLARE @Spermatophyta int = 5480
DECLARE @Tracheophyta int = 9534
DECLARE @Embryophyta int = 33038
DECLARE @CurrentID int = 0
WHILE @CurrentID < @NRows
  BEGIN
    SET @CurrentID = @CurrentID+1
	SET @TAXONID = (SELECT TaxonID FROM @PlantTaxa WHERE (ID = @CurrentID)) 
	SET @NEXTTAXONID = @TAXONID
    SET @HIGHERID = (SELECT HigherTaxonID FROM NDB.Taxa WHERE (TaxonID = @TAXONID))
    WHILE @NEXTTAXONID <> @HIGHERID AND @NEXTTAXONID <> @Spermatophyta AND @NEXTTAXONID <> @Tracheophyta AND @NEXTTAXONID <> @Embryophyta
      BEGIN
        SET @NEXTTAXONID = (SELECT TaxonID FROM NDB.Taxa WHERE (TaxonID = @HIGHERID)) 
        SET @HIGHERID = (SELECT HigherTaxonID FROM NDB.Taxa WHERE (TaxonID = @NEXTTAXONID))
      END
	UPDATE @PlantTaxa
    SET    HigherTaxonID = @NEXTTAXONID
    WHERE  TaxonID = @TAXONID
  END

SELECT TaxonID, HigherTaxonID FROM @PlantTaxa




GO

-- ----------------------------
-- Procedure structure for GetPredefinedTaxaEcolGroupsByDatasetTypeList
-- ----------------------------




CREATE PROCEDURE [GetPredefinedTaxaEcolGroupsByDatasetTypeList](@DATASETTYPEIDS nvarchar(MAX))
AS 
SELECT     TOP (2147483647) NDB.DatasetTaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroups.EcolGroupID, 
                      NDB.EcolGroupTypes.EcolGroup
FROM         NDB.DatasetTaxaGroupTypes INNER JOIN
                      NDB.Taxa ON NDB.DatasetTaxaGroupTypes.TaxaGroupID = NDB.Taxa.TaxaGroupID INNER JOIN
                      NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
                      NDB.TaxaGroupTypes ON NDB.DatasetTaxaGroupTypes.TaxaGroupID = NDB.TaxaGroupTypes.TaxaGroupID INNER JOIN
                      NDB.EcolGroupTypes ON NDB.EcolGroups.EcolGroupID = NDB.EcolGroupTypes.EcolGroupID
WHERE     (NDB.DatasetTaxaGroupTypes.DatasetTypeID IN (
                                                      SELECT Value
                                                      FROM TI.func_IntListToIN(@DATASETTYPEIDS,',') 
                                                      ))
GROUP BY NDB.DatasetTaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroups.EcolGroupID, NDB.EcolGroupTypes.EcolGroup
ORDER BY NDB.DatasetTaxaGroupTypes.TaxaGroupID







GO

-- ----------------------------
-- Procedure structure for GetPreviousPublicationByID
-- ----------------------------




CREATE PROCEDURE [GetPreviousPublicationByID](@PUBLICATIONID int)
AS 

DECLARE @PREVIOUSPUBID int;
SELECT  @PREVIOUSPUBID = MAX(PublicationID) 
FROM         NDB.Publications
WHERE     (PublicationID < @PUBLICATIONID)

SELECT      NDB.Publications.*
FROM          NDB.Publications
WHERE      (PublicationID = @PREVIOUSPUBID)






GO

-- ----------------------------
-- Procedure structure for GetPreviousPublicationByIDAndPubTypeID
-- ----------------------------





CREATE PROCEDURE [GetPreviousPublicationByIDAndPubTypeID](@PUBLICATIONID int, @PUBTYPEID int)
AS 

DECLARE @PREVIOUSPUBID int;
SELECT  @PREVIOUSPUBID = MAX(PublicationID) 
FROM         NDB.Publications
WHERE     (PublicationID < @PUBLICATIONID AND PubTypeID = @PUBTYPEID)

SELECT      NDB.Publications.*
FROM          NDB.Publications
WHERE      (PublicationID = @PREVIOUSPUBID)







GO

-- ----------------------------
-- Procedure structure for GetPublicationAuthors
-- ----------------------------


CREATE PROCEDURE [GetPublicationAuthors](@PUBLICATIONID int)
AS SELECT      AuthorID, PublicationID, AuthorOrder, FamilyName, Initials, Suffix, ContactID
FROM          NDB.PublicationAuthors
WHERE      (PublicationID = @PUBLICATIONID)
ORDER BY AuthorOrder




GO

-- ----------------------------
-- Procedure structure for GetPublicationByCitation
-- ----------------------------

CREATE PROCEDURE [GetPublicationByCitation](@CITATION nvarchar(MAX))
AS SELECT      PublicationID, PubTypeID, Year, Citation, ArticleTitle, Journal, Volume, Issue, Pages, CitationNumber, DOI, BookTitle, NumVolumes, Edition,
VolumeTitle, SeriesTitle, SeriesVolume, Publisher, URL, City, State, Country, 
OriginalLanguage, Notes
FROM          NDB.Publications
WHERE      (Citation LIKE @CITATION)



GO

-- ----------------------------
-- Procedure structure for GetPublicationByDatasetID
-- ----------------------------


CREATE PROCEDURE [GetPublicationByDatasetID](@DATASETID int)
AS 
SELECT     NDB.Datasets.DatasetID, NDB.Publications.PublicationID, NDB.Publications.Citation
FROM         NDB.Datasets INNER JOIN
                      NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                      NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.Datasets.DatasetID = @DATASETID)





GO

-- ----------------------------
-- Procedure structure for GetPublicationByFamilyName
-- ----------------------------

CREATE PROCEDURE [GetPublicationByFamilyName](@FAMILYNAME nvarchar(80))
AS SELECT     NDB.Publications.*
FROM         NDB.PublicationAuthors INNER JOIN
                      NDB.Contacts ON NDB.PublicationAuthors.ContactID = NDB.Contacts.ContactID INNER JOIN
                      NDB.Publications ON NDB.PublicationAuthors.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.Contacts.FamilyName LIKE @FAMILYNAME) OR
                      (NDB.PublicationAuthors.FamilyName LIKE @FAMILYNAME)



GO

-- ----------------------------
-- Procedure structure for GetPublicationByID
-- ----------------------------


CREATE PROCEDURE [GetPublicationByID](@PUBLICATIONID int)
AS 
SELECT     PublicationID, PubTypeID, Year, Citation, ArticleTitle, Journal, Volume, Issue, Pages, CitationNumber, DOI, BookTitle, NumVolumes, Edition, VolumeTitle, SeriesTitle, 
                      SeriesVolume, Publisher, URL, City, State, Country, OriginalLanguage, Notes
FROM         NDB.Publications
WHERE      (PublicationID = @PUBLICATIONID)




GO

-- ----------------------------
-- Procedure structure for GetPublicationByIDList
-- ----------------------------



CREATE PROCEDURE [GetPublicationByIDList](@PUBLICATIONIDLIST nvarchar(MAX))
AS 
SELECT     PublicationID, PubTypeID, Year, Citation, ArticleTitle, Journal, Volume, Issue, Pages, CitationNumber, DOI, BookTitle, NumVolumes, Edition, VolumeTitle, SeriesTitle, 
                      SeriesVolume, Publisher, URL, City, State, Country, OriginalLanguage, Notes
FROM         NDB.Publications
WHERE (PublicationID IN (
		             SELECT Value
		             FROM TI.func_NvarcharListToIN(@PUBLICATIONIDLIST,'$')
                     ))





GO

-- ----------------------------
-- Procedure structure for GetPublicationEditors
-- ----------------------------


CREATE PROCEDURE [GetPublicationEditors](@PUBLICATIONID int)
AS SELECT      EditorID, PublicationID, EditorOrder, FamilyName, Initials, Suffix
FROM          NDB.PublicationEditors
WHERE      (PublicationID = @PUBLICATIONID)
ORDER BY EditorOrder




GO

-- ----------------------------
-- Procedure structure for GetPublicationsByContactID
-- ----------------------------


CREATE PROCEDURE [GetPublicationsByContactID](@CONTACTID int)
AS SELECT     NDB.Publications.*
FROM         NDB.Contacts INNER JOIN
                      NDB.PublicationAuthors ON NDB.Contacts.ContactID = NDB.PublicationAuthors.ContactID INNER JOIN
                      NDB.Publications ON NDB.PublicationAuthors.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.Contacts.ContactID = @CONTACTID)




GO

-- ----------------------------
-- Procedure structure for GetPublicationsByGeochronID
-- ----------------------------




CREATE PROCEDURE [GetPublicationsByGeochronID](@GEOCHRONIDLIST nvarchar(MAX))
AS 
SELECT     GeochronID, PublicationID
FROM         NDB.GeochronPublications
WHERE (GeochronID IN (
		             SELECT Value
		             FROM TI.func_NvarcharListToIN(@GEOCHRONIDLIST,'$')
                     ))

 


GO

-- ----------------------------
-- Procedure structure for GetPublicationsTable
-- ----------------------------

CREATE PROCEDURE [GetPublicationsTable]
AS SELECT      *
FROM          NDB.Publications



GO

-- ----------------------------
-- Procedure structure for GetPublicationTranslators
-- ----------------------------



CREATE PROCEDURE [GetPublicationTranslators](@PUBLICATIONID int)
AS SELECT      NDB.PublicationTranslators.*
FROM          NDB.PublicationTranslators
WHERE      (PublicationID = @PUBLICATIONID)
ORDER BY TranslatorOrder





GO

-- ----------------------------
-- Procedure structure for GetPublicationTypesTable
-- ----------------------------

CREATE PROCEDURE [GetPublicationTypesTable]
AS SELECT      *
FROM          NDB.PublicationTypes



GO

-- ----------------------------
-- Procedure structure for GetRadiocarbonByGeochronID
-- ----------------------------




CREATE PROCEDURE [GetRadiocarbonByGeochronID](@GEOCHRONIDLIST nvarchar(MAX))
AS 
SELECT     NDB.Radiocarbon.GeochronID, NDB.RadiocarbonMethods.RadiocarbonMethod, NDB.Radiocarbon.PercentC, NDB.Radiocarbon.PercentN, NDB.Radiocarbon.CNRatio, 
                      NDB.Radiocarbon.Delta13C, NDB.Radiocarbon.Delta15N, NDB.Radiocarbon.PercentCollagen, NDB.Radiocarbon.Reservoir
FROM         NDB.Radiocarbon INNER JOIN
                      NDB.RadiocarbonMethods ON NDB.Radiocarbon.RadiocarbonMethodID = NDB.RadiocarbonMethods.RadiocarbonMethodID
WHERE (GeochronID IN (
		             SELECT Value
		             FROM TI.func_NvarcharListToIN(@GEOCHRONIDLIST,'$')
                     ))

 


GO

-- ----------------------------
-- Procedure structure for GetRadiocarbonMethodID
-- ----------------------------





CREATE PROCEDURE [GetRadiocarbonMethodID](@RADIOCARBONMETHOD nvarchar(64))
AS 
SELECT     RadiocarbonMethodID
FROM       NDB.RadiocarbonMethods
WHERE     (RadiocarbonMethod = @RADIOCARBONMETHOD)







GO

-- ----------------------------
-- Procedure structure for GetRadiocarbonMethodsTable
-- ----------------------------



CREATE PROCEDURE [GetRadiocarbonMethodsTable]
AS SELECT     RadiocarbonMethodID, RadiocarbonMethod 
FROM          NDB.RadiocarbonMethods








GO

-- ----------------------------
-- Procedure structure for GetRecentUploads
-- ----------------------------



CREATE PROCEDURE [GetRecentUploads](@MONTHS int, @DATABASEID int = NULL, @DATASETTYPEID int = NULL)
AS 

DECLARE @NewDatasets TABLE (ID int NOT NULL primary key identity(1,1),
                            DatasetID int, 
                            DatasetType nvarchar(64), 
							SiteName nvarchar(128), 
							GeoPol1 nvarchar(255), 
							GeoPol2 nvarchar(255), 
							GeoPol3 nvarchar(255),
							DatabaseName nvarchar(80), 
							Investigator nvarchar(MAX), 
							RecDateCreated nvarchar(10),
							Steward nvarchar(80))

INSERT INTO @NewDatasets (DatasetID, DatasetType, SiteName, GeoPol1, GeoPol2, GeoPol3, DatabaseName, RecDateCreated, Steward)
SELECT TOP (100) PERCENT NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType, NDB.Sites.SiteName, TI.GeoPol1.GeoPolName1, TI.GeoPol2.GeoPolName2, 
                 TI.GeoPol3.GeoPolName3, NDB.ConstituentDatabases.DatabaseName, Convert(Date,NDB.Datasets.RecDateCreated) as RecDateCreated, 
				 NDB.Contacts.ContactName AS Steward
FROM         NDB.Datasets INNER JOIN
                      NDB.DatasetTypes ON NDB.DatasetTypes.DatasetTypeID = NDB.Datasets.DatasetTypeID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID INNER JOIN
                      NDB.DatasetSubmissions ON NDB.Datasets.DatasetID = NDB.DatasetSubmissions.DatasetID INNER JOIN
                      NDB.ConstituentDatabases ON NDB.DatasetSubmissions.DatabaseID = NDB.ConstituentDatabases.DatabaseID INNER JOIN
                      NDB.Contacts ON NDB.DatasetSubmissions.ContactID = NDB.Contacts.ContactID LEFT OUTER JOIN
                      TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                      TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID
WHERE (
      (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
      (@DATABASEID IS NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NULL AND @DATASETTYPEID IS NULL AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE()))
	  )
ORDER BY NDB.Datasets.RecDateCreated DESC

DECLARE @NRows int = @@ROWCOUNT

DECLARE @NewDatasetPIs TABLE (DatasetID int)

INSERT INTO @NewDatasetPIs (DatasetID)
SELECT      [@NewDatasets].[DatasetID]
FROM        @NewDatasets INNER JOIN
                      NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
                      NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID

DECLARE @PIs TABLE (ContactID int NOT NULL primary key identity(1,1), ContactName nvarchar(96), PIOrder int, Processed int NOT NULL default 0)
DECLARE @CurrentID int = 0
DECLARE @PIID int
DECLARE @ContactName nvarchar(MAX)
DECLARE @CurrentName nvarchar(96)
DECLARE @NContactRows int
WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	INSERT INTO @PIs (ContactName, PIOrder)
    SELECT CONCAT(NDB.Contacts.LeadingInitials,N' ',NDB.Contacts.FamilyName), NDB.DatasetPIs.PIOrder
    FROM   @NewDatasets INNER JOIN
              NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
              NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
	WHERE  ([@NewDatasets].[ID] = @CurrentID)
	ORDER BY NDB.DatasetPIs.PIOrder
	SET @NContactRows = @@ROWCOUNT
	SET @ContactName = NULL
	WHILE (SELECT COUNT(*) FROM @PIs WHERE Processed = 0) > 0
	  BEGIN
	    SELECT TOP 1 @PIID = ContactID, @CurrentName = ContactName 
		FROM @PIs 
		WHERE Processed = 0
		IF @ContactName IS NULL
		  SET @ContactName = @CurrentName
		ELSE
		  SET @ContactName = @ContactName + N', ' + @CurrentName 
		UPDATE @PIs 
		SET Processed = 1 WHERE ContactID = @PIID
	  END
    UPDATE @NewDatasets
    SET [@NewDatasets].[Investigator] = @ContactName
	WHERE ([@NewDatasets].[ID] = @CurrentID)  
  END

SELECT Top 400 DatasetID,
       DatasetType,
	   SiteName,
	   CASE WHEN GeoPol2 IS NULL THEN GeoPol1
	        WHEN GeoPol3 IS NULL THEN CONCAT(GeoPol1,N' | ',GeoPol2)
	                             ELSE CONCAT(GeoPol1,N' | ',GeoPol2,N' | ',GeoPol3)
       END AS GeoPolitical,
	   DatabaseName,
	   Investigator,
	   RecDateCreated,
	   Steward
FROM   @NewDatasets






GO

-- ----------------------------
-- Procedure structure for GetRecentUploadsv1
-- ----------------------------


CREATE PROCEDURE [GetRecentUploadsv1](@MONTHS int, @DATABASEID int = NULL, @DATASETTYPEID int = NULL)
AS 

DECLARE @NewDatasets TABLE (ID int NOT NULL primary key identity(1,1),
                            DatasetID int, 
                            DatasetType nvarchar(64), 
							SiteName nvarchar(128), 
							GeoPol1 nvarchar(255), 
							GeoPol2 nvarchar(255), 
							GeoPol3 nvarchar(255),
							DatabaseName nvarchar(80), 
							Investigator nvarchar(MAX), 
							RecDateCreated nvarchar(10),
							Steward nvarchar(80))

INSERT INTO @NewDatasets (DatasetID, DatasetType, SiteName, GeoPol1, GeoPol2, GeoPol3, DatabaseName, RecDateCreated, Steward)
SELECT TOP (100) PERCENT NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType, NDB.Sites.SiteName, TI.GeoPol1.GeoPolName1, TI.GeoPol2.GeoPolName2, 
                 TI.GeoPol3.GeoPolName3, NDB.ConstituentDatabases.DatabaseName, Convert(Date,NDB.Datasets.RecDateCreated) as RecDateCreated, 
				 NDB.Contacts.ContactName AS Steward
FROM         NDB.Datasets INNER JOIN
                      NDB.DatasetTypes ON NDB.DatasetTypes.DatasetTypeID = NDB.Datasets.DatasetTypeID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID INNER JOIN
                      NDB.DatasetSubmissions ON NDB.Datasets.DatasetID = NDB.DatasetSubmissions.DatasetID INNER JOIN
                      NDB.ConstituentDatabases ON NDB.DatasetSubmissions.DatabaseID = NDB.ConstituentDatabases.DatabaseID INNER JOIN
                      NDB.Contacts ON NDB.DatasetSubmissions.ContactID = NDB.Contacts.ContactID LEFT OUTER JOIN
                      TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                      TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID
WHERE (
      (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
      (@DATABASEID IS NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NULL AND @DATASETTYPEID IS NULL AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE()))
	  )
ORDER BY NDB.Datasets.RecDateCreated DESC

DECLARE @NRows int = @@ROWCOUNT

DECLARE @NewDatasetPIs TABLE (DatasetID int)

INSERT INTO @NewDatasetPIs (DatasetID)
SELECT      [@NewDatasets].[DatasetID]
FROM        @NewDatasets INNER JOIN
                      NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
                      NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID

DECLARE @PIs TABLE (ContactID int NOT NULL primary key identity(1,1), ContactName nvarchar(96), PIOrder int, Processed int NOT NULL default 0)
DECLARE @CurrentID int = 0
DECLARE @PIID int
DECLARE @ContactName nvarchar(MAX)
DECLARE @CurrentName nvarchar(96)
DECLARE @NContactRows int
WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	INSERT INTO @PIs (ContactName, PIOrder)
    SELECT CONCAT(NDB.Contacts.LeadingInitials,N' ',NDB.Contacts.FamilyName), NDB.DatasetPIs.PIOrder
    FROM   @NewDatasets INNER JOIN
              NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
              NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
	WHERE  ([@NewDatasets].[ID] = @CurrentID)
	ORDER BY NDB.DatasetPIs.PIOrder
	SET @NContactRows = @@ROWCOUNT
	SET @ContactName = NULL
	WHILE (SELECT COUNT(*) FROM @PIs WHERE Processed = 0) > 0
	  BEGIN
	    SELECT TOP 1 @PIID = ContactID, @CurrentName = ContactName 
		FROM @PIs 
		WHERE Processed = 0
		IF @ContactName IS NULL
		  SET @ContactName = @CurrentName
		ELSE
		  SET @ContactName = @ContactName + N', ' + @CurrentName 
		UPDATE @PIs 
		SET Processed = 1 WHERE ContactID = @PIID
	  END
    UPDATE @NewDatasets
    SET [@NewDatasets].[Investigator] = @ContactName
	WHERE ([@NewDatasets].[ID] = @CurrentID)  
  END

SELECT DatasetID,
       DatasetType,
	   SiteName,
	   CASE WHEN GeoPol2 IS NULL THEN GeoPol1
	        WHEN GeoPol3 IS NULL THEN CONCAT(GeoPol1,N' | ',GeoPol2)
	                             ELSE CONCAT(GeoPol1,N' | ',GeoPol2,N' | ',GeoPol3)
       END AS GeoPolitical,
	   DatabaseName,
	   Investigator,
	   RecDateCreated,
	   Steward
FROM   @NewDatasets





GO

-- ----------------------------
-- Procedure structure for GetRecentUploadsv2
-- ----------------------------


CREATE PROCEDURE [GetRecentUploadsv2](@MONTHS int, @DATABASEID int = NULL, @DATASETTYPEID int = NULL)
AS 

DECLARE @NewDatasets TABLE (ID int NOT NULL primary key identity(1,1),
                            DatasetID int, 
                            DatasetType nvarchar(64), 
							SiteName nvarchar(128), 
							GeoPol1 nvarchar(255), 
							GeoPol2 nvarchar(255), 
							GeoPol3 nvarchar(255),
							DatabaseName nvarchar(80), 
							Investigator nvarchar(MAX), 
							RecDateCreated nvarchar(10),
							Steward nvarchar(80))

INSERT INTO @NewDatasets (DatasetID, DatasetType, SiteName, GeoPol1, GeoPol2, GeoPol3, DatabaseName, RecDateCreated, Steward)
SELECT TOP (100) PERCENT NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType, NDB.Sites.SiteName, TI.GeoPol1.GeoPolName1, TI.GeoPol2.GeoPolName2, 
                 TI.GeoPol3.GeoPolName3, NDB.ConstituentDatabases.DatabaseName, Convert(Date,NDB.Datasets.RecDateCreated) as RecDateCreated, 
				 NDB.Contacts.ContactName AS Steward
FROM         NDB.Datasets INNER JOIN
                      NDB.DatasetTypes ON NDB.DatasetTypes.DatasetTypeID = NDB.Datasets.DatasetTypeID INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                      TI.GeoPol1 ON NDB.Sites.SiteID = TI.GeoPol1.SiteID INNER JOIN
                      NDB.DatasetSubmissions ON NDB.Datasets.DatasetID = NDB.DatasetSubmissions.DatasetID INNER JOIN
                      NDB.ConstituentDatabases ON NDB.DatasetSubmissions.DatabaseID = NDB.ConstituentDatabases.DatabaseID INNER JOIN
                      NDB.Contacts ON NDB.DatasetSubmissions.ContactID = NDB.Contacts.ContactID LEFT OUTER JOIN
                      TI.GeoPol3 ON NDB.Sites.SiteID = TI.GeoPol3.SiteID LEFT OUTER JOIN
                      TI.GeoPol2 ON NDB.Sites.SiteID = TI.GeoPol2.SiteID
WHERE (
      (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NOT NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetSubmissions.DatabaseID = @DATABASEID AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
      (@DATABASEID IS NULL AND @DATASETTYPEID IS NOT NULL AND NDB.DatasetTypes.DatasetTypeID = @DATASETTYPEID AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE())) OR
	  (@DATABASEID IS NULL AND @DATASETTYPEID IS NULL AND NDB.Datasets.RecDateCreated >= DATEADD(month, -@MONTHS, GETDATE()))
	  )
ORDER BY NDB.Datasets.RecDateCreated DESC

DECLARE @NRows int = @@ROWCOUNT

DECLARE @NewDatasetPIs TABLE (DatasetID int)

INSERT INTO @NewDatasetPIs (DatasetID)
SELECT      [@NewDatasets].[DatasetID]
FROM        @NewDatasets INNER JOIN
                      NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
                      NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID

DECLARE @PIs TABLE (ContactID int NOT NULL primary key identity(1,1), ContactName nvarchar(96), PIOrder int, Processed int NOT NULL default 0)
DECLARE @CurrentID int = 0
DECLARE @PIID int
DECLARE @ContactName nvarchar(MAX)
DECLARE @CurrentName nvarchar(96)
DECLARE @NContactRows int
WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	INSERT INTO @PIs (ContactName, PIOrder)
    SELECT CONCAT(NDB.Contacts.LeadingInitials,N' ',NDB.Contacts.FamilyName), NDB.DatasetPIs.PIOrder
    FROM   @NewDatasets INNER JOIN
              NDB.DatasetPIs ON [@NewDatasets].[DatasetID] = NDB.DatasetPIs.DatasetID INNER JOIN
              NDB.Contacts ON NDB.DatasetPIs.ContactID = NDB.Contacts.ContactID
	WHERE  ([@NewDatasets].[ID] = @CurrentID)
	ORDER BY NDB.DatasetPIs.PIOrder
	SET @NContactRows = @@ROWCOUNT
	SET @ContactName = NULL
	WHILE (SELECT COUNT(*) FROM @PIs WHERE Processed = 0) > 0
	  BEGIN
	    SELECT TOP 1 @PIID = ContactID, @CurrentName = ContactName 
		FROM @PIs 
		WHERE Processed = 0
		IF @ContactName IS NULL
		  SET @ContactName = @CurrentName
		ELSE
		  SET @ContactName = @ContactName + N', ' + @CurrentName 
		UPDATE @PIs 
		SET Processed = 1 WHERE ContactID = @PIID
	  END
    UPDATE @NewDatasets
    SET [@NewDatasets].[Investigator] = @ContactName
	WHERE ([@NewDatasets].[ID] = @CurrentID)  
  END

SELECT Top 20 DatasetID,
       DatasetType,
	   SiteName,
	   CASE WHEN GeoPol2 IS NULL THEN GeoPol1
	        WHEN GeoPol3 IS NULL THEN CONCAT(GeoPol1,N' | ',GeoPol2)
	                             ELSE CONCAT(GeoPol1,N' | ',GeoPol2,N' | ',GeoPol3)
       END AS GeoPolitical,
	   DatabaseName,
	   Investigator,
	   RecDateCreated,
	   Steward
FROM   @NewDatasets





GO

-- ----------------------------
-- Procedure structure for GetRelativeAgeByName
-- ----------------------------


CREATE PROCEDURE [GetRelativeAgeByName](@RELATIVEAGE nvarchar(64))
AS 
SELECT     RelativeAgeID, RelativeAgeUnitID, RelativeAgeScaleID, RelativeAge, C14AgeYounger, C14AgeOlder, CalAgeYounger, CalAgeOlder, Notes
FROM         NDB.RelativeAges
WHERE     (RelativeAge = @RELATIVEAGE)



GO

-- ----------------------------
-- Procedure structure for GetRelativeAgeChronControlType
-- ----------------------------



CREATE PROCEDURE [GetRelativeAgeChronControlType](@RELATIVEAGE nvarchar(64))
AS 
SELECT     NDB.ChronControlTypes.ChronControlTypeID, NDB.ChronControlTypes.ChronControlType
FROM         NDB.RelativeAges INNER JOIN
                      NDB.RelativeAgeScales ON NDB.RelativeAges.RelativeAgeScaleID = NDB.RelativeAgeScales.RelativeAgeScaleID INNER JOIN
                      NDB.ChronControlTypes ON NDB.RelativeAgeScales.RelativeAgeScale = NDB.ChronControlTypes.ChronControlType
WHERE     (NDB.RelativeAges.RelativeAge = @RELATIVEAGE)




GO

-- ----------------------------
-- Procedure structure for GetRelativeAgePublications
-- ----------------------------


CREATE PROCEDURE [GetRelativeAgePublications](@RELATIVEAGEID int)
AS 
SELECT      NDB.Publications.PublicationID, NDB.Publications.PubTypeID, NDB.Publications.Year, NDB.Publications.Citation, NDB.Publications.ArticleTitle, 
                      NDB.Publications.Journal, NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, NDB.Publications.CitationNumber, NDB.Publications.DOI, 
                      NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, 
                      NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, NDB.Publications.City, NDB.Publications.State, NDB.Publications.Country, 
                      NDB.Publications.OriginalLanguage, NDB.Publications.Notes
FROM         NDB.RelativeAgePublications INNER JOIN
                      NDB.Publications ON NDB.RelativeAgePublications.PublicationID = NDB.Publications.PublicationID
WHERE     (NDB.RelativeAgePublications.RelativeAgeID = @RELATIVEAGEID)



GO

-- ----------------------------
-- Procedure structure for GetRelativeAgesByChronologyID
-- ----------------------------



CREATE PROCEDURE [GetRelativeAgesByChronologyID](@CHRONOLOGYID int)
AS 
SELECT     NDB.RelativeChronology.ChronControlID, NDB.RelativeAges.RelativeAge
FROM         NDB.AnalysisUnits INNER JOIN
                      NDB.RelativeChronology ON NDB.AnalysisUnits.AnalysisUnitID = NDB.RelativeChronology.AnalysisUnitID INNER JOIN
                      NDB.Chronologies ON NDB.AnalysisUnits.CollectionUnitID = NDB.Chronologies.CollectionUnitID INNER JOIN
                      NDB.RelativeAges ON NDB.RelativeChronology.RelativeAgeID = NDB.RelativeAges.RelativeAgeID
WHERE     (NDB.Chronologies.ChronologyID = @CHRONOLOGYID) AND (NDB.RelativeChronology.ChronControlID IS NOT NULL)





GO

-- ----------------------------
-- Procedure structure for GetRelativeAgeScaleByName
-- ----------------------------


CREATE PROCEDURE [GetRelativeAgeScaleByName](@RELATIVEAGESCALE nvarchar(64))
AS 
SELECT     RelativeAgeScaleID, RelativeAgeScale
FROM         NDB.RelativeAgeScales
WHERE     (RelativeAgeScale = @RELATIVEAGESCALE)




GO

-- ----------------------------
-- Procedure structure for GetRelativeAgeScalesTable
-- ----------------------------


CREATE PROCEDURE [GetRelativeAgeScalesTable]
AS SELECT      NDB.RelativeAgeScales.*
FROM          NDB.RelativeAgeScales





GO

-- ----------------------------
-- Procedure structure for GetRelativeAgesTable
-- ----------------------------



CREATE PROCEDURE [GetRelativeAgesTable]
AS SELECT      RelativeAgeID, RelativeAgeUnitID, RelativeAgeScaleID, RelativeAge, C14AgeYounger, C14AgeOlder, CalAgeYounger, CalAgeOlder, Notes
FROM          NDB.RelativeAges






GO

-- ----------------------------
-- Procedure structure for GetRelativeAgeUnitsByAgeScale
-- ----------------------------



CREATE PROCEDURE [GetRelativeAgeUnitsByAgeScale](@RELATIVEAGESCALE nvarchar(64))
AS 
SELECT     NDB.RelativeAgeUnits.RelativeAgeUnitID, NDB.RelativeAgeUnits.RelativeAgeUnit
FROM         NDB.RelativeAgeScales INNER JOIN
                      NDB.RelativeAges ON NDB.RelativeAgeScales.RelativeAgeScaleID = NDB.RelativeAges.RelativeAgeScaleID INNER JOIN
                      NDB.RelativeAgeUnits ON NDB.RelativeAges.RelativeAgeUnitID = NDB.RelativeAgeUnits.RelativeAgeUnitID
GROUP BY NDB.RelativeAgeScales.RelativeAgeScale, NDB.RelativeAgeUnits.RelativeAgeUnitID, NDB.RelativeAgeUnits.RelativeAgeUnit
HAVING      (NDB.RelativeAgeScales.RelativeAgeScale = @RELATIVEAGESCALE)




GO

-- ----------------------------
-- Procedure structure for GetRepositoryInstitution
-- ----------------------------


CREATE PROCEDURE [GetRepositoryInstitution](@ACRONYM nvarchar(64) = null, @REPOSITORY nvarchar(128) = null)
AS 
SELECT     RepositoryID, Acronym, Repository, Notes
FROM       NDB.RepositoryInstitutions
WHERE      (Acronym = @ACRONYM) OR (Repository = @REPOSITORY)






GO

-- ----------------------------
-- Procedure structure for GetRepositoryInstitutionsTable
-- ----------------------------


CREATE PROCEDURE [GetRepositoryInstitutionsTable]
AS SELECT      RepositoryID, Acronym, Repository, Notes
FROM          NDB.RepositoryInstitutions





GO

-- ----------------------------
-- Procedure structure for GetRockTypeByID
-- ----------------------------



CREATE PROCEDURE [GetRockTypeByID](@ROCKTYPEID int)
AS 
SELECT     RockTypeID, RockType, HigherRockTypeID, Description
FROM         NDB.RockTypes
WHERE     (RockTypeID = @ROCKTYPEID)






GO

-- ----------------------------
-- Procedure structure for GetRockTypeByName
-- ----------------------------


CREATE PROCEDURE [GetRockTypeByName](@ROCKTYPE nvarchar(64))
AS 
SELECT     RockTypeID, RockType, HigherRockTypeID, Description
FROM         NDB.RockTypes
WHERE     (RockType = @ROCKTYPE)





GO

-- ----------------------------
-- Procedure structure for GetRockTypesTable
-- ----------------------------

CREATE PROCEDURE [GetRockTypesTable]
AS SELECT      RockTypeID, RockType, HigherRockTypeID, Description
FROM          NDB.RockTypes




GO

-- ----------------------------
-- Procedure structure for GetSampleAge
-- ----------------------------




CREATE PROCEDURE [GetSampleAge](@CHRONOLOGYID int, @SAMPLEID int)
AS 
SELECT    SampleAgeID, Age, AgeYounger, AgeOlder
FROM      NDB.SampleAges
WHERE     (ChronologyID = @CHRONOLOGYID) AND (SampleID = @SAMPLEID)


GO

-- ----------------------------
-- Procedure structure for GetSampleAgesByChronID
-- ----------------------------



CREATE PROCEDURE [GetSampleAgesByChronID](@CHRONOLOGYID int)
AS 
SELECT     SampleID, Age, AgeYounger, AgeOlder
FROM         NDB.SampleAges
WHERE     (ChronologyID = @CHRONOLOGYID)

 



GO

-- ----------------------------
-- Procedure structure for GetSiteByName
-- ----------------------------






CREATE PROCEDURE [GetSiteByName](@SITENAME nvarchar(128))
AS
SELECT     SiteID, SiteName, geog.ToString() AS Geog
FROM         NDB.Sites
WHERE     (SiteName LIKE @SITENAME)


GO

-- ----------------------------
-- Procedure structure for GetSiteMetaData
-- ----------------------------

CREATE PROCEDURE [GetSiteMetaData](@SITEID int)
AS 
SELECT      SiteID, SiteName, geog.ToString() AS geog, Altitude, Area, SiteDescription, Notes 
FROM        NDB.Sites
WHERE       (SiteID = @SITEID)

GO

-- ----------------------------
-- Procedure structure for GetSites
-- ----------------------------





CREATE PROCEDURE [GetSites](@DATASETTYPEID int = null, @SITENAME nvarchar(128) = null, @GEOPOLITICALID int = null, @CONTACTID int = null, @AUTHORID int = null)
AS

DECLARE @SITES TABLE
(
  SiteID int,
  SiteName nvarchar(128),
  Geog nvarchar(MAX)
)

IF @DATASETTYPEID IS NOT NULL
  BEGIN
    IF @SITENAME IS NOT NULL
	  BEGIN
	    IF @GEOPOLITICALID IS NOT NULL
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.DatasetPIs.ContactID = @CONTACTID) AND
				       (NDB.Sites.SiteName LIKE @SITENAME)
              END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID) AND
                       (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE 
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND
                       (NDB.Sites.SiteName LIKE @SITENAME)
			  END 
		  END
		ELSE
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.DatasetPIs.ContactID = @CONTACTID) AND (NDB.Sites.SiteName LIKE @SITENAME) 
			  END
            ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
		  END
	  END
	ELSE  /* @SITENAME IS NULL */
	  BEGIN
	    IF @GEOPOLITICALID IS NOT NULL
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.DatasetPIs.ContactID = @CONTACTID)
              END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID)
              END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID
                WHERE (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID)
              END
		  END
		ELSE
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.DatasetPIs.ContactID = @CONTACTID)
              END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID)
              END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID
                WHERE  (NDB.Datasets.DatasetTypeID = @DATASETTYPEID)
              END
		  END
	  END
  END
ELSE  /* @DATASETTYPEID IS NULL */
  BEGIN
    IF @SITENAME IS NOT NULL
	  BEGIN
	    IF @GEOPOLITICALID IS NOT NULL
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.SiteGeoPolitical INNER JOIN
                         NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.DatasetPIs.ContactID = @CONTACTID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.SiteGeoPolitical INNER JOIN
                         NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.SiteGeoPolitical INNER JOIN
                         NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
		  END
		ELSE
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE (NDB.DatasetPIs.ContactID = @CONTACTID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                         NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                         NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE     (NDB.PublicationAuthors.ContactID = @AUTHORID) AND (NDB.Sites.SiteName LIKE @SITENAME)
			  END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.Sites
                WHERE  (SiteName LIKE @SITENAME)
			  END
		  END
	  END
	ELSE /* @SITENAME IS NULL */
	  BEGIN
	    IF @GEOPOLITICALID IS NOT NULL
		  BEGIN
		    IF @CONTACTID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.SiteGeoPolitical INNER JOIN
                         NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID INNER JOIN
                         NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                         NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                         NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.DatasetPIs.ContactID = @CONTACTID)
              END
			ELSE IF @AUTHORID IS NOT NULL
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM    NDB.SiteGeoPolitical INNER JOIN
                          NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID INNER JOIN
                          NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                          NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                          NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                          NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                          NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID) AND (NDB.PublicationAuthors.ContactID = @AUTHORID)
              END
			ELSE
			  BEGIN
			    INSERT INTO @SITES (SiteID, SiteName, Geog)
				SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
                FROM   NDB.SiteGeoPolitical INNER JOIN
                        NDB.Sites ON NDB.SiteGeoPolitical.SiteID = NDB.Sites.SiteID
                WHERE  (NDB.SiteGeoPolitical.GeoPoliticalID = @GEOPOLITICALID)
			  END
		  END
		ELSE IF @CONTACTID IS NOT NULL
		  BEGIN
		    INSERT INTO @SITES (SiteID, SiteName, Geog)
			SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
            FROM   NDB.Sites INNER JOIN
                     NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                     NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                     NDB.DatasetPIs ON NDB.Datasets.DatasetID = NDB.DatasetPIs.DatasetID
            WHERE  (NDB.DatasetPIs.ContactID = @CONTACTID)
          END
		ELSE IF @AUTHORID IS NOT NULL
		  BEGIN
		    INSERT INTO @SITES (SiteID, SiteName, Geog)
			SELECT Sites.SiteID, Sites.SiteName, Sites.geog.ToString()
            FROM   NDB.Sites INNER JOIN
                     NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                     NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID INNER JOIN
                     NDB.DatasetPublications ON NDB.Datasets.DatasetID = NDB.DatasetPublications.DatasetID INNER JOIN
                     NDB.Publications ON NDB.DatasetPublications.PublicationID = NDB.Publications.PublicationID INNER JOIN
                     NDB.PublicationAuthors ON NDB.Publications.PublicationID = NDB.PublicationAuthors.PublicationID
            WHERE (NDB.PublicationAuthors.ContactID = @AUTHORID)
          END
      END
  END 

SELECT SiteID, SiteName, Geog
FROM @SITES
GROUP BY SiteID, SiteName, Geog 

GO

-- ----------------------------
-- Procedure structure for GetSitesByDatabaseAndDatasetType
-- ----------------------------



CREATE PROCEDURE [GetSitesByDatabaseAndDatasetType](@DATABASEID int, @DATASETTYPEID int)
AS
DECLARE @SITES TABLE
(
  SiteID int, 
  SiteName nvarchar(128),
  Latitude float,
  Longitude float,
  Altitude float,
  Area float
)
INSERT INTO @SITES (SiteID, SiteName, Latitude, Longitude, Altitude, Area)
SELECT      NDB.Sites.SiteID, NDB.Sites.SiteName, geog.EnvelopeCenter().Lat, geog.EnvelopeCenter().Long, NDB.Sites.Altitude, NDB.Sites.Area
FROM         NDB.Datasets INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
                      NDB.DatasetDatabases ON NDB.Datasets.DatasetID = NDB.DatasetDatabases.DatasetID
WHERE     (NDB.DatasetDatabases.DatabaseID = @DATABASEID) AND (NDB.Datasets.DatasetTypeID = @DATASETTYPEID) 

SELECT     SiteID, SiteName, Latitude, Longitude,Altitude, Area
FROM       @SITES
GROUP BY SiteID, SiteName, Latitude, Longitude, Altitude, Area



GO

-- ----------------------------
-- Procedure structure for GetSitesByDatasetType
-- ----------------------------



CREATE PROCEDURE [GetSitesByDatasetType](@DATASETTYPEID int)
AS
DECLARE @SITES TABLE
(
  SiteID int, 
  SiteName nvarchar(128),
  Latitude float,
  Longitude float,
  Altitude float,
  Area float
)
INSERT INTO @SITES (SiteID, SiteName, Latitude, Longitude, Altitude, Area)
SELECT      NDB.Sites.SiteID, NDB.Sites.SiteName, geog.EnvelopeCenter().Lat, geog.EnvelopeCenter().Long, NDB.Sites.Altitude, NDB.Sites.Area
FROM         NDB.Datasets INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID
WHERE     (NDB.Datasets.DatasetTypeID = @DATASETTYPEID)

SELECT     SiteID, SiteName, Latitude, Longitude,Altitude, Area
FROM       @SITES
GROUP BY SiteID, SiteName, Latitude, Longitude, Altitude, Area



GO

-- ----------------------------
-- Procedure structure for GetSpecimenDatesByTaxonID
-- ----------------------------





CREATE PROCEDURE [GetSpecimenDatesByTaxonID](@TAXONID int)
AS
SELECT     SpecimenDateID, GeochronID, TaxonID, FractionID, SampleID, Notes, ElementTypeID
FROM         NDB.SpecimenDates
WHERE     (TaxonID = @TAXONID)

GO

-- ----------------------------
-- Procedure structure for GetSpecimenDomesticStatusByName
-- ----------------------------




CREATE PROCEDURE [GetSpecimenDomesticStatusByName](@DOMESTICSTATUS nvarchar(24))
AS 
SELECT      DomesticStatusID, DomesticStatus 
FROM          NDB.SpecimenDomesticStatusTypes
WHERE      (DomesticStatus = @DOMESTICSTATUS)






GO

-- ----------------------------
-- Procedure structure for GetSpecimenDomesticStatusTypes
-- ----------------------------




CREATE PROCEDURE [GetSpecimenDomesticStatusTypes]
AS SELECT     DomesticStatusID, DomesticStatus
FROM          NDB.SpecimenDomesticStatusTypes





GO

-- ----------------------------
-- Procedure structure for GetSpecimenIsotopeDataset
-- ----------------------------





CREATE PROCEDURE [GetSpecimenIsotopeDataset](@DATASETID int)
AS 
DECLARE @SPECISO TABLE
(
  ID int NOT NULL primary key identity(1,1),
  DataID int,
  SpecimenID int,
  AnalysisUnit nvarchar(80),
  Depth nvarchar(64),
  Thickness nvarchar(64),
  Taxon nvarchar(80),
  Element nvarchar(255),
  Variable nvarchar(80),
  Units nvarchar(64),
  Value nvarchar(64),
  SD nvarchar(64),
  MaterialAnalyzed nvarchar(50),
  Substrate nvarchar(50),
  Pretreatments nvarchar(MAX),
  Analyst nvarchar(80),
  Lab nvarchar(255),
  LabNumber nvarchar(64),
  Mass_mg nvarchar(64),
  WeightPercent nvarchar(64),
  AtomicPercent nvarchar(64),
  Reps nvarchar(64)
)

DECLARE @PRETREATMENTS TABLE
(
  DataID int,
  [Order] int,
  IsoPretreatmentType nvarchar(50),
  IsoPretreatmentQualifier nvarchar(50), 
  Value float,
  PRIMARY KEY (DataID)
)

INSERT INTO @SPECISO (DataID, SpecimenID, AnalysisUnit, Depth, Thickness, Taxon, Element, Variable, Units, Value, SD, MaterialAnalyzed, Substrate, Analyst, 
                      Lab, LabNumber, Mass_mg, WeightPercent, AtomicPercent, Reps)
SELECT     TOP (100) PERCENT NDB.Data.DataID, NDB.Specimens.SpecimenID, NDB.AnalysisUnits.AnalysisUnitName AS N'Analysis Unit', 
                      ISNULL(CAST(NDB.AnalysisUnits.Depth AS nvarchar), N'') AS Depth,
					  ISNULL(CAST(NDB.AnalysisUnits.Thickness AS nvarchar), N'') AS Thickness, 
                      Taxa_1.TaxonName AS Taxon,CONCAT(NDB.ElementTypes.ElementType, 
					  CASE WHEN NDB.ElementSymmetries.Symmetry IS NULL THEN N'' ELSE CONCAT(N';',NDB.ElementSymmetries.Symmetry) END,
                      CASE WHEN NDB.ElementPortions.Portion IS NULL THEN N'' ELSE CONCAT(N';',NDB.ElementPortions.Portion) END, 
                      CASE WHEN NDB.ElementMaturities.Maturity IS NULL THEN N'' ELSE CONCAT(N';',NDB.ElementMaturities.Maturity) END) AS Element, 
					  NDB.Taxa.TaxonName AS Variable, NDB.VariableUnits.VariableUnits AS Units, NDB.Data.Value, 
					  ISNULL(CAST(NDB.IsoSpecimenData.SD AS nvarchar), N'') AS SD, 
                      ISNULL(NDB.IsoMaterialAnalyzedTypes.IsoMaterialAnalyzedType,N'') AS N'Material Analyzed', 
					  ISNULL(NDB.IsoSubstrateTypes.IsoSubstrateType,N'') AS Substrate, 
					  ISNULL(NDB.Contacts.ContactName,N'') AS Analyst, 
					  ISNULL(NDB.IsoMetadata.Lab,N'') AS Lab, 
					  ISNULL(NDB.IsoMetadata.LabNumber,N'') AS N'Lab Number', 
					  ISNULL(CAST(NDB.IsoMetadata.Mass_mg AS nvarchar),N'') AS N'Mass (mg)', 
					  ISNULL(CAST(NDB.IsoMetadata.WeightPercent AS nvarchar),N'') AS N'Weight %', 
					  ISNULL(CAST(NDB.IsoMetadata.AtomicPercent AS nvarchar),N'') AS N'Atomic %', 
					  ISNULL(CAST(NDB.IsoMetadata.Reps AS nvarchar),N'') AS Reps
FROM         NDB.Datasets INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID INNER JOIN
                      NDB.IsoSpecimenData ON NDB.Data.DataID = NDB.IsoSpecimenData.DataID INNER JOIN
                      NDB.Specimens ON NDB.IsoSpecimenData.SpecimenID = NDB.Specimens.SpecimenID INNER JOIN
                      NDB.Data AS Data_1 ON NDB.Specimens.DataID = Data_1.DataID INNER JOIN
                      NDB.Variables AS Variables_1 ON Data_1.VariableID = Variables_1.VariableID INNER JOIN
                      NDB.Taxa AS Taxa_1 ON Variables_1.TaxonID = Taxa_1.TaxonID INNER JOIN
                      NDB.AnalysisUnits ON NDB.Samples.AnalysisUnitID = NDB.AnalysisUnits.AnalysisUnitID INNER JOIN
                      NDB.IsoMetadata ON NDB.Data.DataID = NDB.IsoMetadata.DataID LEFT OUTER JOIN
                      NDB.Contacts ON NDB.IsoMetadata.AnalystID = NDB.Contacts.ContactID LEFT OUTER JOIN
                      NDB.IsoSubstrateTypes ON NDB.IsoMetadata.IsoSubstrateTypeID = NDB.IsoSubstrateTypes.IsoSubstrateTypeID LEFT OUTER JOIN
                      NDB.IsoMaterialAnalyzedTypes ON NDB.IsoMetadata.IsoMatAnalTypeID = NDB.IsoMaterialAnalyzedTypes.IsoMatAnalTypeID LEFT OUTER JOIN
                      NDB.ElementPortions ON NDB.Specimens.PortionID = NDB.ElementPortions.PortionID LEFT OUTER JOIN
                      NDB.ElementTypes ON NDB.Specimens.ElementTypeID = NDB.ElementTypes.ElementTypeID LEFT OUTER JOIN
                      NDB.ElementSymmetries ON NDB.Specimens.SymmetryID = NDB.ElementSymmetries.SymmetryID LEFT OUTER JOIN
                      NDB.ElementMaturities ON NDB.Specimens.MaturityID = NDB.ElementMaturities.MaturityID
WHERE     (NDB.Datasets.DatasetID = 21006)
ORDER BY NDB.Specimens.SpecimenID, NDB.Taxa.TaxonName

DECLARE @NRows int = @@ROWCOUNT

INSERT INTO @PRETREATMENTS (DataID, [Order], IsoPretreatmentType, IsoPretreatmentQualifier, Value)
SELECT     TOP (100) PERCENT NDB.Data.DataID, NDB.IsoSamplePretreatments.[Order], NDB.IsoPretratmentTypes.IsoPretreatmentType, 
                      NDB.IsoPretratmentTypes.IsoPretreatmentQualifier, NDB.IsoSamplePretreatments.Value
FROM         NDB.IsoPretratmentTypes INNER JOIN
                      NDB.IsoSamplePretreatments ON NDB.IsoPretratmentTypes.IsoPretreatmentTypeID = NDB.IsoSamplePretreatments.IsoPretreatmentTypeID RIGHT OUTER JOIN
                      NDB.Datasets INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID ON NDB.IsoSamplePretreatments.DataID = NDB.Data.DataID
WHERE     (NDB.Datasets.DatasetID = 21006)
ORDER BY NDB.Data.DataID, NDB.IsoSamplePretreatments.[Order]

DECLARE @DATAID int
DECLARE @CurrentID int = 0

WHILE @CurrentID < @NRows
  BEGIN 
    SET @CurrentID = @CurrentID+1
	SET @DATAID = (SELECT DataID FROM @SPECISO WHERE (ID = @CurrentID))
	
	DECLARE @SAMPLEPRETREATMENTS TABLE (ID int NOT NULL primary key identity(1,1), [Order] int, Pretreatment nvarchar(255), Value float)

	INSERT INTO @SAMPLEPRETREATMENTS ([Order], Pretreatment, Value)
	SELECT [Order], CONCAT(IsoPretreatmentType,CASE WHEN IsoPretreatmentQualifier IS NULL THEN N'' ELSE CONCAT(N', ',IsoPretreatmentQualifier) END), Value
	FROM   @PRETREATMENTS
	WHERE  DataID = @DATAID

	DECLARE @NR int = @@ROWCOUNT
    DECLARE @PretreatmentID int = 0
    DECLARE @Pretreatment nvarchar(255)
	DECLARE @AllPretreatments nvarchar(MAX)
	
	WHILE @PretreatmentID < @NR
      BEGIN 
	    SET @PretreatmentID = @PretreatmentID+1
	    SET @Pretreatment = (SELECT CONCAT(Pretreatment,CASE WHEN Value IS NULL THEN N'' ELSE CONCAT(N', ',CAST(Value AS nvarchar)) END) 
		FROM @SAMPLEPRETREATMENTS WHERE (ID = @PretreatmentID))
				
		IF @PretreatmentID = 1
		  SET @AllPretreatments = @Pretreatment
		ELSE
		  SET @AllPretreatments = CONCAT(@AllPretreatments,N'; ',@Pretreatment)   
	  END

	UPDATE @SPECISO
    SET    Pretreatments = @AllPretreatments
	WHERE  ([@SPECISO].[ID] = @CurrentID) 
  END

SELECT SpecimenID, AnalysisUnit, Depth, Thickness, Taxon, Element, Variable, Units, Value, SD, MaterialAnalyzed, Substrate,
       Pretreatments, Analyst, Lab, LabNumber, Mass_mg, WeightPercent, AtomicPercent, Reps
FROM   @SPECISO
ORDER BY SpecimenID, Variable







GO

-- ----------------------------
-- Procedure structure for GetSpecimenSexByName
-- ----------------------------




CREATE PROCEDURE [GetSpecimenSexByName](@SEX nvarchar(24))
AS 
SELECT      SexID, Sex 
FROM          NDB.SpecimenSexTypes
WHERE      (Sex = @SEX)






GO

-- ----------------------------
-- Procedure structure for GetSpecimenSexTypes
-- ----------------------------



CREATE PROCEDURE [GetSpecimenSexTypes]
AS SELECT     SexID, Sex
FROM          NDB.SpecimenSexTypes




GO

-- ----------------------------
-- Procedure structure for GetStatsCollTypeDatasetCount
-- ----------------------------




CREATE PROCEDURE [GetStatsCollTypeDatasetCount]
AS 
SELECT     TOP (100) PERCENT NDB.CollectionTypes.CollType, COUNT(NDB.Datasets.DatasetID) AS DatasetCount
FROM         NDB.Datasets INNER JOIN
                      NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
                      NDB.CollectionTypes ON NDB.CollectionUnits.CollTypeID = NDB.CollectionTypes.CollTypeID
GROUP BY NDB.CollectionTypes.CollType
ORDER BY NDB.CollectionTypes.CollType


GO

-- ----------------------------
-- Procedure structure for GetStatsDatasetCountsAndRecords
-- ----------------------------



CREATE PROCEDURE [GetStatsDatasetCountsAndRecords]
AS 
DECLARE @STATS TABLE
(
  DatasetType nvarchar(80),
  DatasetCount int,
  DataRecordCount int
)

INSERT INTO @STATS(DatasetType, DatasetCount, DataRecordCount)
SELECT TOP (100) PERCENT NDB.DatasetTypes.DatasetType, COUNT(DISTINCT NDB.Datasets.DatasetID) AS DatasetCount, COUNT(NDB.Data.DataID) AS DataRecordCount
FROM NDB.Datasets INNER JOIN
     NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
     NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
     NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID
GROUP BY NDB.DatasetTypes.DatasetType

INSERT INTO @STATS(DatasetType, DatasetCount, DataRecordCount)
SELECT TOP (100) PERCENT NDB.DatasetTypes.DatasetType, COUNT(DISTINCT NDB.Datasets.DatasetID) AS DatasetCount, COUNT(NDB.Geochronology.GeochronID) AS DataRecordCount
FROM NDB.Datasets INNER JOIN
     NDB.DatasetTypes ON NDB.Datasets.DatasetTypeID = NDB.DatasetTypes.DatasetTypeID INNER JOIN
     NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
     NDB.Geochronology ON NDB.Samples.SampleID = NDB.Geochronology.SampleID
WHERE (NDB.DatasetTypes.DatasetTypeID = 1)
GROUP BY NDB.DatasetTypes.DatasetType

SELECT TOP (100) PERCENT DatasetType, DatasetCount, DataRecordCount
FROM @STATS
ORDER BY DatasetType

GO

-- ----------------------------
-- Procedure structure for GetSynonymsForInvalidTaxonID
-- ----------------------------





CREATE PROCEDURE [GetSynonymsForInvalidTaxonID](@INVALIDTAXONID int)
AS
SELECT     NDB.Taxa.TaxonID, NDB.Taxa.TaxonCode, NDB.Taxa.TaxonName, NDB.Taxa.Author, NDB.Taxa.Valid, NDB.Taxa.HigherTaxonID, NDB.Taxa.Extinct, 
                      NDB.Taxa.TaxaGroupID, NDB.Taxa.PublicationID, NDB.Taxa.ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, NDB.Taxa.Notes, NDB.Synonyms.SynonymTypeID
FROM        NDB.Synonyms INNER JOIN
                      NDB.Taxa ON NDB.Synonyms.ValidTaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.Synonyms.InvalidTaxonID = @INVALIDTAXONID)




GO

-- ----------------------------
-- Procedure structure for GetSynonymsForValidTaxonID
-- ----------------------------




CREATE PROCEDURE [GetSynonymsForValidTaxonID](@VALIDTAXONID int)
AS
SELECT     NDB.Taxa.TaxonID, NDB.Taxa.TaxonCode, NDB.Taxa.TaxonName, NDB.Taxa.Author, NDB.Taxa.Valid, NDB.Taxa.HigherTaxonID, NDB.Taxa.Extinct, 
                      NDB.Taxa.TaxaGroupID, NDB.Taxa.PublicationID, NDB.Taxa.ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, 
					  NDB.Taxa.Notes, NDB.Synonyms.SynonymTypeID
FROM         NDB.Synonyms INNER JOIN
                      NDB.Taxa ON NDB.Synonyms.InvalidTaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.Synonyms.ValidTaxonID = @VALIDTAXONID)
GO

-- ----------------------------
-- Procedure structure for GetSynonymType
-- ----------------------------




CREATE PROCEDURE [GetSynonymType](@SYNONYMTYPE nvarchar(255))
AS
SELECT      *
FROM          NDB.[SynonymTypes]
WHERE      (NDB.SynonymTypes.SynonymType = @SYNONYMTYPE)






GO

-- ----------------------------
-- Procedure structure for GetSynonymTypesTable
-- ----------------------------

CREATE PROCEDURE [GetSynonymTypesTable]
AS SELECT      *
FROM          NDB.[SynonymTypes]



GO

-- ----------------------------
-- Procedure structure for GetTableColumns
-- ----------------------------


CREATE PROCEDURE [GetTableColumns](@TABLENAME nvarchar(80))
AS 
SELECT 
    c.name 'Column Name',
    t.Name 'Data type',
    c.max_length 'Max Length'
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.system_type_id = t.system_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
    c.object_id = OBJECT_ID(@TABLENAME)




GO

-- ----------------------------
-- Procedure structure for GetTableMaxID
-- ----------------------------


CREATE PROCEDURE [GetTableMaxID](@TABLENAME nvarchar(64), @COLUMNNAME nvarchar(64))
AS
DECLARE @SQL nvarchar(500)
SET @SQL = (N'SELECT MAX('+@COLUMNNAME+N') AS MaxID FROM '+@TABLENAME)
EXECUTE sp_executesql @SQL




GO

-- ----------------------------
-- Procedure structure for GetTableMinID
-- ----------------------------



CREATE PROCEDURE [GetTableMinID](@TABLENAME nvarchar(64), @COLUMNNAME nvarchar(64))
AS
DECLARE @SQL nvarchar(500)
SET @SQL = (N'SELECT MIN('+@COLUMNNAME+N') AS MinID FROM '+@TABLENAME)
EXECUTE sp_executesql @SQL





GO

-- ----------------------------
-- Procedure structure for GetTableRecordCount
-- ----------------------------



CREATE PROCEDURE [GetTableRecordCount](@TABLENAME nvarchar(64))
AS
DECLARE @SQL nvarchar(500)
SET @SQL = (N'SELECT COUNT(*) AS Count FROM NDB.'+@TABLENAME)
EXECUTE sp_executesql @SQL





GO

-- ----------------------------
-- Procedure structure for GetTableRecordCountsByMonth
-- ----------------------------




CREATE PROCEDURE [GetTableRecordCountsByMonth](@TABLENAME nvarchar(64))
AS
DECLARE @SQL nvarchar(2000)
SET @SQL = (N'DECLARE @CREATEDATES TABLE (Year int, Month int)' +
N' INSERT INTO @CREATEDATES(Year, Month) SELECT YEAR(RecDateCreated), MONTH(RecDateCreated) FROM NDB.' + @TABLENAME + 
N' SELECT DISTINCT Year, Month, COUNT(*) AS Count, SUM(COUNT(*)) OVER (ORDER BY Year, Month) AS RunningCount FROM @CREATEDATES' +
N' GROUP BY Year, Month ORDER BY Year, Month')
EXECUTE sp_executesql @SQL



GO

-- ----------------------------
-- Procedure structure for GetTaphonomicSystemByName
-- ----------------------------




CREATE PROCEDURE [GetTaphonomicSystemByName](@TAPHONOMICSYSTEM nvarchar(64))
AS 
SELECT     TaphonomicSystemID, TaphonomicSystem, Notes
FROM         NDB.TaphonomicSystems
WHERE     (TaphonomicSystem = @TAPHONOMICSYSTEM)




GO

-- ----------------------------
-- Procedure structure for GetTaphonomicSystemsByDatasetType
-- ----------------------------




CREATE PROCEDURE [GetTaphonomicSystemsByDatasetType](@DATASETTYPEID int)
AS 
SELECT     NDB.TaphonomicSystems.TaphonomicSystemID, NDB.TaphonomicSystems.TaphonomicSystem, NDB.TaphonomicSystems.Notes
FROM         NDB.TaphonomicSystemsDatasetTypes INNER JOIN
                      NDB.TaphonomicSystems ON NDB.TaphonomicSystemsDatasetTypes.TaphonomicSystemID = NDB.TaphonomicSystems.TaphonomicSystemID
WHERE     (NDB.TaphonomicSystemsDatasetTypes.DatasetTypeID = @DATASETTYPEID)






GO

-- ----------------------------
-- Procedure structure for GetTaphonomicSystemsDatasetTypesTable
-- ----------------------------





CREATE PROCEDURE [GetTaphonomicSystemsDatasetTypesTable]
AS 
SELECT     NDB.TaphonomicSystemsDatasetTypes.DatasetTypeID, NDB.TaphonomicSystemsDatasetTypes.TaphonomicSystemID
FROM       NDB.TaphonomicSystemsDatasetTypes







GO

-- ----------------------------
-- Procedure structure for GetTaphonomicSystemsTable
-- ----------------------------




CREATE PROCEDURE [GetTaphonomicSystemsTable]
AS 
SELECT   NDB.TaphonomicSystems.TaphonomicSystemID, NDB.TaphonomicSystems.TaphonomicSystem, NDB.TaphonomicSystems.Notes
FROM     NDB.TaphonomicSystems






GO

-- ----------------------------
-- Procedure structure for GetTaphonomicTypeID
-- ----------------------------





CREATE PROCEDURE [GetTaphonomicTypeID](@TAPHONOMICSYSTEMID int, @TAPHONOMICTYPE nvarchar(64))
AS 
SELECT     NDB.TaphonomicTypes.TaphonomicTypeID
FROM         NDB.TaphonomicSystems INNER JOIN
                      NDB.TaphonomicTypes ON NDB.TaphonomicSystems.TaphonomicSystemID = NDB.TaphonomicTypes.TaphonomicSystemID
WHERE     (NDB.TaphonomicSystems.TaphonomicSystemID = @TAPHONOMICSYSTEMID) AND (NDB.TaphonomicTypes.TaphonomicType = @TAPHONOMICTYPE)





GO

-- ----------------------------
-- Procedure structure for GetTaphonomicTypesByIDList
-- ----------------------------



CREATE PROCEDURE [GetTaphonomicTypesByIDList](@TAPHONOMICTYPEIDS nvarchar(MAX))
AS
SELECT     NDB.TaphonomicTypes.TaphonomicTypeID, NDB.TaphonomicTypes.TaphonomicType, NDB.TaphonomicSystems.TaphonomicSystem
FROM         NDB.TaphonomicTypes INNER JOIN
                      NDB.TaphonomicSystems ON NDB.TaphonomicTypes.TaphonomicSystemID = NDB.TaphonomicSystems.TaphonomicSystemID
WHERE     (NDB.TaphonomicTypes.TaphonomicTypeID IN (
                                                   SELECT Value
                                                   FROM TI.func_IntListToIN(@TAPHONOMICTYPEIDS,'$') 
                                                   ))

                             




GO

-- ----------------------------
-- Procedure structure for GetTaphonomicTypesBySystem
-- ----------------------------



CREATE PROCEDURE [GetTaphonomicTypesBySystem](@TAPHONOMICSYSTEMID int)
AS 
SELECT     NDB.TaphonomicTypes.TaphonomicSystemID,  NDB.TaphonomicTypes.TaphonomicTypeID,  NDB.TaphonomicTypes.TaphonomicType, NDB.TaphonomicTypes.Notes
FROM         NDB.TaphonomicTypes
WHERE     (TaphonomicSystemID = @TAPHONOMICSYSTEMID)





GO

-- ----------------------------
-- Procedure structure for GetTaphonomicTypesTable
-- ----------------------------





CREATE PROCEDURE [GetTaphonomicTypesTable]
AS SELECT     NDB.TaphonomicTypes.TaphonomicTypeID, NDB.TaphonomicTypes.TaphonomicSystemID, NDB.TaphonomicTypes.TaphonomicType, NDB.TaphonomicTypes.Notes 
FROM          NDB.TaphonomicTypes







GO

-- ----------------------------
-- Procedure structure for GetTaxaByCodeAndTaxaGroupID
-- ----------------------------



CREATE PROCEDURE [GetTaxaByCodeAndTaxaGroupID](@TAXONCODE nvarchar(64), @TAXAGROUPID nvarchar(3))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, ValidatorID, 
               CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (TaxonCode = @TAXONCODE AND TaxaGroupID = @TAXAGROUPID)





GO

-- ----------------------------
-- Procedure structure for GetTaxaByNameList
-- ----------------------------


CREATE PROCEDURE [GetTaxaByNameList](@TAXANAMES nvarchar(MAX))
AS 
SELECT TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
       ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM NDB.Taxa
WHERE (TaxonName IN (
		            SELECT Value
		            FROM TI.func_NvarcharListToIN(@TAXANAMES,'$')
                    ))
                    



GO

-- ----------------------------
-- Procedure structure for GetTaxaByNamesCount
-- ----------------------------





-- gets number of samples assigned to analysis unit
CREATE PROCEDURE [GetTaxaByNamesCount](@TAXANAMES nvarchar(MAX))
AS 
SELECT     COUNT(TaxonID) AS Count
FROM         NDB.Taxa
WHERE     (TaxonName IN
                          (SELECT Value
                            FROM  TI.func_NvarcharListToIN(@TAXANAMES, '$') AS func_NvarcharListToIN_1))





GO

-- ----------------------------
-- Procedure structure for GetTaxaByTaxaGroupID
-- ----------------------------


CREATE PROCEDURE [GetTaxaByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, ValidatorID, 
               CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (TaxaGroupID = @TAXAGROUPID)




GO

-- ----------------------------
-- Procedure structure for GetTaxaEcolGroupsByDatasetTypeList
-- ----------------------------



CREATE PROCEDURE [GetTaxaEcolGroupsByDatasetTypeList](@DATASETTYPEIDS nvarchar(MAX))
AS 
SELECT     TOP (2147483647) NDB.TaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroupTypes.EcolGroupID, 
                      NDB.EcolGroupTypes.EcolGroup
FROM         NDB.Taxa INNER JOIN
                      NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
                      NDB.EcolGroupTypes ON NDB.EcolGroups.EcolGroupID = NDB.EcolGroupTypes.EcolGroupID INNER JOIN
                      NDB.EcolSetTypes ON NDB.EcolGroups.EcolSetID = NDB.EcolSetTypes.EcolSetID INNER JOIN
                      NDB.Variables ON NDB.Taxa.TaxonID = NDB.Variables.TaxonID INNER JOIN
                      NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID INNER JOIN
                      NDB.Samples ON NDB.Data.SampleID = NDB.Samples.SampleID INNER JOIN
                      NDB.Datasets ON NDB.Samples.DatasetID = NDB.Datasets.DatasetID RIGHT OUTER JOIN
                      NDB.TaxaGroupTypes ON NDB.Taxa.TaxaGroupID = NDB.TaxaGroupTypes.TaxaGroupID
WHERE     (NDB.Datasets.DatasetTypeID IN (
                                         SELECT Value
                                         FROM TI.func_IntListToIN(@DATASETTYPEIDS,',') 
                                         ))
GROUP BY NDB.TaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroupTypes.EcolGroupID, NDB.EcolGroupTypes.EcolGroup
ORDER BY NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroupTypes.EcolGroup






GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupByID
-- ----------------------------





CREATE PROCEDURE [GetTaxaGroupByID](@TAXAGROUPID nvarchar(3))
AS
SELECT     TaxaGroupID, TaxaGroup
FROM         NDB.TaxaGroupTypes
WHERE     (TaxaGroupID = @TAXAGROUPID)







GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupCodes
-- ----------------------------

CREATE PROCEDURE [GetTaxaGroupCodes]
AS 
SELECT     TOP (2147483647) NDB.TaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolSetTypes.EcolSetID, NDB.EcolSetTypes.EcolSetName, 
                      NDB.EcolGroupTypes.EcolGroupID, NDB.EcolGroupTypes.EcolGroup
FROM         NDB.Taxa INNER JOIN
                      NDB.EcolGroups ON NDB.Taxa.TaxonID = NDB.EcolGroups.TaxonID INNER JOIN
                      NDB.EcolGroupTypes ON NDB.EcolGroups.EcolGroupID = NDB.EcolGroupTypes.EcolGroupID INNER JOIN
                      NDB.EcolSetTypes ON NDB.EcolGroups.EcolSetID = NDB.EcolSetTypes.EcolSetID RIGHT OUTER JOIN
                      NDB.TaxaGroupTypes ON NDB.Taxa.TaxaGroupID = NDB.TaxaGroupTypes.TaxaGroupID
GROUP BY NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroupTypes.EcolGroup, NDB.TaxaGroupTypes.TaxaGroupID, NDB.EcolGroupTypes.EcolGroupID, 
                      NDB.EcolSetTypes.EcolSetID, NDB.EcolSetTypes.EcolSetName
ORDER BY NDB.TaxaGroupTypes.TaxaGroup, NDB.EcolGroupTypes.EcolGroup


GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupEcolSetIDs
-- ----------------------------




CREATE PROCEDURE [GetTaxaGroupEcolSetIDs](@TAXAGROUPID nvarchar(3))
AS 
SELECT     NDB.Taxa.TaxaGroupID, NDB.EcolGroups.EcolSetID
FROM         NDB.EcolGroups INNER JOIN
                      NDB.Taxa ON NDB.EcolGroups.TaxonID = NDB.Taxa.TaxonID
GROUP BY NDB.Taxa.TaxaGroupID, NDB.EcolGroups.EcolSetID
HAVING      (NDB.Taxa.TaxaGroupID = @TAXAGROUPID)






GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupElementTypes
-- ----------------------------



CREATE PROCEDURE [GetTaxaGroupElementTypes]
AS 
SELECT     NDB.ElementTaxaGroups.TaxaGroupID, NDB.ElementTypes.ElementType
FROM         NDB.ElementTaxaGroups INNER JOIN
                      NDB.ElementTypes ON NDB.ElementTaxaGroups.ElementTypeID = NDB.ElementTypes.ElementTypeID




GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupID
-- ----------------------------




CREATE PROCEDURE [GetTaxaGroupID](@TAXAGROUP nvarchar(64))
AS
SELECT     TaxaGroupID, TaxaGroup
FROM         NDB.TaxaGroupTypes
WHERE     (TaxaGroup LIKE @TAXAGROUP)






GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupPublications
-- ----------------------------

CREATE PROCEDURE [GetTaxaGroupPublications](@TAXAGROUPID nvarchar(50))
AS SELECT      NDB.Taxa.TaxaGroupID, NDB.Publications.PublicationID, NDB.Publications.PubTypeID, NDB.Publications.Year, NDB.Publications.Citation, 
                        NDB.Publications.ArticleTitle, NDB.Publications.Journal, NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, 
                        NDB.Publications.CitationNumber, NDB.Publications.DOI, NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, 
                        NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, 
                        NDB.Publications.City, NDB.Publications.State, NDB.Publications.Country, NDB.Publications.OriginalLanguage, NDB.Publications.Notes
FROM          NDB.Taxa INNER JOIN
                        NDB.Publications ON NDB.Taxa.PublicationID = NDB.Publications.PublicationID
GROUP BY NDB.Taxa.TaxaGroupID, NDB.Publications.PublicationID, NDB.Publications.PubTypeID, NDB.Publications.Year, NDB.Publications.Citation, 
                        NDB.Publications.ArticleTitle, NDB.Publications.Journal, NDB.Publications.Volume, NDB.Publications.Issue, NDB.Publications.Pages, 
                        NDB.Publications.CitationNumber, NDB.Publications.DOI, NDB.Publications.BookTitle, NDB.Publications.NumVolumes, NDB.Publications.Edition, 
                        NDB.Publications.VolumeTitle, NDB.Publications.SeriesTitle, NDB.Publications.SeriesVolume, NDB.Publications.Publisher, NDB.Publications.URL, 
                        NDB.Publications.City, NDB.Publications.State, NDB.Publications.Country, NDB.Publications.OriginalLanguage, NDB.Publications.Notes
HAVING       (NDB.Taxa.TaxaGroupID = @TAXAGROUPID)



GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupsForDatasetType
-- ----------------------------

CREATE PROCEDURE [GetTaxaGroupsForDatasetType](@DATASETTYPEID int)
AS 
SELECT      NDB.Taxa.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup
FROM          NDB.TaxaGroupTypes INNER JOIN
                        NDB.Taxa INNER JOIN
                        NDB.Variables INNER JOIN
                        NDB.Datasets INNER JOIN
                        NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                        NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID AND NDB.Samples.SampleID = NDB.Data.SampleID ON 
                        NDB.Variables.VariableID = NDB.Data.VariableID AND NDB.Variables.VariableID = NDB.Data.VariableID ON 
                        NDB.Taxa.TaxonID = NDB.Variables.TaxonID AND NDB.Taxa.TaxonID = NDB.Variables.TaxonID ON 
                        NDB.TaxaGroupTypes.TaxaGroupID = NDB.Taxa.TaxaGroupID AND NDB.TaxaGroupTypes.TaxaGroupID = NDB.Taxa.TaxaGroupID
GROUP BY NDB.Datasets.DatasetTypeID, NDB.Taxa.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup
HAVING       (NDB.Datasets.DatasetTypeID = @DATASETTYPEID)






GO

-- ----------------------------
-- Procedure structure for GetTaxaGroupTypes
-- ----------------------------


CREATE PROCEDURE [GetTaxaGroupTypes]
AS SELECT      NDB.TaxaGroupTypes.TaxaGroupID, NDB.TaxaGroupTypes.TaxaGroup
FROM          NDB.TaxaGroupTypes




GO

-- ----------------------------
-- Procedure structure for GetTaxaLookupSynonymyByTaxaGroupIDList
-- ----------------------------




CREATE PROCEDURE [GetTaxaLookupSynonymyByTaxaGroupIDList](@TAXAGROUPLIST nvarchar(MAX))
AS
SELECT     NDB.Taxa.TaxonID, NDB.Taxa.TaxonName, NDB.Synonyms.ValidTaxonID
FROM         NDB.Taxa INNER JOIN
                      NDB.Synonyms ON NDB.Taxa.TaxonID = NDB.Synonyms.InvalidTaxonID
WHERE      (NDB.Taxa.Valid = 0) AND (NDB.Taxa.TaxaGroupID IN (
		                            SELECT Value
		                            FROM TI.func_NvarcharListToIN(@TAXAGROUPLIST,'$')             
                                    ))
                                     





GO

-- ----------------------------
-- Procedure structure for GetTaxaTable
-- ----------------------------

CREATE PROCEDURE [GetTaxaTable]
AS
SELECT     TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
           ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa



GO

-- ----------------------------
-- Procedure structure for GetTaxonByID
-- ----------------------------



CREATE PROCEDURE [GetTaxonByID](@TAXONID int)
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
               ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (TaxonID = @TAXONID)





GO

-- ----------------------------
-- Procedure structure for GetTaxonByName
-- ----------------------------



CREATE PROCEDURE [GetTaxonByName](@TAXONNAME nvarchar(80))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
               ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (NDB.Taxa.TaxonName LIKE @TAXONNAME)





GO

-- ----------------------------
-- Procedure structure for GetTaxonDataRecordsCount
-- ----------------------------




CREATE PROCEDURE [GetTaxonDataRecordsCount](@TAXONID int)
AS 
SELECT     COUNT(NDB.Data.VariableID) AS Count
FROM         NDB.Variables INNER JOIN
                      NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID
WHERE     (NDB.Variables.TaxonID = @TAXONID)




GO

-- ----------------------------
-- Procedure structure for GetTaxonHierarchy
-- ----------------------------


CREATE PROCEDURE [GetTaxonHierarchy](@TAXONNAME nvarchar(80))
AS 
DECLARE @HIERARCHY TABLE
(
  TaxonID int, 
  TaxonName nvarchar(80),
  Valid bit,
  HigherTaxonID int
)
DECLARE @TAXONID int
DECLARE @HIGHERID int
INSERT INTO @HIERARCHY (TaxonID, TaxonName, Valid, HigherTaxonID)
  SELECT  TaxonID, TaxonName, Valid, HigherTaxonID
  FROM    NDB.Taxa
  WHERE   (TaxonName = @TAXONNAME);
SET @TAXONID = (SELECT TaxonID FROM NDB.Taxa WHERE (TaxonName = @TAXONNAME)) 
SET @HIGHERID = (SELECT HigherTaxonID FROM NDB.Taxa WHERE (TaxonName = @TAXONNAME))

WHILE @TAXONID <> @HIGHERID  
BEGIN
  INSERT INTO @HIERARCHY (TaxonID, TaxonName, Valid, HigherTaxonID)
    SELECT  TaxonID, TaxonName, Valid, HigherTaxonID
    FROM    NDB.Taxa
    WHERE   (TaxonID = @HIGHERID);
  SET @TAXONID = (SELECT TaxonID FROM NDB.Taxa WHERE (TaxonID = @HIGHERID)) 
  SET @HIGHERID = (SELECT HigherTaxonID FROM NDB.Taxa WHERE (TaxonID = @TAXONID))
END

SELECT  TaxonID, TaxonName, Valid, HigherTaxonID
FROM    @HIERARCHY






GO

-- ----------------------------
-- Procedure structure for GetTaxonSpecimenDatesCount
-- ----------------------------




CREATE PROCEDURE [GetTaxonSpecimenDatesCount](@TAXONID int)
AS 
SELECT     COUNT(TaxonID) AS Count
FROM         NDB.SpecimenDates
WHERE     (TaxonID = @TAXONID)



GO

-- ----------------------------
-- Procedure structure for GetTaxonSynonymsCount
-- ----------------------------





CREATE PROCEDURE [GetTaxonSynonymsCount](@VALIDTAXONID int)
AS 
SELECT     COUNT(ValidTaxonID) AS Count
FROM         NDB.Synonyms
WHERE     (ValidTaxonID = @VALIDTAXONID)




GO

-- ----------------------------
-- Procedure structure for GetTaxonSynonymyCount
-- ----------------------------






CREATE PROCEDURE [GetTaxonSynonymyCount](@TAXONID int)
AS 
SELECT     COUNT(TaxonID) AS Count
FROM         NDB.Synonymy
WHERE     (TaxonID = @TAXONID)





GO

-- ----------------------------
-- Procedure structure for GetTaxonVarElements
-- ----------------------------


CREATE PROCEDURE [GetTaxonVarElements](@TAXONNAME nvarchar(80))
AS SELECT      NDB.VariableElements.VariableElement
FROM          NDB.Variables INNER JOIN
                        NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                        NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
WHERE      (NDB.Taxa.TaxonName = @TAXONNAME)
GROUP BY NDB.VariableElements.VariableElement




GO

-- ----------------------------
-- Procedure structure for GetTaxonVarUnits
-- ----------------------------


CREATE PROCEDURE [GetTaxonVarUnits](@TAXONNAME nvarchar(80))
AS SELECT      NDB.VariableUnits.VariableUnits
FROM          NDB.Variables INNER JOIN
                        NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                        NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
WHERE      (NDB.Taxa.TaxonName = @TAXONNAME)
GROUP BY NDB.VariableUnits.VariableUnits




GO

-- ----------------------------
-- Procedure structure for GetUnitsDatasetTypeCount
-- ----------------------------




CREATE PROCEDURE [GetUnitsDatasetTypeCount](@DATASETTYPEID int, @VARIABLEUNITSID int)
AS 
SELECT     COUNT(DatasetTypeID) AS Count
FROM         NDB.UnitsDatasetTypes
WHERE     (DatasetTypeID = @DATASETTYPEID) AND (VariableUnitsID = @VARIABLEUNITSID)



GO

-- ----------------------------
-- Procedure structure for GetUnitsDatasetTypesTable
-- ----------------------------






CREATE PROCEDURE [GetUnitsDatasetTypesTable]
AS SELECT      *
FROM          NDB.UnitsDatasetTypes








GO

-- ----------------------------
-- Procedure structure for GetValidSynonymByInvalidTaxonID
-- ----------------------------



CREATE PROCEDURE [GetValidSynonymByInvalidTaxonID](@INVALIDTAXONID int)
AS 
SELECT     NDB.Synonyms.*
FROM         NDB.Synonyms
WHERE     (InvalidTaxonID = @INVALIDTAXONID)




GO

-- ----------------------------
-- Procedure structure for GetValidTaxaByTaxaGroupID
-- ----------------------------



CREATE PROCEDURE [GetValidTaxaByTaxaGroupID](@TAXAGROUPID nvarchar(3))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, ValidatorID, 
               CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 1) AND (TaxaGroupID = @TAXAGROUPID)





GO

-- ----------------------------
-- Procedure structure for GetValidTaxaByTaxaGroupIDList
-- ----------------------------


CREATE PROCEDURE [GetValidTaxaByTaxaGroupIDList](@TAXAGROUPLIST nvarchar(MAX))
AS
SELECT     TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
           ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 1) AND (TaxaGroupID IN (
		                   SELECT Value
		                   FROM TI.func_NvarcharListToIN(@TAXAGROUPLIST,'$')             
                           ))
                                     



GO

-- ----------------------------
-- Procedure structure for GetValidTaxonByName
-- ----------------------------

CREATE PROCEDURE [GetValidTaxonByName](@TAXONNAME nvarchar(80))
AS SELECT      TaxonID, TaxonCode, TaxonName, Author, Valid, HigherTaxonID, Extinct, TaxaGroupID, PublicationID, 
               ValidatorID, CONVERT(nvarchar(10),ValidateDate,120) AS ValidateDate, Notes
FROM          NDB.Taxa
WHERE      (Valid = 1) AND (NDB.Taxa.TaxonName LIKE @TAXONNAME)






GO

-- ----------------------------
-- Procedure structure for GetVarElemsByDatasetTypeAndTaxaIDList
-- ----------------------------


CREATE PROCEDURE [GetVarElemsByDatasetTypeAndTaxaIDList](@DATASETTYPE nvarchar(64), @TAXAIDS nvarchar(MAX))
AS 
SELECT     NDB.VariableElements.VariableElement, NDB.Variables.TaxonID
FROM         NDB.DatasetTypes INNER JOIN
                      NDB.Datasets ON NDB.DatasetTypes.DatasetTypeID = NDB.Datasets.DatasetTypeID INNER JOIN
                      NDB.Samples ON NDB.Datasets.DatasetID = NDB.Samples.DatasetID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
WHERE     (NDB.DatasetTypes.DatasetType LIKE @DATASETTYPE)
GROUP BY NDB.VariableElements.VariableElement, NDB.Variables.TaxonID
HAVING      (NDB.Variables.TaxonID IN (
                                      SELECT Value
                                      FROM TI.func_IntListToIN(@TAXAIDS,',') 
                                      ))




GO

-- ----------------------------
-- Procedure structure for GetVariableByComponentNames
-- ----------------------------






CREATE PROCEDURE [GetVariableByComponentNames](@TAXON nvarchar(80), @ELEMENT nvarchar(255) = NULL, @UNITS nvarchar(64) = NULL, @CONTEXT nvarchar(64) = NULL)
AS 
IF @ELEMENT IS NOT NULL AND @UNITS IS NOT NULL AND @CONTEXT IS NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement = @ELEMENT) AND (NDB.VariableUnits.VariableUnits = @UNITS) AND 
           (NDB.VariableContexts.VariableContext IS NULL)
  END
ELSE IF @ELEMENT IS NOT NULL AND @UNITS IS NULL AND @CONTEXT IS NOT NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement = @ELEMENT) AND (NDB.VariableUnits.VariableUnits IS NULL) AND 
           (NDB.VariableContexts.VariableContext = @CONTEXT)
  END
ELSE IF @ELEMENT IS NOT NULL AND @UNITS IS NULL AND @CONTEXT IS NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement = @ELEMENT) AND (NDB.VariableUnits.VariableUnits IS NULL) AND 
           (NDB.VariableContexts.VariableContext IS NULL)
  END
ELSE IF @ELEMENT IS NULL AND @UNITS IS NOT NULL AND @CONTEXT IS NOT NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement IS NULL) AND (NDB.VariableUnits.VariableUnits = @UNITS) AND 
           (NDB.VariableContexts.VariableContext = @CONTEXT)
  END
ELSE IF @ELEMENT IS NULL AND @UNITS IS NOT NULL AND @CONTEXT IS NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement IS NULL) AND (NDB.VariableUnits.VariableUnits = @UNITS) AND 
           (NDB.VariableContexts.VariableContext IS NULL)
  END
ELSE IF @ELEMENT IS NULL AND @UNITS IS NULL AND @CONTEXT IS NOT NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement IS NULL) AND (NDB.VariableUnits.VariableUnits IS NULL) AND 
           (NDB.VariableContexts.VariableContext = @CONTEXT)
  END
ELSE IF @ELEMENT IS NULL AND @UNITS IS NULL AND @CONTEXT IS NULL
  BEGIN
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement IS NULL) AND (NDB.VariableUnits.VariableUnits IS NULL) AND 
           (NDB.VariableContexts.VariableContext IS NULL)
  END

ELSE 
    SELECT NDB.Variables.VariableID
    FROM   NDB.Variables INNER JOIN
             NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
             NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
             NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
             NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
    WHERE  (NDB.Taxa.TaxonName = @TAXON) AND (NDB.VariableElements.VariableElement = @ELEMENT) AND (NDB.VariableUnits.VariableUnits = @UNITS) AND 
           (NDB.VariableContexts.VariableContext = @CONTEXT)


GO

-- ----------------------------
-- Procedure structure for GetVariableByComponents
-- ----------------------------





CREATE PROCEDURE [GetVariableByComponents](@TAXONID int, @VARIABLEELEMENTID int = NULL, @VARIABLEUNITSID int = NULL, @VARIABLECONTEXTID int = NULL)
AS 
IF @VARIABLEELEMENTID IS NOT NULL AND @VARIABLEUNITSID IS NOT NULL AND @VARIABLECONTEXTID IS NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID = @VARIABLEELEMENTID AND VariableUnitsID = @VARIABLEUNITSID AND VariableContextID IS NULL
  END
ELSE IF @VARIABLEELEMENTID IS NOT NULL AND @VARIABLEUNITSID IS NULL AND @VARIABLECONTEXTID IS NOT NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID = @VARIABLEELEMENTID AND VariableUnitsID IS NULL AND VariableContextID = @VARIABLECONTEXTID
  END
ELSE IF @VARIABLEELEMENTID IS NOT NULL AND @VARIABLEUNITSID IS NULL AND @VARIABLECONTEXTID IS NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID = @VARIABLEELEMENTID AND VariableUnitsID IS NULL AND VariableContextID IS NULL
  END
ELSE IF @VARIABLEELEMENTID IS NULL AND @VARIABLEUNITSID IS NOT NULL AND @VARIABLECONTEXTID IS NOT NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID IS NULL AND VariableUnitsID = @VARIABLEUNITSID AND VariableContextID = @VARIABLECONTEXTID
  END
ELSE IF @VARIABLEELEMENTID IS NULL AND @VARIABLEUNITSID IS NOT NULL AND @VARIABLECONTEXTID IS NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID IS NULL AND VariableUnitsID = @VARIABLEUNITSID AND VariableContextID IS NULL
  END
ELSE IF @VARIABLEELEMENTID IS NULL AND @VARIABLEUNITSID IS NULL AND @VARIABLECONTEXTID IS NOT NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID IS NULL AND VariableUnitsID IS NULL AND VariableContextID = @VARIABLECONTEXTID
  END
ELSE IF @VARIABLEELEMENTID IS NULL AND @VARIABLEUNITSID IS NULL AND @VARIABLECONTEXTID IS NULL
  BEGIN
    SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
	FROM   NDB.Variables
    WHERE  TaxonID = @TAXONID AND VariableElementID IS NULL AND VariableUnitsID IS NULL AND VariableContextID IS NULL
  END
ELSE 
   SELECT VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
   FROM   NDB.Variables
   WHERE  TaxonID = @TAXONID AND VariableElementID = @VARIABLEELEMENTID AND VariableUnitsID = @VARIABLEUNITSID AND VariableContextID = @VARIABLECONTEXTID





GO

-- ----------------------------
-- Procedure structure for GetVariableByID
-- ----------------------------


CREATE PROCEDURE [GetVariableByID](@VARIABLEID int)
AS 
SELECT     VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
FROM       NDB.Variables
WHERE      (VariableID = @VARIABLEID)



GO

-- ----------------------------
-- Procedure structure for GetVariableContextID
-- ----------------------------



CREATE PROCEDURE [GetVariableContextID](@VARIABLECONTEXT nvarchar(64))
AS
SELECT     VariableContextID
FROM         NDB.VariableContexts
WHERE     (VariableContext = @VARIABLECONTEXT)






GO

-- ----------------------------
-- Procedure structure for GetVariableContextsTable
-- ----------------------------


CREATE PROCEDURE [GetVariableContextsTable]
AS 
SELECT     VariableContextID, VariableContext
FROM         NDB.VariableContexts




GO

-- ----------------------------
-- Procedure structure for GetVariableContextsTableByDatasetTypeID
-- ----------------------------


CREATE PROCEDURE [GetVariableContextsTableByDatasetTypeID](@DATASETTYPEID int)
AS SELECT     NDB.VariableContexts.VariableContext
FROM         NDB.ContextsDatasetTypes INNER JOIN
                      NDB.VariableContexts ON NDB.ContextsDatasetTypes.VariableContextID = NDB.VariableContexts.VariableContextID
WHERE     (NDB.ContextsDatasetTypes.DatasetTypeID = @DATASETTYPEID)



GO

-- ----------------------------
-- Procedure structure for GetVariableDataRecordsCount
-- ----------------------------





CREATE PROCEDURE [GetVariableDataRecordsCount](@VARIABLEID int)
AS 
SELECT     COUNT(NDB.Data.VariableID) AS Count
FROM         NDB.Variables INNER JOIN
                      NDB.Data ON NDB.Variables.VariableID = NDB.Data.VariableID
WHERE     (NDB.Variables.VariableID = @VARIABLEID)





GO

-- ----------------------------
-- Procedure structure for GetVariableElementByName
-- ----------------------------




CREATE PROCEDURE [GetVariableElementByName](@VARIABLEELEMENT nvarchar(64))
AS 
SELECT     VariableElementID, ElementTypeID, SymmetryID, PortionID, MaturityID
FROM         NDB.VariableElements
WHERE     (VariableElement = @VARIABLEELEMENT)




GO

-- ----------------------------
-- Procedure structure for GetVariableElementByPartIDs
-- ----------------------------


CREATE PROCEDURE [GetVariableElementByPartIDs](@ELEMENTTYPEID int, @SYMMETRYID int, @PORTIONID int, @MATURITYID int)
AS
DECLARE @ELMREL nvarchar(36) = N'(ElementTypeID = ' + CAST(@ELEMENTTYPEID AS nvarchar(8)) + N')'
DECLARE @SYMREL nvarchar(36)
DECLARE @PORREL nvarchar(36)
DECLARE @MATREL nvarchar(36)
DECLARE @SQL nvarchar(MAX)
IF (@SYMMETRYID = -1)
  SET @SYMREL = N'(SymmetryID IS NULL)'
ELSE 
  SET @SYMREL = N'(SymmetryID = ' + CAST(@SYMMETRYID AS nvarchar(8)) + N')'
IF (@PORTIONID = -1)
  SET @PORREL = N'(PortionID IS NULL)'
ELSE 
  SET @PORREL = N'(PortionID = ' + CAST(@PORTIONID AS nvarchar(8)) + N')'
IF (@MATURITYID = -1)
  SET @MATREL = N'(MaturityID IS NULL)'
ELSE 
  SET @MATREL = N'(MaturityID = ' + CAST(@MATURITYID AS nvarchar(8)) + N')'
SET @SQL = N'SELECT VariableElementID FROM NDB.VariableElements WHERE ' + @ELMREL + ' AND ' + @SYMREL + N' AND ' + @PORREL + N' AND ' + @MATREL
EXECUTE sp_executesql @SQL
 
GO

-- ----------------------------
-- Procedure structure for GetVariableElementsByDatasetTypeID
-- ----------------------------





CREATE PROCEDURE [GetVariableElementsByDatasetTypeID](@DATASETTYPEID int)
AS 
SELECT     TOP (100) PERCENT NDB.VariableElements.VariableElementID, NDB.VariableElements.VariableElement, NDB.VariableElements.ElementTypeID, 
                      NDB.VariableElements.SymmetryID, NDB.VariableElements.PortionID, NDB.VariableElements.MaturityID, NDB.ElementDatasetTaxaGroups.TaxaGroupID
FROM         NDB.VariableElements INNER JOIN
                      NDB.ElementDatasetTaxaGroups ON NDB.VariableElements.ElementTypeID = NDB.ElementDatasetTaxaGroups.ElementTypeID
WHERE     (NDB.ElementDatasetTaxaGroups.DatasetTypeID = @DATASETTYPEID)
ORDER BY NDB.ElementDatasetTaxaGroups.TaxaGroupID, NDB.VariableElements.VariableElement







GO

-- ----------------------------
-- Procedure structure for GetVariableElementsTable
-- ----------------------------



CREATE PROCEDURE [GetVariableElementsTable]
AS 
SELECT     VariableElementID, VariableElement, ElementTypeID, SymmetryID, PortionID, MaturityID
FROM         NDB.VariableElements





GO

-- ----------------------------
-- Procedure structure for GetVariablesByTaxaGroupIDList
-- ----------------------------


CREATE PROCEDURE [GetVariablesByTaxaGroupIDList](@TAXAGROUPLIST nvarchar(MAX))
AS SELECT NDB.Variables.*
FROM      NDB.Variables INNER JOIN NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID
WHERE     (NDB.Taxa.TaxaGroupID IN (
		                           SELECT Value
		                           FROM TI.func_NvarcharListToIN(@TAXAGROUPLIST,'$')             
                                   ))




GO

-- ----------------------------
-- Procedure structure for GetVariablesByTaxonID
-- ----------------------------




CREATE PROCEDURE [GetVariablesByTaxonID](@TAXONID int)
AS 
SELECT     VariableID, TaxonID, VariableElementID, VariableUnitsID, VariableContextID
FROM         NDB.Variables
WHERE     (TaxonID = @TAXONID)




GO

-- ----------------------------
-- Procedure structure for GetVariablesTable
-- ----------------------------

CREATE PROCEDURE [GetVariablesTable]
AS SELECT      *
FROM          NDB.Variables



GO

-- ----------------------------
-- Procedure structure for GetVariableTaxonID
-- ----------------------------





CREATE PROCEDURE [GetVariableTaxonID](@VARIABLEID int)
AS 
SELECT TaxonID
FROM   NDB.Variables
WHERE  (VariableID = @VARIABLEID)





GO

-- ----------------------------
-- Procedure structure for GetVariableTextByID
-- ----------------------------



CREATE PROCEDURE [GetVariableTextByID](@VARIABLEID int)
AS 
SELECT     NDB.Taxa.TaxonName, NDB.VariableElements.VariableElement, NDB.VariableUnits.VariableUnits, NDB.VariableContexts.VariableContext
FROM         NDB.Variables INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
                      NDB.VariableContexts ON NDB.Variables.VariableContextID = NDB.VariableContexts.VariableContextID LEFT OUTER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID LEFT OUTER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID
WHERE     (NDB.Variables.VariableID = @VARIABLEID)




GO

-- ----------------------------
-- Procedure structure for GetVariableUnitsID
-- ----------------------------


CREATE PROCEDURE [GetVariableUnitsID](@VARIABLEUNITS nvarchar(64))
AS
SELECT     VariableUnitsID
FROM         NDB.VariableUnits
WHERE     (VariableUnits = @VARIABLEUNITS)





GO

-- ----------------------------
-- Procedure structure for GetVariableUnitsTable
-- ----------------------------

CREATE PROCEDURE [GetVariableUnitsTable]
AS SELECT      *
FROM          NDB.VariableUnits



GO

-- ----------------------------
-- Procedure structure for GetVariableUnitsTableByDatasetTypeID
-- ----------------------------



CREATE PROCEDURE [GetVariableUnitsTableByDatasetTypeID](@DATASETTYPEID int)
AS SELECT     NDB.VariableUnits.VariableUnits
FROM         NDB.UnitsDatasetTypes INNER JOIN
                      NDB.VariableUnits ON NDB.UnitsDatasetTypes.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
WHERE     (NDB.UnitsDatasetTypes.DatasetTypeID = @DATASETTYPEID)





GO

-- ----------------------------
-- Procedure structure for SKOPE_GetSurfaceSampleData
-- ----------------------------



CREATE PROCEDURE [SKOPE_GetSurfaceSampleData](@DATASETTYPEID int = null, @EASTLONGBOUND float = 0, @WESTLONGBOUND float = -180, @NORTHLATBOUND float = 90, @SOUTHLATBOUND float = 0)
AS
SELECT     TOP (100) PERCENT NDB.Sites.SiteID, NDB.Datasets.DatasetID, NDB.Samples.SampleID, NDB.Taxa.TaxonName, NDB.VariableElements.VariableElement, 
                      NDB.VariableUnits.VariableUnits, NDB.Data.Value
FROM         NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID INNER JOIN
                      NDB.Samples ON NDB.AnalysisUnits.AnalysisUnitID = NDB.Samples.AnalysisUnitID INNER JOIN
                      NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID AND NDB.Samples.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.SampleKeywords ON NDB.Samples.SampleID = NDB.SampleKeywords.SampleID INNER JOIN
                      NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                      NDB.GeoPoliticalUnits ON NDB.SiteGeoPolitical.GeoPoliticalID = NDB.GeoPoliticalUnits.GeoPoliticalID INNER JOIN
                      NDB.Data ON NDB.Samples.SampleID = NDB.Data.SampleID INNER JOIN
                      NDB.Variables ON NDB.Data.VariableID = NDB.Variables.VariableID INNER JOIN
                      NDB.Taxa ON NDB.Variables.TaxonID = NDB.Taxa.TaxonID INNER JOIN
                      NDB.VariableElements ON NDB.Variables.VariableElementID = NDB.VariableElements.VariableElementID INNER JOIN
                      NDB.VariableUnits ON NDB.Variables.VariableUnitsID = NDB.VariableUnits.VariableUnitsID
WHERE     (NDB.SampleKeywords.KeywordID = 1) AND (NDB.Datasets.DatasetTypeID = 3) AND Sites.geog.EnvelopeCenter().Long < @EASTLONGBOUND AND 
                      Sites.geog.EnvelopeCenter().Long > @WESTLONGBOUND AND Sites.geog.EnvelopeCenter().Lat > @SOUTHLATBOUND AND 
					  Sites.geog.EnvelopeCenter().Lat < @NORTHLATBOUND AND (NDB.GeoPoliticalUnits.Rank = 1) AND 
                      (NDB.GeoPoliticalUnits.GeoPoliticalName = N'Canada' OR
                      NDB.GeoPoliticalUnits.GeoPoliticalName = N'Mexico' OR
                      NDB.GeoPoliticalUnits.GeoPoliticalName = N'United States') AND (NDB.VariableUnits.VariableUnits = N'NISP' OR
                      NDB.VariableUnits.VariableUnits = N'percent')
ORDER BY NDB.Sites.SiteID, NDB.Datasets.DatasetID, NDB.Samples.SampleID




GO

-- ----------------------------
-- Procedure structure for SKOPE_GetSurfaceSampleMetaData
-- ----------------------------


CREATE PROCEDURE [SKOPE_GetSurfaceSampleMetaData](@EASTLONGBOUND float = 0, @WESTLONGBOUND float = -180, @NORTHLATBOUND float = 90, @SOUTHLATBOUND float = 0)
AS
SELECT     NDB.Sites.SiteID, NDB.Sites.SiteName, Sites.geog.EnvelopeCenter().Lat AS Latitude, Sites.geog.EnvelopeCenter().Long AS Longitude, NDB.Sites.Altitude,
           NDB.CollectionUnits.CollectionUnitID, NDB.AnalysisUnits.AnalysisUnitID, NDB.Datasets.DatasetID, NDB.Datasets.DatasetTypeID, NDB.Samples.SampleID 
FROM         NDB.Sites INNER JOIN
                      NDB.CollectionUnits ON NDB.Sites.SiteID = NDB.CollectionUnits.SiteID INNER JOIN
                      NDB.AnalysisUnits ON NDB.CollectionUnits.CollectionUnitID = NDB.AnalysisUnits.CollectionUnitID INNER JOIN
                      NDB.Samples ON NDB.AnalysisUnits.AnalysisUnitID = NDB.Samples.AnalysisUnitID INNER JOIN
                      NDB.Datasets ON NDB.CollectionUnits.CollectionUnitID = NDB.Datasets.CollectionUnitID AND NDB.Samples.DatasetID = NDB.Datasets.DatasetID INNER JOIN
                      NDB.SampleKeywords ON NDB.Samples.SampleID = NDB.SampleKeywords.SampleID INNER JOIN
                      NDB.SiteGeoPolitical ON NDB.Sites.SiteID = NDB.SiteGeoPolitical.SiteID INNER JOIN
                      NDB.GeoPoliticalUnits ON NDB.SiteGeoPolitical.GeoPoliticalID = NDB.GeoPoliticalUnits.GeoPoliticalID
WHERE     (NDB.SampleKeywords.KeywordID = 1) AND (NDB.Datasets.DatasetTypeID = 3 OR
                      NDB.Datasets.DatasetTypeID = 7) AND Sites.geog.EnvelopeCenter().Long < @EASTLONGBOUND AND Sites.geog.EnvelopeCenter().Long > @WESTLONGBOUND AND
					  Sites.geog.EnvelopeCenter().Lat > @SOUTHLATBOUND AND Sites.geog.EnvelopeCenter().Lat < @NORTHLATBOUND AND
					  (NDB.GeoPoliticalUnits.Rank = 1) AND (NDB.GeoPoliticalUnits.GeoPoliticalName = N'Canada' OR
                      NDB.GeoPoliticalUnits.GeoPoliticalName = N'Mexico' OR
                      NDB.GeoPoliticalUnits.GeoPoliticalName = N'United States')
ORDER BY NDB.Sites.SiteID


GO

-- ----------------------------
-- Procedure structure for SVC_ListStoredProcedures
-- ----------------------------
CREATE PROCEDURE [SVC_ListStoredProcedures]

 AS

SET NOCOUNT ON

SELECT sp.name as 'method'
FROM sys.procedures sp inner join
sys.schemas sch on sp.schema_id = sch.schema_id
where  sch.name = 'TI' and sp.name not like 'SVC_%'    
order by sp.name
RETURN

SET NOCOUNT OFF

GO

-- ----------------------------
-- Procedure structure for SVC_StoredProcedureParams
-- ----------------------------
CREATE PROCEDURE [SVC_StoredProcedureParams]

@name varchar(50)

 AS

SET NOCOUNT ON

SELECT parm.name AS Parameter, typ.name AS [Type]
FROM sys.procedures sp
JOIN sys.schemas sch on sp.schema_id = sch.schema_id
JOIN sys.parameters parm ON sp.object_id = parm.object_id
JOIN sys.types typ ON parm.user_type_id = typ.user_type_id
WHERE sp.name = @name and sch.name = 'TI'
                  
   RETURN

SET NOCOUNT OFF

GO

-- ----------------------------
-- Procedure structure for WorldClim_GetAnnualMeanTemp
-- ----------------------------




CREATE PROCEDURE [WorldClim_GetAnnualMeanTemp](@SITENAME nvarchar(128), @NGRIDSQUARES int = 9, @DIST float = 5)
AS 

DECLARE @USERSITENAME nvarchar(128) = (SELECT SiteName FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME)
DECLARE @LONGSITE float = RADIANS((SELECT ((LongitudeEast+LongitudeWest)/2.0) FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME))
DECLARE @LATSITE float  = RADIANS((SELECT ((LatitudeNorth+LatitudeSouth)/2.0) FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME))
DECLARE @LON nvarchar(48) = CAST(@LONGSITE AS nvarchar(48))
DECLARE @LAT nvarchar(48) = CAST(@LATSITE AS nvarchar(48))
DECLARE @R nvarchar(12) = N'6371.0'
DECLARE @NGS nvarchar(12) = CAST(@NGRIDSQUARES AS nvarchar(12))
DECLARE @D nvarchar(12) = CAST(@DIST AS nvarchar(12))

DECLARE @sqlText nvarchar(MAX);
SET @sqlText = N'SELECT TOP (' + RTRIM(@NGS) + N') ' + N'''' + RTRIM(@USERSITENAME) + N'''' + N' AS SiteName, ' + 
               N'CONVERT(decimal(5, 1), 1.0 * SUM(January + February + March + April + May + June + July + August + September + October + November + December)
                       / 120) AS AnnualMeanTemperature, ' +
               N'ACOS(SIN(CAST(' + @LAT + N' AS float))*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(CAST('+ @LAT + N' AS float))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-CAST(' + @LON + N' AS float)))*CAST(' + @R + N' AS float) AS Dist_km, ' + 
			   N'CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.00 AS GridSquareLat,' +
			   N'CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0 AS GridSquareLong ' + 	  		      
               N'FROM WorldClim.dbo.MeanTemperature '  + 
			   N'GROUP BY Latitude, Longitude ' +
               N'HAVING ((ACOS(SIN(CAST(' + @LAT + N' AS float))*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(CAST(' + @LAT + N' AS float))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-CAST(' + @LON + N' AS float)))*CAST(' + @R + N' AS float)) < CAST(' + @D + N'AS float))' + 
               N'ORDER BY Dist_km' 
EXECUTE sp_executesql @sqlText


GO

-- ----------------------------
-- Procedure structure for WorldClim_GetMonthlyMeanTemp
-- ----------------------------



CREATE PROCEDURE [WorldClim_GetMonthlyMeanTemp](@SITENAME nvarchar(128), @MONTH nvarchar(24), @NGRIDSQUARES int = 9, @DIST float = 5)
AS 

DECLARE @USERSITENAME nvarchar(128) = (SELECT SiteName FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME)
DECLARE @LONGSITE float = RADIANS((SELECT ((LongitudeEast+LongitudeWest)/2.0) FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME))
DECLARE @LATSITE float  = RADIANS((SELECT ((LatitudeNorth+LatitudeSouth)/2.0) FROM NDB.Sites WHERE NDB.Sites.SiteName LIKE @SITENAME))
DECLARE @LON nvarchar(48) = CAST(@LONGSITE AS nvarchar(48))
DECLARE @LAT nvarchar(48) = CAST(@LATSITE AS nvarchar(48))
DECLARE @R nvarchar(12) = N'6371.0'
DECLARE @COLUMN varchar(64) = 'WorldClim.dbo.MeanTemperature.' + @MONTH
DECLARE @NGS nvarchar(12) = CAST(@NGRIDSQUARES AS nvarchar(12))
DECLARE @D nvarchar(12) = CAST(@DIST AS nvarchar(12))

DECLARE @sqlText nvarchar(MAX);
SET @sqlText = N'SELECT TOP (' + RTRIM(@NGS) + N') ' + N'''' + RTRIM(@USERSITENAME) + N'''' + N' AS SiteName, ' + 
               N'CAST(' + @COLUMN + N' AS float)/10.0 AS MeanMonthlyTemp, ' +
               N'ACOS(SIN(CAST(' + @LAT + N' AS float))*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(CAST('+ @LAT + N' AS float))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-CAST(' + @LON + N' AS float)))*CAST(' + @R + N' AS float) AS Dist_km, ' + 
			   N'CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.00 AS GridSquareLat,' +
			   N'CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0 AS GridSquareLong ' + 	  		      
               N'FROM WorldClim.dbo.MeanTemperature '  + 
               N'WHERE ((ACOS(SIN(CAST(' + @LAT + N' AS float))*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(CAST(' + @LAT + N' AS float))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*' +
			   N'COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-CAST(' + @LON + N' AS float)))*CAST(' + @R + N' AS float)) < CAST(' + @D + N'AS float))' + 
               N'ORDER BY Dist_km' 
EXECUTE sp_executesql @sqlText

/*
SELECT TOP (@NGRIDSQUARES) @USERSITENAME AS SiteName,
            CAST(WorldClim.dbo.MeanTemperature.January AS float)/10.0 AS January,
 			     ACOS(SIN(@LATSITE)*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(@LATSITE)*
			     COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*
				 COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-@LONGSITE))*@R AS Dist_km,
			CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.00 AS GridSquareLat,
			CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0 AS GridSquareLong	  		      
                          
FROM   WorldClim.dbo.MeanTemperature
WHERE ((ACOS(SIN(@LATSITE)*SIN(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))+COS(@LATSITE)*
			 COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Latitude AS float)/3600.0))*
			 COS(RADIANS(CAST(WorldClim.dbo.MeanTemperature.Longitude AS float)/3600.0)-@LONGSITE))*@R) 
       < @DIST)
ORDER BY Dist_km
*/
GO
