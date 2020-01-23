CREATE OR REPLACE FUNCTION ts.insertdata(_sampleid integer, _variableid integer, _value double precision)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.data(sampleid, variableid, value)
VALUES (_sampleid, _variableid, _value)
RETURNING dataid
$function$
