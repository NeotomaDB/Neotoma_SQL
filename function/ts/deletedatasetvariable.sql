DROP FUNCTION ts.deletedatasetvariable (integer, integer);

CREATE OR REPLACE FUNCTION ts.deletedatasetvariable (_datasetid integer, _variableid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.data AS da
WHERE da.dataid IN (SELECT da.dataid
                 FROM ndb.samples AS ss INNER JOIN
                      ndb.data 	  AS da ON ss.sampleid = da.sampleid
                 WHERE (ss.datasetid = _datasetid) AND (da.variableid = _variableid));
$function$
