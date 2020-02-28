CREATE OR REPLACE FUNCTION ts.insertdepenvttype(_depenvt character varying,
                                                _depenvthigherid int DEFAULT NULL)
RETURNS int
LANGUAGE sql
AS $function$
  INSERT INTO ndb.depenvttypes(depenvt, depenvthigherid)
  VALUES      (_depenvt, _depenvthigherid)
  RETURNING depenvtid

$function$
