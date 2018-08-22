CREATE OR REPLACE FUNCTION ti.getspecimendatesbytaxonid(_taxonid integer)
 RETURNS TABLE(specimendateid integer, geochronid integer, taxonid integer, fractionid integer,
			  sampleid integer, notes character varying, elementtypeid integer)
 LANGUAGE sql
 AS $function$
 SELECT
	sd.specimendateid,
	sd.geochronid,
	sd.taxonid,
	sd.fractionid,
	sd.sampleid,
	sd.notes,
	sd.elementtypeid
 FROM        ndb.specimendates AS sd
 WHERE    sd.taxonid = _taxonid

$function$
