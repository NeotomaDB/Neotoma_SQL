CREATE OR REPLACE FUNCTION ts.linkhigher()
RETURNS trigger
AS $$
BEGIN
  UPDATE ndb.taxa
  SET highertaxonid = (SELECT taxonid FROM ndb.taxa WHERE highertaxonid = -1);
END;
$$
LANGUAGE 'plpgsql';
