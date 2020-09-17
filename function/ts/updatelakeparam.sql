CREATE OR REPLACE FUNCTION ts.updatelakeparam(_siteid integer,
     _stewardcontactid integer,
     _lakeparameter character varying,
     _value numeric DEFAULT NULL::numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  DECLARE

  	_lakeparameterid int := (
      SELECT lp.lakeparameterid
      FROM ndb.lakeparametertypes AS lp
      WHERE lp.lakeparameter = _lakeparameter);
  	_nparam int := (
      SELECT COUNT(*) AS count
      FROM ndb.lakeparameters AS lp
      WHERE lp.siteid = _siteid
      GROUP BY lp.lakeparameterid
      HAVING lp.lakeparameterid = lakeparameterid);

    /* If nparam is not null, then the LakeParameter is already in Neotoma */

  BEGIN
  	IF _value IS NOT NULL THEN
  		IF _nparam IS NOT NULL THEN  /* parameter in Neotoma, need to change */
  			UPDATE ndb.lakeparameters AS lp
  			SET value = _value WHERE (siteid = _siteid) AND (lp.lakeparameterid = _lakeparameterid);
  		ELSE
  			INSERT INTO ndb.lakeparameters (siteid, lakeparameterid, value)
  			VALUES (_siteid, _lakeparameterid, _value);
  		END IF;
  	ELSE
  		IF _nparam IS NOT NULL THEN  /* parameter in Neotoma, need to delete */
  			DELETE FROM ndb.lakeparameters AS lp
  			WHERE (lp.siteid = _siteid) AND (lp.lakeparameterid = _lakeparameterid);
  		END IF;
  	END IF;
  END;

$function$
