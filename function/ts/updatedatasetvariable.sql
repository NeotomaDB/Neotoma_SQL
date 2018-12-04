CREATE OR REPLACE FUNCTION ts.updatedatasetvariable(
    _oldvariableid integer,
    _newvariableid integer,
    _sampleid1 integer,
    _sampleid2 integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data AS dt
	SET   dt.variableid = _newvariableid
	WHERE (dt.variableid = _oldvariableid AND dt.sampleid >= _sampleid1 AND
      dt.sampleid <= _sampleid2)
$function$;
