CREATE OR REPLACE FUNCTION ts.linkhigher()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE ndb.taxa
  SET highertaxonid = (SELECT taxonid FROM ndb.taxa WHERE highertaxonid = -1);
END;
$function$
