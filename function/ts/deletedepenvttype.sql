CREATE OR REPLACE FUNCTION ts.deletedepenvttype(_depenvtid integer) RETURNS void LANGUAGE SQL AS $function$
  DELETE FROM ndb.depenvttypes AS dvt
  WHERE dvt.depenvtid = _depenvtid;
$function$
