CREATE OR REPLACE FUNCTION doi.doifreeze(
	dsid integer)
		RETURNS TABLE (datasetid integer, frozendata json)
		LANGUAGE 'sql'

		COST 100
		VOLATILE
AS $BODY$
WITH chronmeta AS (
	SELECT datasetid,
				json_agg(json_build_object('chronology', chronologies)) AS chronologies
	FROM doi.chronmeta(dsid)
	GROUP BY datasetid
),
datameta AS (
SELECT * FROM doi.ndbdata(dsid)
)

SELECT dsid AS datasetid,
			 json_strip_nulls(json_build_object('chronologies', json_build_object('chronologies', chr.chronologies),
							'data', dt.data)) AS frozendata
FROM
	datameta  AS dt
	JOIN chronmeta AS chr ON dt.datasetid = chr.datasetid

$BODY$;

CREATE OR REPLACE FUNCTION doi.doifreeze(
	dsid integer[])
		RETURNS TABLE (datasetid integer, frozendata json)
		LANGUAGE 'sql'

		COST 100
		VOLATILE
AS $BODY$
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
															'data', dt.data)) AS frozendata
FROM
	datameta  AS dt
	JOIN chronmeta AS chr ON dt.datasetid = chr.datasetid
											JOIN ids AS ids ON ids.dsid = dt.datasetid

$BODY$;

ALTER FUNCTION doi.doifreeze(integer)
		OWNER TO sug335;

ALTER FUNCTION doi.doifreeze(integer[])
		OWNER TO sug335;
