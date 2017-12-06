CREATE OR REPLACE FUNCTION ti.getagetypestable() RETURNS SETOF agetypes
 AS 'SELECT ndb.agetypes.* FROM ndb.agetypes;'
LANGUAGE SQL;