CREATE OR REPLACE FUNCTION ti.getaliascontactnames()
 RETURNS TABLE(aliascontactid integer, contactname character varying, currentcontactid integer, currentcontactname character varying)
 LANGUAGE sql
AS $function$
SELECT contacts_1.contactid AS aliascontactid, ndb.contacts.contactname AS aliascontactname, ndb.contacts.contactid AS currentcontactid, 
		contacts_1.contactname AS currentcontactname
FROM ndb.contacts INNER JOIN ndb.contacts AS contacts_1 ON ndb.contacts.aliasid = contacts_1.contactid
WHERE (ndb.contacts.aliasid <> ndb.contacts.contactid);
$function$
