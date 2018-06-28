CREATE OR REPLACE FUNCTION ti.gettaxatable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, 
           validatorid, convert
nvarchar
10
,validatedate,120
 as validatedate, notes
 FROM ndb.taxa;
$function$