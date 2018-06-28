CREATE OR REPLACE FUNCTION ti.getspecimendomesticstatustypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      domesticstatusid, domesticstatus
 FROM ndb.specimendomesticstatustypes;
$function$