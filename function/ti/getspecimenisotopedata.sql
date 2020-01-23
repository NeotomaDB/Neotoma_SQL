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
