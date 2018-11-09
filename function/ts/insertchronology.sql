CREATE OR REPLACE FUNCTION ts.insertchronology(_collectionunitid integer, _agetypeid integer DEFAULT NULL::integer, _contactid integer DEFAULT NULL::integer, _isdefault boolean DEFAULT NULL::boolean, _chronologyname character varying DEFAULT NULL::character varying, _dateprepared date DEFAULT NULL::date, _agemodel character varying DEFAULT NULL::character varying, _ageboundyounger integer DEFAULT NULL::integer, _ageboundolder integer DEFAULT NULL::integer, _notes text DEFAULT NULL::text)
 RETURNS integer
 LANGUAGE sql
AS $function$
		INSERT INTO ndb.chronologies(collectionunitid, agetypeid, contactid, isdefault, chronologyname, dateprepared, agemodel, ageboundyounger, ageboundolder, notes)
		VALUES (_collectionunitid, _agetypeid, _contactid, _isdefault, _chronologyname, _dateprepared, _agemodel, _ageboundyounger, _ageboundolder, _notes)
		RETURNING chronologyid;
	$function$
