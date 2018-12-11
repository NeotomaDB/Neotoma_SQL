CREATE OR REPLACE FUNCTION ts.insertcontact(
  _aliasid               INTEGER = null,
  _contactname CHARACTER VARYING = null,
  _statusid              INTEGER = null,
  _familyname  CHARACTER VARYING = null,
  _initials    CHARACTER VARYING = null,
  _givennames  CHARACTER VARYING = null,
  _suffix      CHARACTER VARYING = null,
  _title       CHARACTER VARYING = null,
  _phone       CHARACTER VARYING = null,
  _fax         CHARACTER VARYING = null,
  _email       CHARACTER VARYING = null,
  _url         CHARACTER VARYING = null,
  _address     CHARACTER VARYING = null,
  _notes       CHARACTER VARYING = null)
RETURNS INTEGER
LANGUAGE sql
AS $function$
INSERT INTO ndb.contacts (aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes)
VALUES      (_aliasid, _contactname, _statusid, _familyname, _initials, _givennames, _suffix, _title, _phone, _fax, _email, _url, _address, _notes)
RETURNING contactid

$function$
