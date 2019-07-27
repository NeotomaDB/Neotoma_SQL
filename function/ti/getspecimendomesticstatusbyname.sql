CREATE OR REPLACE FUNCTION ti.getspecimendomesticstatusbyname(_domesticstatus character varying)
 RETURNS TABLE(domesticstatusid integer, domesticstatus character varying)
 LANGUAGE sql
AS $function$

SELECT
	sds.domesticstatusid,
	sds.domesticstatus
FROM          ndb.specimendomesticstatustypes AS sds
WHERE    sds.domesticstatus = _domesticstatus

$function$
