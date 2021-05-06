CREATE OR REPLACE FUNCTION ts.updatedatasetrepositorynotes(_datasetid integer, _repositoryid integer, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

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
