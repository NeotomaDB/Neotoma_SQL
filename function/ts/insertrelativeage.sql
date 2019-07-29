CREATE OR REPLACE FUNCTION ts.insertrelativeage(_relativeageunitid integer, _relativeagescaleid integer, _relativeage character varying, _c14ageyounger double precision DEFAULT NULL::double precision, _c14ageolder double precision DEFAULT NULL::double precision, _calageyounger double precision DEFAULT NULL::double precision, _calageolder double precision DEFAULT NULL::double precision, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.relativeages (relativeageunitid, relativeagescaleid,
    relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes)
  VALUES (_relativeageunitid, _relativeagescaleid, _relativeage, _c14ageyounger,
    _c14ageolder, _calageyounger, _calageolder, _notes)
  RETURNING relativeageid
$function$
