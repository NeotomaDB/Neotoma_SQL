CREATE OR REPLACE FUNCTION ts.updatedatasettaxonnotes(
  _datasetid integer,
  _taxonid integer,
  _contactid integer,
  _date date,
  _notes character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.datasettaxonnotes AS dtn
	SET   datasetid = _datasetid,
        taxonid = _taxonid,
  	    contactid = _contactid,
  	    date = TO_CHAR(_date, 'YYYY-MM-DD'),
  	    notes = _notes
	WHERE (dtn.datasetid = _datasetid) AND (dtn.taxonid = _taxonid);

  INSERT INTO ti.stewardupdates(contactid, tablename, pk1, pk2, operation, columnname)
  values      (_contactid, 'datasettaxonnotes', _datasetid, _taxonid, 'update', 'notes')
$function$;
