CREATE OR REPLACE FUNCTION ts.updatecontactaliasid(_contactid integer, _aliasid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.contacts AS cs
	SET    aliasid = _aliasid
	WHERE  cs.contactid = _contactid
$function$
