CREATE OR REPLACE FUNCTION ti.gettaxagrouptypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       ndb.taxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup
 FROM ndb.taxagrouptypes;
$function$