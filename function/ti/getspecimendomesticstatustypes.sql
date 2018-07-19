CREATE OR REPLACE FUNCTION ti.getspecimendomesticstatustypes()
 RETURNS TABLE(domesticstatusid integer, domesticstatus character varying)
 LANGUAGE sql
AS $function$
SELECT      domesticstatusid, domesticstatus
 FROM ndb.specimendomesticstatustypes;
$function$
