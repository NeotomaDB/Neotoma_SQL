CREATE OR REPLACE FUNCTION ts.insertformtaxon(_taxonid integer, _affinityid integer, _publicationid integer, _systematicdescription boolean)
 RETURNS integer
 LANGUAGE sql
AS $function$
 INSERT INTO ndb.formtaxa (taxonid, affinityid, publicationid, systematicdescription)
 VALUES (_taxonid, _affinityid, _publicationid, _systematicdescription)
 RETURNING formtaxa.formtaxonid
$function$
