CREATE OR REPLACE FUNCTION ts.updatepublicationtranslator(_translatorid integer,
                                                          _publicationid integer,
                                                          _translatororder integer,
                                                          _familyname character varying,
                                                          _initials character varying DEFAULT NULL::character varying,
                                                          _suffix character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.publicationtranslators AS pbt
	SET   publicationid = _publicationid, translatororder = _translatororder, familyname = _familyname, initials = _initials, suffix = _suffix
	WHERE pbt.translatorid = _translatorid
$function$
