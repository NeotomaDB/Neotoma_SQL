CREATE OR REPLACE FUNCTION ts.insertsynonymy(
    _datasetid integer,
    _taxonid integer,
    _reftaxonid integer,
    _fromcontributor boolean = 0,
    _publicationid integer = null,
    _notes character varying = null,
    _contactid integer = null,
    _datesynoynmized character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.synonymy(datasetid, taxonid, reftaxonid, fromcontributor,
    publicationid, notes, contactid, datesynonymized)
  VALUES (_datasetid, _taxonid, _reftaxonid, _fromcontributor, _publicationid,
    _notes, _contactid,
    TO_CHAR(datesynonymized, 'YYYY-MM-DD') as datesynonymized)
$function$;
