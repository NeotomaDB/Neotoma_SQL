CREATE OR REPLACE FUNCTION ts.updatepublicationauthor(
  _authorid integer,
  _publicationid integer,
  _authororder integer,
  _familyname character varying,
  _initials character varying,
  _suffix character varying,
  _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.publicationauthors AS pba
	SET   publicationid = _publicationid, authororder = _authororder,
      familyname = _familyname, initials = _initials,
      suffix = _suffix, contactid = _contactid
	WHERE pba.authorid = _authorid
$function$;
