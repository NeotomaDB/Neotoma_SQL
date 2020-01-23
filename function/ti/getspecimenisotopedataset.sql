CREATE OR REPLACE FUNCTION ti.getspecimenisotopedataset(_datasetid integer)
 RETURNS TABLE(SpecimenID integer,
               AnalysisUnit character varying,
               Depth,
               Thickness,
               Taxon,
               Element,
               Variable,
               Units,
               Value,
               SD,
               MaterialAnalyzed,
               Substrate,
               Pretreatments,
               Analyst,
               Lab,
               LabNumber,
               Mass_mg,
               WeightPercent,
               AtomicPercent,
               Reps)
 LANGUAGE sql
AS $function$

  WITH pretreatments AS (
    SELECT dt.dataid,
           ipt.order,
           concat_ws(', ', ipty.isopretreatmenttype, ipty.isopretreatmentqualifier, ipt.value)
    FROM           ndb.isopretreatmenttypes AS ipty
      INNER JOIN ndb.isosamplepretreatments AS ipt ON ipty.isopretreatmenttypeid = ipt.isopretreatmenttypeid
      INNER JOIN ndb.data AS dt ON dt.dataid = ipt.dataid
      INNER JOIN ndb.samples AS smp ON smp.sampleid = dt.sampleid
      INNER JOIN ndb.datasets AS ds ON smp.datasetid = ds.datasetid
    WHERE  ds.datasetid = 21006
    ORDER BY dt.dataid, ipt.order
  )
  SELECT ndb.Data.DataID,
         ndb.Specimens.SpecimenID,
         ndb.AnalysisUnits.AnalysisUnitName AS N'Analysis Unit',
         ISNULL(CAST(ndb.AnalysisUnits.Depth AS nvarchar), N'') AS Depth,
  			 ISNULL(CAST(ndb.AnalysisUnits.Thickness AS nvarchar), N'') AS Thickness,
         Taxa_1.TaxonName AS Taxon,CONCAT(ndb.ElementTypes.ElementType,
  			 CASE WHEN ndb.ElementSymmetries.Symmetry IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementSymmetries.Symmetry) END,
         CASE WHEN ndb.ElementPortions.Portion IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementPortions.Portion) END,
         CASE WHEN ndb.ElementMaturities.Maturity IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementMaturities.Maturity) END) AS Element,
  			 ndb.Taxa.TaxonName AS Variable, ndb.VariableUnits.VariableUnits AS Units, ndb.Data.Value,
  			 ISNULL(CAST(ndb.IsoSpecimenData.SD AS nvarchar), N'') AS SD,
         ISNULL(ndb.IsoMaterialAnalyzedTypes.IsoMaterialAnalyzedType,N'') AS N'Material Analyzed',
  			 ISNULL(ndb.IsoSubstrateTypes.IsoSubstrateType,N'') AS Substrate,
  			 ISNULL(ndb.Contacts.ContactName,N'') AS Analyst,
  			 ISNULL(ndb.IsoMetadata.Lab,N'') AS Lab,
  			 ISNULL(ndb.IsoMetadata.LabNumber,N'') AS N'Lab Number',
  			 ISNULL(CAST(ndb.IsoMetadata.Mass_mg AS nvarchar),N'') AS N'Mass (mg)',
  			 ISNULL(CAST(ndb.IsoMetadata.WeightPercent AS nvarchar),N'') AS N'Weight %',
  			 ISNULL(CAST(ndb.IsoMetadata.AtomicPercent AS nvarchar),N'') AS N'Atomic %',
  			 ISNULL(CAST(ndb.IsoMetadata.Reps AS nvarchar),N'') AS Reps
  FROM ndb.datasets AS ds
    INNER JOIN                       ndb.samples AS smp ON ds.datasetid = smp.datasetid
    INNER JOIN                          ndb.data AS dt ON smp.sampleid = dt.sampleid
    INNER JOIN                     ndb.variables AS var ON dt.VariableID = var.variableid
    INNER JOIN                          ndb.taxa AS tx ON var.taxonid = tx.taxonid
    INNER JOIN                 ndb.variableunits AS vu ON var.variableunitsid = vu.variableunitsid
    INNER JOIN               ndb.isospecimendata AS isd ON dt.dataid = isd.dataid
    INNER JOIN                     ndb.specimens AS sp ON isd.specimenid = sp.specimenid
    INNER JOIN                          ndb.data as dt1 on sp.dataid = dt1.dataid
    INNER JOIN                     ndb.variables as var1 on dt1.variableid = var1.variableid
    INNER JOIN                          ndb.taxa as tx1 on var1.taxonid = tx1.taxonid
    INNER JOIN                 ndb.analysisunits AS au on smp.analysisunitid = au.analysisunitid
    INNER JOIN                   ndb.isometadata AS imd on dt.dataid = imd.dataid
    left outer join                 ndb.contacts AS ct on imd.analystid = ct.contactid
    left outer join        ndb.isosubstratetypes on ndb.isometadata.isosubstratetypeid = ndb.isosubstratetypes.isosubstratetypeid
    left outer join ndb.isomaterialanalyzedtypes on ndb.isometadata.isomatanaltypeid = ndb.isomaterialanalyzedtypes.isomatanaltypeid
    left outer join ndb.elementportions on ndb.specimens.portionid = ndb.elementportions.portionid
    left outer join ndb.elementtypes on ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid
    left outer join ndb.elementsymmetries on ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid
    left outer join ndb.elementmaturities on ndb.specimens.maturityid = ndb.elementmaturities.maturityid
  where     (ndb.datasets.datasetid = 21006)
  order by ndb.specimens.specimenid, ndb.taxa.taxonname

