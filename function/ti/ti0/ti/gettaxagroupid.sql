CREATE OR REPLACE FUNCTION ti.gettaxagroupid(_taxagroup character varying)
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$
select     tgt.taxagroupid, 
            tgt.taxagroup
from        ndb.taxagrouptypes AS tgt
where     (tgt.taxagroup like _taxagroup)

$function$
