CREATE OR REPLACE FUNCTION ts.updatepublicationeditor(_editorid integer,
                                                      _publicationid integer,
                                                      _editororder integer,
                                                      _familyname character varying,
                                                      _initials character varying  DEFAULT NULL::character varying,
                                                      _suffix character varying  DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.publicationeditors AS pbe
	SET   publicationid = _publicationid, editororder = _editororder, familyname = _familyname, initials = _initials, suffix = _suffix
	WHERE pbe.editorid = _editorid
$function$
