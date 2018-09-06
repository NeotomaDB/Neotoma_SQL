CREATE OR REPLACE FUNCTION ti.getcontactbyid(_contactid integer)
 RETURNS TABLE(contactid integer, aliasid integer, contactname character varying, contactstatusid integer, familyname character varying, leadinginitials character varying, givennames character varying, suffix character varying, title character varying, phone character varying, fax character varying, email character varying, url character varying, address text, notes text)
 LANGUAGE sql
AS $function$
SELECT contactid, aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes
FROM ndb.contacts
WHERE contactid = _contactid;
$function$
