CREATE OR REPLACE FUNCTION ts.insertisostratdata(_dataid integer, _sd double precision DEFAULT NULL::double precision, _taxonid integer DEFAULT NULL::integer, _elementtypeid integer DEFAULT NULL::integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isostratdata(dataid, sd, taxonid, elementtypeid)
  VALUES (_dataid, _sd, _taxonid, _elementtypeid)
$function$
