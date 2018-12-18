CREATE OR REPLACE FUNCTION ts.inserttaxon(
  _code CHARACTER VARYING,
  _name CHARACTER VARYING,
  _author CHARACTER VARYING = null,
  _valid boolean = True,
  _higherid int = null,
  _extinct boolean = False,
  _groupid CHAR(3),
  _pubid int = null,
  _validatorid int = null,
  _validatedate date = null,
  _notes CHARACTER VARYING
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
               _validatorid, convert(datetime, _validatedate, 105), _notes)
   RETURNING taxonid;

   UPDATE ndb.taxa
   SET highertaxonid = (SELECT taxonid FROM ndb.taxa WHERE highertaxonid = -1)
    where  (ndb.taxa.taxonid = _id)
   RETURNING taxonid;

$function$
