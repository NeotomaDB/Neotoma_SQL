CREATE OR REPLACE FUNCTION ts.insertsynonym(_invalidtaxonid integer,
    _validtaxonid integer,
    _synonymtypeid integer = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.synonyms(invalidtaxonid, validtaxonid, synonymtypeid)
  VALUES (_invalidtaxonid, _validtaxonid, _synonymtypeid)
  RETURNING synonymid
$function$;
