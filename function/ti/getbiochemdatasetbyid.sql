CREATE OR REPLACE FUNCTION ti.getbiochemdatasetbyid(_datasetid integer)
 RETURNS TABLE(sampleid integer, analysisunitname character varying, samplename character varying, sampledate character varying, taxonname character varying, variable character varying, variableelement character varying, variableunits character varying, value double precision)
 LANGUAGE plpgsql
AS $function$
DECLARE
	dstypeid int := (SELECT datasettypeid FROM ndb.datasets WHERE datasetid = _datasetid);
BEGIN
	IF dstypeid = 27
	THEN
		RETURN QUERY
		SELECT ndb.data.sampleid, ndb.analysisunits.analysisunitname, ndb.samples.samplename, ndb.samples.sampledate::varchar(10) as sampledate,
						  ndb.taxa.taxonname, taxa_1.taxonname as variable, ndb.variableelements.variableelement, ndb.variableunits.variableunits, ndb.data.value
		FROM  ndb.samples INNER JOIN
			ndb.taxa ON ndb.samples.taxonid = ndb.taxa.taxonid INNER JOIN
			ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid INNER JOIN
			ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
			ndb.variables ON ndb.data.variableid = ndb.variables.variableid INNER JOIN
			ndb.taxa AS taxa_1 ON ndb.variables.taxonid = taxa_1.taxonid LEFT OUTER JOIN
			ndb.variableunits ON ndb.variables.variableunitsid = ndb.variableunits.variableunitsid LEFT OUTER JOIN
			ndb.variableelements ON ndb.variables.variableelementid = ndb.variableelements.variableelementid
		WHERE ndb.samples.datasetid = _datasetid
		ORDER BY ndb.data.sampleid;
	ELSE
		RAISE NOTICE 'dataset is not biochemistry';
	END IF;

    END;
$function$
