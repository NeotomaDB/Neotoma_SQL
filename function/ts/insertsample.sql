CREATE OR REPLACE FUNCTION ts.insertsample(_analysisunitid integer,
  _datasetid integer,
  _samplename character varying DEFAULT NULL::character varying,
  _sampledate character varying DEFAULT NULL::character varying,
  _analysisdate character varying DEFAULT NULL::character varying,
  _taxonid integer DEFAULT NULL::integer,
  _labnumber character varying DEFAULT NULL::character varying,
  _prepmethod character varying DEFAULT NULL::character varying,
  _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
   INSERT INTO ndb.samples(analysisunitid, datasetid, samplename, sampledate,
      analysisdate, taxonid, labnumber, preparationmethod, notes)
   VALUES (_analysisunitid, _datasetid, _samplename,
      TO_DATE(_sampledate, 'YYYY-MM-DD'),
      TO_DATE(_analysisdate, 'YYYY-MM-DD'),
      _taxonid, _labnumber, _prepmethod, _notes)
   RETURNING sampleid
 $function$
