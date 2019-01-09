CREATE OR REPLACE FUNCTION ti.getcontactlinks(_contactid integer)
 RETURNS TABLE(tablename character varying, number integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
	c int;
BEGIN
	DROP TABLE IF EXISTS linkedtables;
	CREATE TEMP TABLE linkedtables(
		linkid serial primary key,
  		tablename varchar(255),
  		number int
	);
	c := (SELECT count(contactid) AS count FROM ndb.chronologies WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('chronologies', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.collectors WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('collectors', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.constituentdatabases WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('constituentdatabases', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.dataprocessors WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('dataprocessors', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.datasetpis WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('datasetpis', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.publicationauthors WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('publicationauthors', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.sampleanalysts WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('sampleanalysts', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ndb.siteimages WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('siteimages', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ti.stewards WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('stewards', c);
	END IF;

	c := (SELECT count(contactid) AS count FROM ti.stewardupdates WHERE contactid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('stewardupdates', c);
	END IF;

	c := (SELECT count(validatorid) AS count FROM ndb.taxa WHERE validatorid = _contactid);
	IF c > 0 THEN
		INSERT INTO linkedtables(tablename, number) VALUES('taxa', c);
	END IF;

	RETURN QUERY
	SELECT linkedtables.tablename, linkedtables.number
	FROM linkedtables;

	DROP TABLE IF EXISTS linkedtables;
END;
$function$
