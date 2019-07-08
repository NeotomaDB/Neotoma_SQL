CREATE OR REPLACE FUNCTION ts.updatesitegeopolinsert(_siteid int, _stewardcontactid int, _geopoliticalid int)
RETURNS	void
AS $$
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

$$ LANGUAGE plpgsql;