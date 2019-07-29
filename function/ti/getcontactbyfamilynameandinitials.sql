CREATE OR REPLACE FUNCTION ti.getcontactbyfamilynameandinitials(_familyname character varying, _initials character varying)
 RETURNS TABLE(contactid integer, aliasid integer, contactname character varying, contactstatusid integer, familyname character varying, leadinginitials character varying, givennames character varying, suffix character varying, title character varying, phone character varying, fax character varying, email character varying, url character varying, address text, notes text, recdatecreated timestamp without time zone, recdatemodified timestamp without time zone)
 LANGUAGE sql
AS $function$
SELECT ndb.contacts.* 
FROM ndb.contacts
WHERE familyname ILIKE _familyname AND leadinginitials ILIKE _initials;
$function$
