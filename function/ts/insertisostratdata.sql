CREATE OR REPLACE FUNCTION ts.insertisostratdata(_dataid integer,
        _sd float = null,
        _taxonid integer = null,
        _elementtypeid integer = null)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isostratdata(dataid, sd, taxonid, elementtypeid)
  VALUES (_dataid, _sd, _taxonid, _elementtypeid)
$function$;
