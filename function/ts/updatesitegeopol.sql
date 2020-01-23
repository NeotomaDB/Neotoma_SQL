CREATE OR REPLACE FUNCTION ts.updatesitegeopol(_siteid integer, _stewardcontactid integer, _oldgeopolid integer, _newgeopolid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE	
	_sitegeopolid int := (SELECT sitegeopoliticalid FROM ndb.sitegeopolitical WHERE (siteid = _siteid AND geopoliticalid = _oldgeopolid));

BEGIN
	IF _sitegeopolid IS NOT NULL THEN
		UPDATE ndb.sitegeopolitical
		SET geopoliticalid = _newgeopolid WHERE sitegeopoliticalid = _sitegeopolid;
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES  (_stewardcontactid, 'sitegeopolitical', sitegeopolid, 'update', geopoliticalid);
	END IF;

END;
$function$
