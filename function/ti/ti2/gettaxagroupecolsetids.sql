CREATE OR REPLACE FUNCTION ti.gettaxagroupecolsetids(_taxagroupid character varying)
 RETURNS TABLE(taxagroupid character varying, ecolsetid integer)
 LANGUAGE sql
AS $function$
select     tx.taxagroupid, 
            eg.ecolsetid
from       ndb.ecolgroups AS eg 
  inner join ndb.taxa AS tx on eg.taxonid = tx.taxonid
group by tx.taxagroupid, eg.ecolsetid
having      (tx.taxagroupid = _taxagroupid)

$function$
