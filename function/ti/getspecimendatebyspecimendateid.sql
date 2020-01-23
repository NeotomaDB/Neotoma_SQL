CREATE OR REPLACE FUNCTION ti.getspecimendatebyspecimendateid(_specimendateid integer)
RETURNS TABLE(specimenid integer, taxonid integer, taxonname character varying, elementtypeid integer,
	elementtype character varying, fractionid integer, fraction character varying, sampleid integer, notes character varying)
LANGUAGE sql
AS $function$

	SELECT ndb.specimendates.specimenid, ndb.specimendates.taxonid, ndb.taxa.taxonname, ndb.specimendates.elementtypeid, ndb.elementtypes.elementtype, 
                      ndb.specimendates.fractionid, ndb.fractiondated.fraction, ndb.specimendates.sampleid, ndb.specimendates.notes
    FROM ndb.specimendates INNER JOIN ndb.taxa ON ndb.specimendates.taxonid = ndb.taxa.taxonid LEFT OUTER JOIN
                      ndb.fractiondated ON ndb.specimendates.fractionid = ndb.fractiondated.fractionid LEFT OUTER JOIN
                      ndb.elementtypes ON ndb.specimendates.elementtypeid = ndb.elementtypes.elementtypeid
	WHERE  ndb.specimendates.specimendateid = $1                      

$function$
