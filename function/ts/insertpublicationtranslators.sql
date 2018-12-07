CREATE OR REPLACE FUNCTION ts.insertpublicationtranslators(_publicationid integer,
      _translatororder integer,
      _familyname character varying,
      _initials character varying = null,
      _suffix character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publicationeditors (publicationid, translatorororder, familyname,
    initials, suffix)
  VALUES (_publicationid, _translatorororder, _familyname, _initials, _suffix)
  RETURNING translatorid
$function$;
