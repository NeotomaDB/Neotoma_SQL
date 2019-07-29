CREATE OR REPLACE FUNCTION ts.updatesynonymy(_synonymyid integer, _reftaxonid integer, _fromcontributor boolean DEFAULT false, _publicationid integer DEFAULT NULL::integer, _notes character varying DEFAULT NULL::character varying, _contactid integer DEFAULT NULL::integer, _datesynonymized date DEFAULT NULL::date)
 RETURNS void
 LANGUAGE sql
AS $function$

UPDATE ndb.synonymy
SET reftaxonid = _reftaxonid, 
    fromcontributor = _fromcontributor, 
	publicationid = _publicationid, 
	notes = _notes, 
	contactid = _contactid, 
	datesynonymized = _datesynonymized
WHERE synonymyid = _synonymyid;

INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation)
VALUES (_contactid, 'synonymy', _synonymyid, 'update')
 
$function$
