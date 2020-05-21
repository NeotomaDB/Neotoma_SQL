CREATE OR REPLACE FUNCTION ts.insertdatasetpublication(_datasetid integer, _publicationid integer, _primarypub boolean)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.datasetpublications(datasetid, publicationid, primarypub)
  SELECT      _datasetid, _publicationid, _primarypub
  WHERE
    NOT EXISTS (
      SELECT dsp.datasetid, dsp.publicationid
      FROM ndb.datasetpublications AS dsp
      WHERE (dsp.datasetid = _datasetid) AND (dsp.publicationid = _publicationid)
    )
$function$
