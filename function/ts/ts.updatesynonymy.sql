CREATE OR REPLACE FUNCTION ts.updatesynonymy(_synonymyid int,
	_reftaxonid int,
	_fromcontributor BOOLEAN DEFAULT false,
	_publicationid int DEFAULT null,
	_notes varchar DEFAULT null,
	_contactid int DEFAULT null,
	_datesynonymized date DEFAULT null)

RETURNS void
AS $$

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
 
$$ LANGUAGE SQL;
