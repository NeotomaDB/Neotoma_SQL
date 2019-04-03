CREATE OR REPLACE FUNCTION ti.getdatasetsynonyms(_datasetid integer)
 RETURNS TABLE(synonymyid integer, validname character varying, refname character varying, fromcontributor boolean, publicationid integer, notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.synonymy.synonymyid, ndb.taxa.taxonname AS validname, taxa_1.taxonname AS refname, ndb.synonymy.fromcontributor,
		ndb.synonymy.publicationid, ndb.synonymy.notes
FROM ndb.synonymy INNER JOIN ndb.taxa ON ndb.synonymy.taxonid = ndb.taxa.taxonid INNER JOIN
		ndb.taxa AS taxa_1 ON ndb.synonymy.reftaxonid = taxa_1.taxonid
WHERE ndb.synonymy.datasetid = _datasetid
ORDER BY ndb.synonymy.synonymyid
$function$
