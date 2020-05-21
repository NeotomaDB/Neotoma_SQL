CREATE OR REPLACE FUNCTION ts.insertisosrmetadata(_datasetid integer, _variableid integer, _srlocalvalue double precision DEFAULT NULL::double precision, _srlocalgeolcontext character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isosrmetadata(datasetid, variableid,
                                srlocalvalue,
                                srlocalgeolcontext)
  VALUES (_datasetid, _variableid,
          _srlocalvalue,
          _srlocalgeolcontext)
$function$
