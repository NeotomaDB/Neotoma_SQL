CREATE OR REPLACE FUNCTION ts.inserttaxon(
  _code CHARACTER VARYING,
  _name CHARACTER VARYING,
  _author CHARACTER VARYING = null,
  _valid boolean = True,
  _higherid int = null,
  _extinct boolean = False,
  _groupid CHAR(3) = null,
  _pubid int = null,
  _validatorid int = null,
  _validatedate CHARACTER VARYING = null,
  _notes CHARACTER VARYING = null)
RETURNS integer
LANGUAGE sql
AS $function$

  INSERT INTO ndb.taxa (taxoncode,
    taxonname, author,
    valid, highertaxonid,
    extinct, taxagroupid,
    publicationid, validatorid,
    validatedate, notes)
  values      (_code, _name, _author, _valid,
               _higherid, _extinct, _groupid, _pubid,
               _validatorid, TO_DATE(_validatedate, 'YYYY-MM-DD'), _notes)
   RETURNING taxonid;

$function$
