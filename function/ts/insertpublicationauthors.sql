CREATE OR REPLACE FUNCTION ts.insertpublicationauthors(_publicationid integer, _authororder integer, _familyname character varying, _initials character varying DEFAULT NULL::character varying, _suffix character varying DEFAULT NULL::character varying, _contactid integer DEFAULT NULL::integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publicationauthors (publicationid, authororder, familyname,
     initials, suffix, contactid)
  VALUES (_publicationid, _authororder, _familyname, _initials, _suffix, _contactid)
  RETURNING authorid
$function$
