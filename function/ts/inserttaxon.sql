CREATE OR REPLACE FUNCTION ts.inserttaxon(_code character varying,
  _name character varying,
  _extinct boolean,
  _groupid character,
  _author character varying DEFAULT NULL::character varying,
  _valid boolean DEFAULT true,
  _higherid integer DEFAULT NULL::integer,
  _pubid integer DEFAULT NULL::integer,
  _validatorid integer DEFAULT NULL::integer,
  _validatedate character varying DEFAULT NULL::character varying, 
  _notes character varying DEFAULT NULL::character varying)
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
