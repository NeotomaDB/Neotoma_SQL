CREATE OR REPLACE FUNCTION ti.gettaxagroupcodes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      top 
2147483647
 ndb.taxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolsettypes.ecolsetid, ndb.ecolsettypes.ecolsetname, 
                      ndb.ecolgrouptypes.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
 FROM ndb.taxa inner join
                      ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
                      ndb.ecolgrouptypes on ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid inner join
                      ndb.ecolsettypes on ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid right outer join
                      ndb.taxagrouptypes on ndb.taxa.taxagroupid = ndb.taxagrouptypes.taxagroupid
group by ndb.taxagrouptypes.taxagroup, ndb.ecolgrouptypes.ecolgroup, ndb.taxagrouptypes.taxagroupid, ndb.ecolgrouptypes.ecolgroupid, 
                      ndb.ecolsettypes.ecolsetid, ndb.ecolsettypes.ecolsetname
order by ndb.taxagrouptypes.taxagroup, ndb.ecolgrouptypes.ecolgroup;
$function$