CREATE OR REPLACE FUNCTION ts.deletesynonymy(_synonymyid integer, _contactid integer) RETURNS void LANGUAGE SQL AS $function$
  DELETE FROM ndb.synonymy AS sy
  WHERE sy.synonymyid = _synonymyid;

  INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation)
  VALUES      (_contactid, n'synonymy', _synonymyid, n'delete')
$function$