$$

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


INSERT INTO @SPECISO (DataID, SpecimenID, AnalysisUnit, Depth, Thickness, Taxon, Element, Variable, Units, Value, SD, MaterialAnalyzed, Substrate, Analyst,
                      Lab, LabNumber, Mass_mg, WeightPercent, AtomicPercent, Reps)
SELECT     TOP (100) PERCENT ndb.Data.DataID, ndb.Specimens.SpecimenID, ndb.AnalysisUnits.AnalysisUnitName AS N'Analysis Unit',
                      ISNULL(CAST(ndb.AnalysisUnits.Depth AS nvarchar), N'') AS Depth,
					  ISNULL(CAST(ndb.AnalysisUnits.Thickness AS nvarchar), N'') AS Thickness,
                      Taxa_1.TaxonName AS Taxon,CONCAT(ndb.ElementTypes.ElementType,
					  CASE WHEN ndb.ElementSymmetries.Symmetry IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementSymmetries.Symmetry) END,
                      CASE WHEN ndb.ElementPortions.Portion IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementPortions.Portion) END,
                      CASE WHEN ndb.ElementMaturities.Maturity IS NULL THEN N'' ELSE CONCAT(N';',ndb.ElementMaturities.Maturity) END) AS Element,
					  ndb.Taxa.TaxonName AS Variable, ndb.VariableUnits.VariableUnits AS Units, ndb.Data.Value,
					  ISNULL(CAST(ndb.IsoSpecimenData.SD AS nvarchar), N'') AS SD,
                      ISNULL(ndb.IsoMaterialAnalyzedTypes.IsoMaterialAnalyzedType,N'') AS N'Material Analyzed',
					  ISNULL(ndb.IsoSubstrateTypes.IsoSubstrateType,N'') AS Substrate,
					  ISNULL(ndb.Contacts.ContactName,N'') AS Analyst,
					  ISNULL(ndb.IsoMetadata.Lab,N'') AS Lab,
					  ISNULL(ndb.IsoMetadata.LabNumber,N'') AS N'Lab Number',
					  ISNULL(CAST(ndb.IsoMetadata.Mass_mg AS nvarchar),N'') AS N'Mass (mg)',
					  ISNULL(CAST(ndb.IsoMetadata.WeightPercent AS nvarchar),N'') AS N'Weight %',
					  ISNULL(CAST(ndb.IsoMetadata.AtomicPercent AS nvarchar),N'') AS N'Atomic %',
					  ISNULL(CAST(ndb.IsoMetadata.Reps AS nvarchar),N'') AS Reps
FROM         ndb.Datasets INNER JOIN
                      ndb.Samples ON ndb.Datasets.DatasetID = ndb.Samples.DatasetID INNER JOIN
                      ndb.Data ON ndb.Samples.SampleID = ndb.Data.SampleID INNER JOIN
                      ndb.Variables ON ndb.Data.VariableID = ndb.Variables.VariableID INNER JOIN
                      ndb.Taxa ON ndb.Variables.TaxonID = ndb.Taxa.TaxonID INNER JOIN
                      ndb.VariableUnits ON ndb.Variables.VariableUnitsID = ndb.VariableUnits.VariableUnitsID INNER JOIN
                      ndb.IsoSpecimenData ON ndb.Data.DataID = ndb.IsoSpecimenData.DataID INNER JOIN
                      ndb.Specimens ON ndb.IsoSpecimenData.SpecimenID = ndb.Specimens.SpecimenID INNER JOIN
                      ndb.Data AS Data_1 ON ndb.Specimens.DataID = Data_1.DataID INNER JOIN
                      ndb.Variables AS Variables_1 ON Data_1.VariableID = Variables_1.VariableID INNER JOIN
                      ndb.Taxa AS Taxa_1 ON Variables_1.TaxonID = Taxa_1.TaxonID INNER JOIN
                      ndb.AnalysisUnits ON ndb.Samples.AnalysisUnitID = ndb.AnalysisUnits.AnalysisUnitID INNER JOIN
                      ndb.IsoMetadata ON ndb.Data.DataID = ndb.IsoMetadata.DataID LEFT OUTER JOIN
                      ndb.Contacts ON ndb.IsoMetadata.AnalystID = ndb.Contacts.ContactID LEFT OUTER JOIN
                      ndb.IsoSubstrateTypes ON ndb.IsoMetadata.IsoSubstrateTypeID = ndb.IsoSubstrateTypes.IsoSubstrateTypeID LEFT OUTER JOIN
                      ndb.IsoMaterialAnalyzedTypes ON ndb.IsoMetadata.IsoMatAnalTypeID = ndb.IsoMaterialAnalyzedTypes.IsoMatAnalTypeID LEFT OUTER JOIN
                      ndb.ElementPortions ON ndb.Specimens.PortionID = ndb.ElementPortions.PortionID LEFT OUTER JOIN
                      ndb.ElementTypes ON ndb.Specimens.ElementTypeID = ndb.ElementTypes.ElementTypeID LEFT OUTER JOIN
                      ndb.ElementSymmetries ON ndb.Specimens.SymmetryID = ndb.ElementSymmetries.SymmetryID LEFT OUTER JOIN
                      ndb.ElementMaturities ON ndb.Specimens.MaturityID = ndb.ElementMaturities.MaturityID
WHERE     (ndb.Datasets.DatasetID = 21006)
ORDER BY ndb.Specimens.SpecimenID, ndb.Taxa.TaxonName

DECLARE @NRows int = @@ROWCOUNT


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
