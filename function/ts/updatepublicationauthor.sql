CREATE OR REPLACE FUNCTION ts.updatepublicationauthor(_authorid integer,
                                                      _publicationid integer,
                                                      _authororder integer,
                                                      _familyname character varying,
                                                      _contactid integer,
                                                      _initials character varying DEFAULT NULL::character varying,
                                                      _suffix character varying  DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.publicationauthors AS pba
	SET   publicationid = _publicationid, authororder = _authororder,
      familyname = _familyname, initials = _initials,
      suffix = _suffix, contactid = _contactid
	WHERE pba.authorid = _authorid
$function$
