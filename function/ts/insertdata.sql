CREATE OR REPLACE FUNCTION ts.insertdata(_sampleid integer, _variableid integer, _value float)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.data(sampleid, variableid, value)
VALUES (_sampleid, _variableid, _value)
$function$;

SELECT scope_identity();
