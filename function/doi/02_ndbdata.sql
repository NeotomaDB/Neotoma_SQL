CREATE OR REPLACE FUNCTION doi.ndbdata(
	dsid integer)
    RETURNS TABLE(datasetid integer, data jsonb)
    LANGUAGE sql
AS $function$
	WITH dssamples AS (
		SELECT
		ds.datasetid,
		jsonb_build_object('sampleid', dsd.sampleid,
							'samplename', smp.samplename,
							'analysisunitid', anu.analysisunitid,
							'analysisunitname', anu.analysisunitname,
							'thickness', anu.thickness,
							'igsn', anu.igsn,
							'depth', anu.depth,
							'datum', jsonb_agg(DISTINCT jsonb_build_object('value', dt.value,
											'variablename', tx.taxonname,
												'taxonid', tx.taxonid,
											'taxongroup', txg.taxagroup,
										'ecologicalgroup', ecg.ecolgroupid,
												'element', ve.variableelement,
											'elementtype', vt.elementtype,
												'symmetry', vs.symmetry,
												'context', vc.variablecontext,
													'units', vru.variableunits)),
							'sampleanalyst', json_agg(DISTINCT jsonb_build_object('contactid', cnt.contactid,
																				'contactname', cnt.contactname,
																				'familyname', cnt.familyname,
																				'firstname', cnt.givennames,
																					'initials', cnt.leadinginitials)),
							'ages', jsonb_agg(
										DISTINCT jsonb_build_object('chronologyid', ch.chronologyid,
														'chronologyname', ch.chronologyname,
														'agetype', cht.agetype,
														'age', sma.age,
														'ageyounger', sma.ageyounger,
														'ageolder', sma.ageolder))) AS sampledata
		FROM
		ndb.datasets AS ds
		LEFT OUTER JOIN ndb.dsdatasample AS dsd ON dsd.datasetid = ds.datasetid
		LEFT OUTER JOIN ndb.data AS dt ON dt.dataid = dsd.dataid
		LEFT OUTER JOIN ndb.variables as var ON var.variableid = dsd.variableid
		LEFT OUTER JOIN ndb.taxa AS tx ON tx.taxonid = var.taxonid
			LEFT OUTER JOIN ndb.taxagrouptypes AS txg ON txg.taxagroupid = tx.taxagroupid
			LEFT OUTER JOIN ndb.ecolgroups AS ecg ON ecg.taxonid = tx.taxonid
		LEFT OUTER JOIN ndb.variableunits AS vru ON vru.variableunitsid = var.variableunitsid
		LEFT OUTER JOIN ndb.samples AS smp ON smp.sampleid = dsd.sampleid
			LEFT OUTER JOIN ndb.sampleanalysts AS san ON san.sampleid = smp.sampleid
			LEFT JOIN ndb.contacts AS cnt ON cnt.contactid = san.contactid
		LEFT OUTER JOIN ndb.analysisunits AS anu ON anu.analysisunitid = smp.analysisunitid
		LEFT JOIN ndb.variableelements AS ve ON ve.variableelementid = var.variableelementid
			LEFT OUTER JOIN ndb.elementsymmetries AS vs ON vs.symmetryid = ve.symmetryid
			LEFT OUTER JOIN ndb.elementtypes AS vt ON vt.elementtypeid = ve.elementtypeid
		LEFT JOIN ndb.variablecontexts AS vc ON vc.variablecontextid = var.variablecontextid
		LEFT OUTER JOIN ndb.sampleages AS sma ON sma.sampleid = smp.sampleid
		LEFT OUTER JOIN ndb.chronologies AS ch ON sma.chronologyid = ch.chronologyid
		LEFT OUTER JOIN ndb.agetypes AS cht ON cht.agetypeid = ch.agetypeid
		WHERE
		ds.datasetid = dsid
		GROUP BY ds.datasetid,
				dsd.sampleid,
				smp.sampleid, 
				anu.analysisunitid
		)
		SELECT
		ds.datasetid,
			jsonb_build_object('samples', json_agg(dss.sampledata)) AS data
		FROM
		ndb.datasets AS ds
		JOIN dssamples AS dss ON ds.datasetid = dss.datasetid
			JOIN (SELECT datasetid,
						site::jsonb
						FROM doi.datasetinfo(dsid)) AS dsinfo ON dsinfo.datasetid = ds.datasetid
		WHERE ds.datasetid = dsid
		GROUP BY ds.datasetid, dsinfo.site

$function$;

