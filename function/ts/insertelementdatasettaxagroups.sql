CREATE OR REPLACE FUNCTION ts.insertelementdatasettaxagroups(_datasettypeid integer, _taxagroupid character varying, _elementtypeid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementdatasettaxagroups (datasettypeid, taxagroupid, elementtypeid)
  VALUES (_datasettypeid, _taxagroupid, _elementtypeid)
  RETURNING elementtaxagroupid
$function$;
