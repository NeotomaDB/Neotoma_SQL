CREATE OR REPLACE FUNCTION ts.updaterelativeage(
  _relativeageid integer,
  _relativeageunitid integer,
  _relativeagescaleid integer,
  _relativeage character varying,
  _c14ageyounger float = null,
  _c14ageolder float = null,
  _calageyounger float = null,
  _calageolder float = null,
  _notes character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.relativeages AS ra
	SET   relativeageunitid = _relativeageunitid,
        relativeagescaleid = _relativeagescaleid,
        relativeage = _relativeage,
        c14ageyounger = _c14ageyounger,
        c14ageolder = _c14ageolder,
        calageyounger = _calageyounger,
        calageolder = _calageolder, notes = _notes
	WHERE ra.relativeageid = _relativeageid
$function$;
