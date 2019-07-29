CREATE OR REPLACE FUNCTION ts.updatedatasetvariable(_oldvariableid integer, _newvariableid integer, _sampleid1 integer, _sampleid2 integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data
	SET   variableid = _newvariableid
	WHERE (variableid = _oldvariableid AND sampleid >= _sampleid1 AND
      sampleid <= _sampleid2)
$function$
