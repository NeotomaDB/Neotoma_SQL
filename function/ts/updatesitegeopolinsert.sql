CREATE OR REPLACE FUNCTION ts.updatesitegeopolinsert(_siteid integer, _stewardcontactid integer, _geopoliticalid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
	BEGIN
	INSERT INTO ndb.sitegeopolitical(siteid, geopoliticalid)
	VALUES  (_siteid, _geopoliticalid);
	END;

	DECLARE
		_newsitegeopoliticalid int := (SELECT sitegeopoliticalid FROM ndb.sitegeopolitical WHERE (siteid = _siteid AND geopoliticalid = _geopoliticalid));

	BEGIN
	INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation)
	VALUES  (_stewardcontactid, 'sitegeopolitical', _newsitegeopoliticalid, 'insert');
	END;
END;

$function$
