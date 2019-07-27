CREATE OR REPLACE FUNCTION ts.deletevariablesbytaxonid(_taxonid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
delete from ndb.variables AS vbs
where vbs.taxonid = _taxonid;
$function$
