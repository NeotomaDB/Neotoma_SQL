CREATE OR REPLACE FUNCTION ti.getaliascontactnames()
 RETURNS TABLE(aliascontactid integer,
               aliascontactname character varying,
               currentcontactid integer,
               currentcontactname character varying)
 LANGUAGE sql
AS $function$
SELECT cnta.contactid AS aliascontactid,
       cnt.contactname AS aliascontactname,
       cnt.contactid AS currentcontactid,
		   cnta.contactname AS currentcontactname
FROM ndb.contacts AS cnt
  INNER JOIN ndb.contacts AS cnta ON cnt.aliasid = cnta.contactid
WHERE (cnt.aliasid <> cnt.contactid);
$function$
