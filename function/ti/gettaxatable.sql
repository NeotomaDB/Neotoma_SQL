CREATE OR REPLACE FUNCTION ti.gettaxatable()
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname character varying, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, 
           validatorid, validatedate::varchar(10) as validatedate, notes
FROM ndb.taxa;
$function$
