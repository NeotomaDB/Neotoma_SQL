CREATE OR REPLACE FUNCTION ts.insertaggregatesample(_aggregatedatasetid integer, _sampleid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.aggregatesamples
	(aggregatedatasetid, sampleid)
VALUES (_aggregatedatasetid, _sampleid)
$function$
