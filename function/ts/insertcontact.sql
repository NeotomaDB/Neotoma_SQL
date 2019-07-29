CREATE OR REPLACE FUNCTION ts.insertcontact(_aliasid integer DEFAULT NULL::integer, _contactname character varying DEFAULT NULL::character varying, _statusid integer DEFAULT NULL::integer, _familyname character varying DEFAULT NULL::character varying, _initials character varying DEFAULT NULL::character varying, _givennames character varying DEFAULT NULL::character varying, _suffix character varying DEFAULT NULL::character varying, _title character varying DEFAULT NULL::character varying, _phone character varying DEFAULT NULL::character varying, _fax character varying DEFAULT NULL::character varying, _email character varying DEFAULT NULL::character varying, _url character varying DEFAULT NULL::character varying, _address character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.contacts (aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes)
VALUES      (_aliasid, _contactname, _statusid, _familyname, _initials, _givennames, _suffix, _title, _phone, _fax, _email, _url, _address, _notes)
RETURNING contactid

$function$
