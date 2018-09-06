CREATE OR REPLACE FUNCTION ti.gettaxagroupbyid(_taxagroupid character varying)
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$
select     tgt.taxagroupid, tgt.taxagroup
from         ndb.taxagrouptypes AS tgt
where     tgt.taxagroupid = _taxagroupid

$function$
