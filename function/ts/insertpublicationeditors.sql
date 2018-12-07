CREATE OR REPLACE FUNCTION ts.insertpublicationeditors(_publicationid integer,
    _editororder integer,
      _familyname character varying,
      _initials character varying = null,
      _suffix character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publicationeditors (publicationid, editororder, familyname,
    initials, suffix)
  VALUES (_publicationid, _editororder, _familyname, _initials, _suffix)
  RETURNING editorid
$function$;
