CREATE OR REPLACE FUNCTION ts.updatechronology(_chronologyid integer,
                                               _agetype character varying,
                                               _isdefault boolean,
                                               _contactid integer DEFAULT NULL::integer,
                                               _chronologyname character varying DEFAULT NULL::character varying,
                                               _dateprepared character varying DEFAULT NULL::character varying,
                                               _agemodel character varying DEFAULT NULL::character varying,
                                               _ageboundyounger integer DEFAULT NULL::integer,
                                               _ageboundolder integer DEFAULT NULL::integer,
                                               _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chronologies
    SET agetypeid = (SELECT agetypeid FROM ndb.agetypes WHERE (agetype = _agetype)),
        contactid = _contactid,
        isdefault = _isdefault,
        chronologyname = _chronologyname,
        dateprepared = TO_DATE(_dateprepared, 'YYYY-MM-DD'),
      agemodel = _agemodel,
      ageboundyounger = _ageboundyounger,
      ageboundolder = _ageboundolder,
      notes = _notes
  WHERE chronologyid = _chronologyid
$function$
