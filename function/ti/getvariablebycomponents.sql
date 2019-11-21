CREATE OR REPLACE FUNCTION ti.getvariablebycomponents(_taxonid integer,
                                                      _variableelementid integer DEFAULT NULL,
                                                      _variableunitsid integer DEFAULT NULL,
                                                      _variablecontextid integer DEFAULT NULL)
RETURNS TABLE(variableid integer,
              taxonid integer,
              variableelementid integer,
              variableunitsid integer,
              variablecontextid integer)
LANGUAGE sql
AS $function$
  SELECT
           vr.variableid,
              vr.taxonid,
    vr.variableelementid,
      vr.variableunitsid,
    vr.variablecontextid
  FROM
    ndb.variables AS vr
  WHERE
              (_taxonid IS NULL OR           vr.taxonid = _taxonid)           AND
    (_variableelementid IS NULL OR vr.variableelementid = _variableelementid) AND
      (_variableunitsid IS NULL OR   vr.variableunitsid = _variableunitsid)   AND
    (_variablecontextid IS NULL OR vr.variablecontextid = _variablecontextid)
$function$
