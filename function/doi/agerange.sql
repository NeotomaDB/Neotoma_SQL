CREATE OR REPLACE FUNCTION doi.agerange(dsid integer)
RETURNS TABLE(datasetid integer, ages json)
LANGUAGE 'sql'

COST 100
VOLATILE
ROWS 1000
AS $BODY$
SELECT dts.datasetid, json_agg(jsonb_build_object('ageyoung', agerange.younger,
                                'ageold', agerange.older,
                                 'units', agetypes.agetype)) AS agerange
FROM
ndb.datasets AS dts
LEFT OUTER JOIN ndb.dsageranges AS agerange ON dts.datasetid = agerange.datasetid
LEFT OUTER JOIN ndb.agetypes AS agetypes ON agetypes.agetypeid = agerange.agetypeid
WHERE dts.datasetid = dsid
GROUP BY dts.datasetid;
$BODY$;

CREATE OR REPLACE FUNCTION doi.agerange(dsid integer[])
RETURNS TABLE(datasetid integer, ages json)
LANGUAGE 'sql'

COST 100
VOLATILE
ROWS 1000
AS $BODY$
SELECT dts.datasetid, json_agg(jsonb_build_object('ageyoung', agerange.younger,
                                'ageold', agerange.older,
                                 'units', agetypes.agetype)) AS agerange
FROM
ndb.datasets AS dts
LEFT OUTER JOIN ndb.dsageranges AS agerange ON dts.datasetid = agerange.datasetid
LEFT OUTER JOIN ndb.agetypes AS agetypes ON agetypes.agetypeid = agerange.agetypeid
WHERE dts.datasetid = ANY(dsid)
GROUP BY dts.datasetid;
$BODY$;


ALTER FUNCTION doi.agerange(integer)
    OWNER TO sug335;

ALTER FUNCTION doi.agerange(integer[])
    OWNER TO sug335;
