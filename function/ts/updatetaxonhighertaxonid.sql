CREATE OR REPLACE FUNCTION ts.updatetaxonhighertaxonid(_taxonid integer, _highertaxonid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    highertaxonid = _highertaxonid
	WHERE  ta.taxonid = _taxonid
$function$