CREATE OR REPLACE FUNCTION doi.ndbdata(
	dsid integer[])
    RETURNS TABLE(datasetid integer, data jsonb)
    LANGUAGE sql
AS $function$
WITH dssamples AS (
	SELECT
	  ds.datasetid,
	  jsonb_build_object('sampleid', dsd.sampleid,
	  					 'samplename', smp.samplename,
	  					 'analysisunitid', anu.analysisunitid,
						 'analysisunitname', anu.analysisunitname,
						 'thickness', anu.thickness,
						 'igsn', anu.igsn,
						 'depth', anu.depth,
							 'datum', jsonb_agg(DISTINCT jsonb_build_object('value', dt.value,
										 'variablename', tx.taxonname,
										 'taxonid', tx.taxonid,
									'taxongroup', txg.taxagroup,
									'ecologicalgroup', ecg.ecolgroupid,
										 'element', ve.variableelement,
										 'elementtype', vt.elementtype,
										 'symmetry', vs.symmetry,
										 'context', vc.variablecontext,
										 'units', vru.variableunits)),
							 'sampleanalyst', json_agg(DISTINCT jsonb_build_object('contactid', cnt.contactid,
																							'contactname', cnt.contactname,
																							'familyname', cnt.familyname,
																							'firstname', cnt.givennames,
																							'initials', cnt.leadinginitials)),
							 'ages', jsonb_agg(
									DISTINCT jsonb_build_object('chronologyid', ch.chronologyid,
													  'chronologyname', ch.chronologyname,
													  'agetype', cht.agetype,
													  'age', sma.age,
													  'ageyounger', sma.ageyounger,
													  'ageolder', sma.ageolder))) AS sampledata
	FROM
	  ndb.datasets AS ds
	  LEFT OUTER JOIN ndb.dsdatasample AS dsd ON dsd.datasetid = ds.datasetid
	  LEFT OUTER JOIN ndb.data AS dt ON dt.dataid = dsd.dataid
	  LEFT OUTER JOIN ndb.variables as var ON var.variableid = dsd.variableid
	  LEFT OUTER JOIN ndb.taxa AS tx ON tx.taxonid = var.taxonid
		LEFT OUTER JOIN ndb.taxagrouptypes AS txg ON txg.taxagroupid = tx.taxagroupid
		LEFT OUTER JOIN ndb.ecolgroups AS ecg ON ecg.taxonid = tx.taxonid
	  LEFT OUTER JOIN ndb.variableunits AS vru ON vru.variableunitsid = var.variableunitsid
	  LEFT OUTER JOIN ndb.samples AS smp ON smp.sampleid = dsd.sampleid
		LEFT OUTER JOIN ndb.sampleanalysts AS san ON san.sampleid = smp.sampleid
		LEFT JOIN ndb.contacts AS cnt ON cnt.contactid = san.contactid
	  LEFT OUTER JOIN ndb.analysisunits AS anu ON anu.analysisunitid = smp.analysisunitid
	  LEFT JOIN ndb.variableelements AS ve ON ve.variableelementid = var.variableelementid
		LEFT OUTER JOIN ndb.elementsymmetries AS vs ON vs.symmetryid = ve.symmetryid
		LEFT OUTER JOIN ndb.elementtypes AS vt ON vt.elementtypeid = ve.elementtypeid
	  LEFT JOIN ndb.variablecontexts AS vc ON vc.variablecontextid = var.variablecontextid
	  LEFT OUTER JOIN ndb.sampleages AS sma ON sma.sampleid = smp.sampleid
		LEFT OUTER JOIN ndb.chronologies AS ch ON sma.chronologyid = ch.chronologyid
	  LEFT OUTER JOIN ndb.agetypes AS cht ON cht.agetypeid = ch.agetypeid
	WHERE
	  ds.datasetid = ANY(dsid)
	GROUP BY ds.datasetid,
			  dsd.sampleid,
			  smp.sampleid,
			  anu.analysisunitid
	)
	SELECT
	  ds.datasetid,
		jsonb_build_object('site', dsinfo.site,
	                    'samples', json_agg(dss.sampledata)) AS data

	FROM
	  ndb.datasets AS ds
	  JOIN dssamples AS dss ON ds.datasetid = dss.datasetid
		JOIN (SELECT datasetid, site::jsonb FROM doi.datasetinfo(dsid)) AS dsinfo ON dsinfo.datasetid = ds.datasetid
	WHERE ds.datasetid = ANY(dsid)
	GROUP BY ds.datasetid, dsinfo.site

$function$;
