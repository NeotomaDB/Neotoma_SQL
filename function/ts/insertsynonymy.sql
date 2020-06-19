CREATE OR REPLACE FUNCTION ts.insertsynonymy(_datasetid integer, _taxonid integer, _reftaxonid integer, _fromcontributor boolean DEFAULT false, _publicationid integer DEFAULT NULL::integer, _notes character varying DEFAULT NULL::character varying, _contactid integer DEFAULT NULL::integer, _datesynoynmized character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.synonymy(datasetid, taxonid, reftaxonid, fromcontributor,
    publicationid, notes, contactid, datesynonymized)
  VALUES (_datasetid, _taxonid, _reftaxonid, _fromcontributor, _publicationid,
    _notes, _contactid,
    TO_DATE(_datesynoynmized, 'YYYY-MM-DD'))
  RETURNING synonymyid
$function$
