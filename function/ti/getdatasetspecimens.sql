CREATE OR REPLACE FUNCTION ti.getdatasetspecimens(_datasetid integer)
 RETURNS TABLE(specimenid integer, dataid integer, elementtype character varying, symmetry character varying, portion character varying, maturity character varying, sex character varying, domesticstatus character varying, preservative character varying, nisp double precision, repository character varying, specimennr character varying, fieldnr character varying, arctosnr character varying, notes text, taxonname character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$

SELECT ndb.specimens.specimenid, ndb.specimens.dataid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion,
		ndb.elementmaturities.maturity, ndb.specimensextypes.sex, ndb.specimendomesticstatustypes.domesticstatus, ndb.specimens.preservative,
		ndb.specimens.nisp, ndb.repositoryinstitutions.repository, ndb.specimens.specimennr, ndb.specimens.fieldnr, ndb.specimens.arctosnr,
		ndb.specimens.notes, ndb.taxa.taxonname, ndb.taxagrouptypes.taxagroup
FROM ndb.samples INNER JOIN
		ndb.data on ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
		ndb.specimens on ndb.data.dataid = ndb.specimens.dataid INNER JOIN
		ndb.variables on ndb.data.variableid = ndb.variables.variableid INNER JOIN
		ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid INNER JOIN
		ndb.taxagrouptypes on ndb.taxa.taxagroupid = ndb.taxagrouptypes.taxagroupid LEFT OUTER JOIN
		ndb.repositoryinstitutions on ndb.specimens.repositoryid = ndb.repositoryinstitutions.repositoryid LEFT OUTER JOIN
		ndb.specimendomesticstatustypes on ndb.specimens.domesticstatusid = ndb.specimendomesticstatustypes.domesticstatusid LEFT OUTER JOIN
		ndb.specimensextypes on ndb.specimens.sexid = ndb.specimensextypes.sexid LEFT OUTER JOIN
		ndb.elementmaturities on ndb.specimens.maturityid = ndb.elementmaturities.maturityid LEFT OUTER JOIN
		ndb.elementsymmetries on ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid LEFT OUTER JOIN
		ndb.elementtypes on ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid LEFT OUTER JOIN
		ndb.elementportions on ndb.specimens.portionid = ndb.elementportions.portionid
WHERE ndb.samples.datasetid = $1;

$function$
