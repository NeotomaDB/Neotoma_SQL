CREATE OR REPLACE FUNCTION ti.getsynonymsforinvalidtaxonid(_invalidtaxonid integer)
 RETURNS TABLE(taxonid integer, taxoncode character varying, taxonname character varying,
			   author character varying, valid smallint, highertaxonid integer, extinct smallint,
			   taxagroupid character varying, publicationid integer, validatorid integer, validatedate character varying,
			   notes character varying, synonymtypeid integer)
 LANGUAGE sql
 AS $function$

 SELECT
 	tx.taxonid,
 	tx.taxoncode,
	tx.taxonname,
	tx.author,
	tx.valid,
	tx.highertaxonid,
	tx.extinct,
  tx.taxagroupid,
	tx.publicationid,
	tx.validatorid,
	TO_CHAR(validatedate, 'YYYY-MM-DD') AS validatedate,
	tx.notes,
	syn.synonymtypeid
 FROM        ndb.synonyms AS syn
 INNER JOIN ndb.taxa AS tx ON syn.validtaxonid = tx.taxonid
 WHERE     syn.invalidtaxonid = _invalidtaxonid

$function$
