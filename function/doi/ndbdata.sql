
CREATE OR REPLACE FUNCTION doi.ndbdata(dsid integer)
RETURNS TABLE (datasetid integer, sampledata json)
AS
$function$
WITH dssamples AS (
	SELECT
	  ds.datasetid,
	  json_build_object('sampleid', dsd.sampleid,
						'depth', anu.depth,
							 'counts', json_agg(json_build_object('value', dt.value,
										 'variablename', tx.taxonname,
										 'element', ve.variableelement,
										 'context', vc.variablecontext,
										 'units', vru.variableunits)),
							 'ages', json_agg(
									json_build_object('chronologyid', ch.chronologyid,
													  'chronologyname', ch.chronologyname,
													  'agetype', cht.agetype,
													  'age', sma.age,
													  'ageyounger', sma.ageyounger,
													  'ageolder', sma.ageolder))) AS sampledata
	FROM
	  ndb.datasets AS ds
	  JOIN ndb.dsdatasample AS dsd ON dsd.datasetid = ds.datasetid
	  JOIN ndb.data AS dt ON dt.dataid = dsd.dataid
	  JOIN ndb.variables as var ON var.variableid = dsd.variableid
	  JOIN ndb.taxa AS tx ON tx.taxonid = var.taxonid
	  JOIN ndb.variableunits AS vru ON vru.variableunitsid = var.variableunitsid
	  JOIN ndb.samples AS smp ON smp.sampleid = dsd.sampleid
	  JOIN ndb.analysisunits AS anu ON anu.analysisunitid = smp.analysisunitid
	  LEFT JOIN ndb.variableelements AS ve ON ve.variableelementid = var.variableelementid
	  LEFT JOIN ndb.variablecontexts AS vc ON vc.variablecontextid = var.variablecontextid
	  JOIN ndb.sampleages AS sma ON sma.sampleid = smp.sampleid
	  JOIN ndb.chronologies AS ch ON sma.chronologyid = ch.chronologyid
	  JOIN ndb.agetypes AS cht ON cht.agetypeid = ch.agetypeid
	WHERE
	  ds.datasetid = 684
	GROUP BY ds.datasetid,
			  dsd.sampleid,
			  anu.depth
	)
	SELECT
	  ds.datasetid,
	  json_agg(dss.sampledata)
	FROM
	  ndb.datasets AS ds
	  JOIN dssamples AS dss ON ds.datasetid = dss.datasetid
	WHERE ds.datasetid = 684
	GROUP BY ds.datasetid
$function$ LANGUAGE sql;
