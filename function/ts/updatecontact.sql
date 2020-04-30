CREATE OR REPLACE FUNCTION ts.updatecontact(_contactid integer,
                                              _aliasid integer           DEFAULT NULL::integer,
                                          _contactname character varying DEFAULT NULL::character varying,
                                             _statusid integer           DEFAULT NULL::integer,
                                           _familyname character varying DEFAULT NULL::character varying,
                                             _initials character varying DEFAULT NULL::character varying,
                                           _givennames character varying DEFAULT NULL::character varying,
                                               _suffix character varying DEFAULT NULL::character varying,
                                                _title character varying DEFAULT NULL::character varying,
                                                _phone character varying DEFAULT NULL::character varying,
                                                  _fax character varying DEFAULT NULL::character varying,
                                                _email character varying DEFAULT NULL::character varying,
                                                  _url character varying DEFAULT NULL::character varying,
                                              _address character varying DEFAULT NULL::character varying,
                                                _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.contacts AS ct
	SET       aliasid = _aliasid,
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
$function$
