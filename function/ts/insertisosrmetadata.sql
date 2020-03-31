CREATE OR REPLACE FUNCTION ts.insertisosrmetadata(_datasetid integer,
    _variableid integer,
    _srlocalvalue float DEFAULT NULL::float,
    _srlocalvaluesd float DEFAULT NULL::float,
    _srlocalgeolcontext character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isosrmetadata(datasetid, variableid,
                                srlocalvalue, srlocalvaluesd,
                                srlocalgeolcontext)
  VALUES (_datasetid, _variableid,
          _srlocalvalue, _srlocalvaluesd,
          _srlocalgeolcontext)
$function$
