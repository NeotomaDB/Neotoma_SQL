CREATE OR REPLACE FUNCTION ts.updatelakeparam(_siteid int, _stewardcontactid int, _lakeparameter varchar, _value numeric DEFAULT null)
RETURNS void
AS $$
DECLARE

	lakeparameterid int := (SELECT lakeparameterid FROM ndb.lakeparametertypes WHERE lakeparameter = _lakeparameter);
	nparam int := (SELECT COUNT(*) AS count FROM ndb.lakeparameters WHERE siteid = _siteid GROUP BY lakeparameterid HAVING lakeparameterid = lakeparameterid);
	/* If nparam is not null, then the LakeParameter is already in Neotoma */

BEGIN

	IF _value IS NOT NULL THEN
		IF _nparam IS NOT NULL THEN  /* parameter in Neotoma, need to change */
			UPDATE ndb.lakeparameters
			SET value = value WHERE (siteid = _siteid) AND (lakeparameterid = lakeparameterid);
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, pk2, operation, columnname)
            VALUES (_stewardcontactid, 'lakeparameters',_siteid, lakeparameterid, 'update', 'value');
		ELSE
			INSERT INTO ndb.lakeparameters (siteid, lakeparameterid, value)
			VALUES (_siteid, lakeparameterid, _value);
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
            VALUES (_stewardcontactid, 'lakeparameters', _siteid, lakeparameterid, 'insert');
		END IF;
	ELSE
		IF _nparam IS NOT NULL THEN  /* parameter in Neotoma, need to delete */
			DELETE FROM ndb.lakeparameters 
			WHERE (siteid = _siteid) AND (lakeparameterid = lakeparameterid);
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
            VALUES (_stewardcontactid, 'lakeparameters', _siteid, lakeparameterid, 'delete');
		END IF;
	END IF;
END;

$$ LANGUAGE plpgsql;
