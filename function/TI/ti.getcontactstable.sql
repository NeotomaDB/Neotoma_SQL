CREATE OR REPLACE FUNCTION ti.getcontactstable() RETURNS SETOF record
AS $$
SELECT *
FROM ndb.contacts;
$$ LANGUAGE SQL;