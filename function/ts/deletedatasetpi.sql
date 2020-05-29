CREATE OR REPLACE FUNCTION ts.deletedatasetpi(_datasetid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$

	DELETE FROM ndb.datasetpis AS dspi
	WHERE dspi.datasetid = _datasetid AND dspi.contactid = _contactid;

	WITH newrank AS (
	  SELECT (RANK() OVER (ORDER BY piorder)) AS ranker
	  FROM ndb.datasetpis AS dspi
	  WHERE dspi.datasetid = _datasetid
	)
	UPDATE ndb.datasetpis AS dspi
	SET piorder = sub.ranker FROM
  (SELECT ranker FROM newrank) AS sub
	WHERE dspi.datasetid = _datasetid

$function$
