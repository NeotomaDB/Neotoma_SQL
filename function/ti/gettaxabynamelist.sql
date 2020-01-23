CREATE OR REPLACE FUNCTION ti.gettaxabynamelist(_taxanames text)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname character varying, author character varying, valid boolean, highertaxonid integer, extinct boolean, taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying, notes text)
 LANGUAGE plpgsql
AS $function$
Declare taxaarray text[];
	
  
BEGIN


taxaarray := string_to_array(_taxanames,'$');

Return query 

select t.taxonid, t.taxoncode, t.taxonname, t.author, t.valid, t.highertaxonid, t.extinct, t.taxagroupid, t.publicationid, 
       t.validatorid, t.validatedate::varchar(10) as validatedate, t.notes
from ndb.taxa t
where t.taxonname ILIKE ANY (taxaarray);



END
$function$
