CREATE OR REPLACE FUNCTION doi.doifreeze(dsid integer[])
 RETURNS TABLE(datasetid integer, record json)
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
SELECT ids.dsid AS datasetid,
			 json_strip_nulls(json_build_object('chronologies', jsonb_build_object('chronologies', chr.chronologies),
															'data', dt.data)) AS record
FROM
	datameta  AS dt
	JOIN chronmeta AS chr ON dt.datasetid = chr.datasetid
											JOIN ids AS ids ON ids.dsid = dt.datasetid
$function$
