CREATE OR REPLACE FUNCTION ts.updategeochrondatasetpubs(_datasetid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
WITH geodp AS (
    SELECT DISTINCT dsp.datasetid, dsp.publicationid, gc.geochronid
    FROM ndb.datasetpublications AS dsp
    INNER JOIN ndb.samples AS smp ON dsp.datasetid = smp.datasetid
    INNER JOIN ndb.geochronology AS gc ON gc.sampleid = smp.sampleid
    WHERE dsp.datasetid = _datasetid)
UPDATE ndb.geochronpublications AS gp
SET publicationid = geodp.publicationid
FROM geodp
WHERE  geodp.geochronid = gp.geochronid;
$function$;