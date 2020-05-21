CREATE OR REPLACE FUNCTION ti.getsampletaxoncount(_sampleid integer, _taxonid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$

SELECT COUNT(*)::integer AS count FROM (
	SELECT m.sampleid, v.taxonid 
	FROM ndb.samples as m INNER JOIN 
		ndb.data AS d ON m.sampleid = d.sampleid INNER JOIN 
		ndb.variables AS v ON d.variableid = v.variableid 
	WHERE (m.sampleid = _sampleid) AND (v.taxonid = _taxonid)
) x

$function$
