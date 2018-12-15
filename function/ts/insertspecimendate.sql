CREATE OR REPLACE FUNCTION ts.insertspecimendate(
  _geochronid int,
  _specimenid int = null,
  _taxonid int = null,
  _elementtypeid int = null,
  _fractionid int = null,
  _sampleid int = null,
  _notes CHARACTER VARYING = null)
RETURNS integer
LANGUAGE sql
AS $function$
  insert into ndb.specimendates
                            (geochronid, specimenid, taxonid, elementtypeid, fractionid, sampleid, notes)
  values      (_geochronid,
               _specimenid, _taxonid, _elementtypeid, _fractionid, _sampleid, _notes)
  RETURNING specimendateid
$function$
