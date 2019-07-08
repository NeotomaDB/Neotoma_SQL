CREATE OR REPLACE FUNCTION ts.updatespecimennisp(_specimenid int, _nisp float, _contactid int)
RETURNS void
AS $$ 

UPDATE ndb.specimens
SET nisp = _nisp
WHERE specimenid = _specimenid;

INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname) 
VALUES (_contactid, 'Specimens', _specimenid, 'Update', 'NISP')


$$ LANGUAGE SQL;