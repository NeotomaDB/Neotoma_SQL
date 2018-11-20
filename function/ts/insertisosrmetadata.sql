CREATE OR REPLACE FUNCTION ts.insertisosrmetadata(_datasetid integer,
_variableid integer,
_srlocalvalue character varying = null,
_srlocalgeolcontext character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isosrmetadata(datasetid, variableid, srlocalvalue, srlocalgeolcontext)
  VALUES (_datasetid, _variableid, _srlocalvalue, _srlocalgeolcontext)
$function$;
