CREATE OR REPLACE FUNCTION ts.updatelakeparam(_siteid integer, _stewardcontactid integer, _lakeparameter character varying, _value numeric DEFAULT NULL::numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE

	lakeparameterid int := (SELECT lakeparameterid FROM ndb.lakeparametertypes WHERE lakeparameter = _lakeparameter);
	nparam int := (SELECT COUNT(*) AS count FROM ndb.lakeparameters WHERE siteid = _siteid GROUP BY lakeparameterid HAVING lakeparameterid = lakeparameterid);
	/* If nparam is not null, then the LakeParameter is already in Neotoma */

BEGIN

	IF _value IS NOT NULL THEN
		IF _nparam IS NOT NULL THEN  /* parameter in Neotoma, need to change */
			UPDATE ndb.lakeparameters AS lp
			SET value = value WHERE (siteid = _siteid) AND (lp.lakeparameterid = lakeparameterid);
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

$function$
