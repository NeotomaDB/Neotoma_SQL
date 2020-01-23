CREATE OR REPLACE FUNCTION ti.getcollector(_collectionunitid integer)
 RETURNS TABLE(contactid integer, aliasid integer, contactname character varying, contactstatusid integer, familyname character varying, leadinginitials character varying, givennames character varying, suffix character varying, title character varying, phone character varying, fax character varying, email character varying, url character varying, address text, notes text)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT ndb.contacts.contactid, ndb.contacts.aliasid, ndb.contacts.contactname, ndb.contacts.contactstatusid, ndb.contacts.familyname, 
		   ndb.contacts.leadinginitials, ndb.contacts.givennames, ndb.contacts.suffix, ndb.contacts.title, ndb.contacts.phone, ndb.contacts.fax, ndb.contacts.email, 
		   ndb.contacts.url, ndb.contacts.address, ndb.contacts.notes
	FROM   ndb.collectors INNER JOIN ndb.contacts ON ndb.collectors.contactid = ndb.contacts.contactid
	WHERE  ndb.collectors.collectionunitid = _collectionunitid;
END;
$function$
