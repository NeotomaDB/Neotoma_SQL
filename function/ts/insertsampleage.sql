CREATE OR REPLACE FUNCTION ts.insertsampleage(_sampleid integer, _chronologyid integer, _age double precision DEFAULT NULL::double precision, _ageyounger double precision DEFAULT NULL::double precision, _ageolder double precision DEFAULT NULL::double precision)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.sampleages(sampleid, chronologyid, age, ageyounger, ageolder)
  VALUES (_sampleid, _chronologyid, _age, _ageyounger, _ageolder)
  RETURNING sampleageid
$function$
