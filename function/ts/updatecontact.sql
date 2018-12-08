CREATE OR REPLACE FUNCTION ts.updatecontact(
  _contactid integer,
  _aliasid integer = null,
  _contactname character varying = null,
  _statusid integer = null,
  _familyname character varying = null,
  _initials character varying = null,
  _givennames character varying = null,
  _suffix character varying = null,
  _title character varying = null,
  _phone character varying = null,
  _fax character varying = null,
  _email character varying = null,
  _url character varying = null,
  _address character varying = null,
  _notes character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.contacts AS ct
	SET   aliasid = _aliasid,
    contactname = _contactname,
    contactstatusid = _statusid,
    familyname = _familyname,
    leadinginitials = _initials,
    givennames = _givennames,
    suffix = _suffix,
    title = _title,
    phone = _phone,
    fax = _fax,
    email = _email,
    url = _url,
    address = _address,
    notes = _notes
	WHERE ct.contactid = _contactid
$function$;
