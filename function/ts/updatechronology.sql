CREATE OR REPLACE FUNCTION ts.updatechronology(
  _chronologyid INTEGER,
  _agetype CHARACTER VARYING,
  _contactid INTEGER = null,
  _isdefault BOOLEAN,
  _chronologyname CHARACTER VARYING = null,
  _dateprepared CHARACTER VARYING = null,
  _agemodel CHARACTER VARYING = null,
  _ageboundyounger INTEGER = null,
  _ageboundolder INTEGER = null,
  _notes CHARACTER VARYING = null
  )
RETURNS void
LANGUAGE sql
AS $function$
  UPDATE ndb.chronologies
    SET agetypeid = (SELECT agetypeid FROM ndb.agetypes WHERE (agetype = _agetype)),
        contactid = _contactid,
        isdefault = _isdefault,
        chronologyname = _chronologyname,
        dateprepared = TO_DATE(_submissiondate, 'YYYY-MM-DD'),
      agemodel = _agemodel,
      ageboundyounger = _ageboundyounger,
      ageboundolder = _ageboundolder,
      notes = _notes
  WHERE chronologyid = _chronologyid
$function$
