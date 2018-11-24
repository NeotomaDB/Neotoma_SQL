CREATE OR REPLACE FUNCTION ts.insertsitegeopol(_siteid integer, _geopoliticalid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.sitegeopolitical(siteid, geopoliticalid)
  VALUES (_siteid, _geopoliticalid)
  RETURNING sitegeopoliticalid
$function$;
