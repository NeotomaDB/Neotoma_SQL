CREATE OR REPLACE FUNCTION ts.updatedatasetrepositorynotes(_datasetid integer, _repositoryid integer, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

  BEGIN
   IF _notes IS NULL THEN
        UPDATE     ndb.repositoryspecimens AS rs
        SET        rs.notes = NULL
        WHERE     (rs.datasetid = _datasetid) AND
                  (rs.repositoryid = _repositoryid);
   ELSE
        UPDATE     ndb.repositoryspecimens as rs
        SET        rs.notes = _notes
        WHERE     (rs.datasetid = _datasetid) AND
                  (rs.repositoryid = _repositoryid);
    END IF;
  END;
  $function$
