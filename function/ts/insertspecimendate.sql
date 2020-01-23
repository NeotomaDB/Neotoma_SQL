CREATE OR REPLACE FUNCTION ts.insertspecimendate(_geochronid integer, _specimenid integer DEFAULT NULL::integer, _taxonid integer DEFAULT NULL::integer, _elementtypeid integer DEFAULT NULL::integer, _fractionid integer DEFAULT NULL::integer, _sampleid integer DEFAULT NULL::integer, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  insert into ndb.specimendates
                            (geochronid, specimenid, taxonid, elementtypeid, fractionid, sampleid, notes)
  values      (_geochronid,
               _specimenid, _taxonid, _elementtypeid, _fractionid, _sampleid, _notes)
  RETURNING specimendateid
$function$
