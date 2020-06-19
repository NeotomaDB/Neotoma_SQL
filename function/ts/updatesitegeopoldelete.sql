CREATE OR REPLACE FUNCTION ts.updatesitegeopoldelete(_stewardcontactid integer,
  _siteid integer, _geopoliticalid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
 	_sitegeopolid int := (SELECT sitegeopoliticalid FROM ndb.sitegeopolitical WHERE (siteid = _siteid AND geopoliticalid = _geopoliticalid));

BEGIN
	IF _sitegeopolid IS NOT NULL THEN
    	DELETE FROM ndb.sitegeopolitical WHERE (sitegeopoliticalid = _sitegeopolid);
    	INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation)
    	VALUES  (_stewardcontactid, 'sitegeopolitical', _sitegeopolid, 'delete');
	END IF;

END;
$function$
