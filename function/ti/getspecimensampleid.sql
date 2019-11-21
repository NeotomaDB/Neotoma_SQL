CREATE OR REPLACE FUNCTION ti.getspecimensampleid(_specimenid INTEGER)
RETURNS TABLE(sampleid INTEGER)
LANGUAGE sql
AS $function$

SELECT ndb.data.sampleid
FROM ndb.specimens INNER JOIN 
		ndb.data ON ndb.specimens.dataid = ndb.data.dataid
WHERE ndb.specimens.specimenid = $1

$function$
