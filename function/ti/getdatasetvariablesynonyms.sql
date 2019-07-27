CREATE OR REPLACE FUNCTION ti.getdatasetvariablesynonyms(_datasetid integer, _variableid integer)
 RETURNS TABLE(synonymyid integer, reftaxonname character varying, fromcontributor boolean, publicationid integer, notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.synonymy.synonymyid, ndb.taxa.taxonname as reftaxonname, ndb.synonymy.fromcontributor, ndb.synonymy.publicationid,
		ndb.synonymy.notes
FROM ndb.synonymy INNER JOIN
	ndb.taxa ON ndb.synonymy.reftaxonid = ndb.taxa.taxonid INNER JOIN
	ndb.samples INNER JOIN
	ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
	ndb.variables ON ndb.data.variableid = ndb.variables.variableid ON ndb.synonymy.datasetid = ndb.samples.datasetid AND 
	ndb.synonymy.taxonid = ndb.variables.taxonid
WHERE (ndb.samples.datasetid = _datasetid) AND (ndb.data.variableid = _variableid)
GROUP BY ndb.synonymy.synonymyid, ndb.taxa.taxonname, ndb.synonymy.publicationid, ndb.synonymy.notes, ndb.synonymy.fromcontributor
ORDER BY ndb.synonymy.synonymyid  
$function$
