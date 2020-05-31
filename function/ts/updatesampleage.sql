CREATE OR REPLACE FUNCTION ts.updatesampleage(_sampleageid integer,
_age double precision DEFAULT NULL::double precision,
_ageyounger double precision DEFAULT NULL::double precision,
_ageolder double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$

  UPDATE ndb.sampleages
  SET      age = _age,
      ageyounger = _ageyounger,
  	    ageolder = _ageolder
  WHERE sampleageid = _sampleageid;

$function$
