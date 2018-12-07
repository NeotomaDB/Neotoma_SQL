CREATE OR REPLACE FUNCTION ts.insertsampleage(_sampleid integer,
												_chronologyid integer,
												_age float = null,
												_ageyounger float = null,
												_ageolder float = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.sampleages(sampleid, chronologyid, age, ageyounger, ageolder)
  VALUES (_sampleid, _chronologyid, _age, _ageyounger, _ageolder)
  RETURNING sampleageid
$function$;
