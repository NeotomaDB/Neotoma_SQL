CREATE OR REPLACE FUNCTION ti.gettaxabynamelist(_taxanames text)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname text, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes text)
 LANGUAGE sql
AS $function$
       select t.taxonid, t.taxoncode, t.taxonname, t.author, t.valid, t.highertaxonid, t.extinct, t.taxagroupid, t.publicationid, 
              t.validatorid, t.validatedate::varchar(10) as validatedate, t.notes
       from ndb.taxa t
       where t.taxonname ILIKE ANY (string_to_array(_taxanames,'$'));
$function$
