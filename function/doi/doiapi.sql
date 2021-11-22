CREATE OR REPLACE FUNCTION doi.doiapi(dsid integer[])
 RETURNS TABLE(site jsonb)
 LANGUAGE sql
AS $function$
WITH chronmeta AS (
	SELECT datasetid,
				json_agg(json_build_object('chronology', chronologies)) AS chronologies
	FROM doi.chronmeta(dsid)
	GROUP BY datasetid
),
ids AS (
  SELECT * FROM UNNEST(dsid) AS dsid
),
datameta AS (
  SELECT * FROM doi.ndbdata(dsid)
)
SELECT jsonb_build_object(   'datasetid', ids.dsid,
	                      'chronologies', chr.chronologies,
	                              'data', dt.data) AS site
FROM
	datameta  AS dt
	JOIN chronmeta AS chr ON dt.datasetid = chr.datasetid
											JOIN ids AS ids ON ids.dsid = dt.datasetid
$function$;
