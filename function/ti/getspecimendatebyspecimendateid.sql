CREATE OR REPLACE FUNCTION ti.getspecimendatebyspecimendateid
RETURNS TABLE()
LANGUAGE sql
AS $function$


$function$


CREATE PROCEDURE (@SPECIMENDATEID int)
AS
SELECT     NDB.SpecimenDates.SpecimenID, NDB.SpecimenDates.TaxonID, NDB.Taxa.TaxonName, NDB.SpecimenDates.ElementTypeID, NDB.ElementTypes.ElementType, 
                      NDB.SpecimenDates.FractionID, NDB.FractionDated.Fraction, NDB.SpecimenDates.SampleID, NDB.SpecimenDates.Notes
FROM       NDB.SpecimenDates INNER JOIN
                      NDB.Taxa ON NDB.SpecimenDates.TaxonID = NDB.Taxa.TaxonID LEFT OUTER JOIN
                      NDB.FractionDated ON NDB.SpecimenDates.FractionID = NDB.FractionDated.FractionID LEFT OUTER JOIN
                      NDB.ElementTypes ON NDB.SpecimenDates.ElementTypeID = NDB.ElementTypes.ElementTypeID
WHERE     (NDB.SpecimenDates.SpecimenDateID = @SPECIMENDATEID)
