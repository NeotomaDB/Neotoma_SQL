CREATE OR REPLACE FUNCTION ti.getcontactstatusestable()
 RETURNS TABLE(contactstatusid integer, contactstatus character varying, statusdescription character varying)
 LANGUAGE sql
AS $function$
SELECT contactstatusid, contactstatus, statusdescription
FROM ndb.contactstatuses
$function$
