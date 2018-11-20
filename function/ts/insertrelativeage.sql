CREATE OR REPLACE FUNCTION ts.insertrelativeage(_relativeageunitid integer,
    _relativeagescaleid integer,
    _relativeage character varying,
    _c14ageyounger float = null,
    _c14ageolder float = null,
    _calageyounger float = null,
    _calageolder float = null,
    _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.relativeagepublications (relativeageunitid, relativeagescaleid,
    relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes)
  VALUES (_relativeageunitid, _relativeagescaleid, _relativeage, _c14ageyounger,
    _c14ageolder, _calageyounger, _calageolder, _notes)
  RETURNING relativeageid
$function$;
