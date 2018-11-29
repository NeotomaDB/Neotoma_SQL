CREATE OR REPLACE FUNCTION ts.insertsample(
  _analysisunitid integer,
  _datasetid integer,
  _samplename character varying = null,
  _sampledate character varying = null,
  _analysisdate character varying = null,
  _taxonid integer = null,
  _labnumber character varying = null,
  _prepmethod character varying = null,
  _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
 AS $function$
   INSERT INTO ndb.samples(analysisunitid, datasetid, samplename, sampledate,
      analysisdate, taxonid, labnumber, preparationmethod, notes)
   VALUES (_analysisunitid, _datasetid, _samplename,
      TO_CHAR(sampledate, 'YYYY-MM-DD HH:MI:SS') as sampledate,
      TO_CHAR(analysisdate, 'YYYY-MM-DD HH:MI:SS') as analysisdate,
      _taxonid, _labnumber, _prepmethod, _notes)
   RETURNING sampleid
 $function$;
