CREATE OR REPLACE FUNCTION ti.getchroncontroltypehighestid(_chroncontroltypeid integer)
 RETURNS TABLE(chroncontroltypeid integer, chroncontroltype character varying, higherchroncontroltypeid integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
	id int := _chroncontroltypeid;
	higherid int := (SELECT ndb.chroncontroltypes.higherchroncontroltypeid FROM ndb.chroncontroltypes WHERE ndb.chroncontroltypes.chroncontroltypeid = id);
BEGIN
	WHILE id <> higherid LOOP
		id := higherid;
		higherid := (SELECT ndb.chroncontroltypes.higherchroncontroltypeid FROM ndb.chroncontroltypes WHERE ndb.chroncontroltypes.chroncontroltypeid = id);
	RETURN QUERY
	SELECT ndb.chroncontroltypes.chroncontroltypeid, ndb.chroncontroltypes.chroncontroltype, ndb.chroncontroltypes.higherchroncontroltypeid
	FROM ndb.chroncontroltypes
	WHERE ndb.chroncontroltypes.chroncontroltypeid = id;
	END LOOP;
END;
$function$
