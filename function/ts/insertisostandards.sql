CREATE OR REPLACE FUNCTION ts.insertisostandards(_datasetid integer, _variableid integer, _isostandardid integer, _value double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isostandards(datasetid, variableid, isostandardid, value)
  VALUES (_datasetid, _variableid, _isostandardid, _value)
$function$
