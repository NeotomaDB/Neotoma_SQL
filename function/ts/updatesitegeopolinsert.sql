CREATE OR REPLACE FUNCTION ts.updatesitegeopolinsert(_siteid integer, _stewardcontactid integer, _geopoliticalid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
BEGIN
	INSERT INTO ndb.sitegeopolitical(siteid, geopoliticalid)
	VALUES  (_siteid, _geopoliticalid);
END;

$function$
