CREATE OR REPLACE FUNCTION ts.insertpublicationauthors(_publicationid integer,
    _authororder integer,
    _familyname character varying,
    _initials character varying = null,
    _suffix character varying = null
    _contactid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publicationauthors (publicationid, authororder, familyname,
     initials, suffix, contactid)
  VALUES (_publicationid, _authororder, _familyname, _initials, _suffix, _contactid)
  RETURNING authorid
$function$;
