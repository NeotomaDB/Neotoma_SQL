CREATE OR REPLACE FUNCTION ts.updatedatasetrepositorynotes(_datasetid integer, _repositoryid integer, _notes CHARACTER varying DEFAULT NULL::CHARACTER varying) RETURNS void LANGUAGE PLPGSQL AS $function$

  BEGIN
   IF _notes IS NULL THEN
        UPDATE     ndb.repositoryspecimens
        SET        notes = NULL
        WHERE     (datasetid = _datasetid) AND
                  (repositoryid = _repositoryid);
   ELSE
        UPDATE     ndb.repositoryspecimens
        SET        notes = _notes
        WHERE     (datasetid = _datasetid) AND
                  (repositoryid = _repositoryid);
    END IF;
  END;
  $function$
