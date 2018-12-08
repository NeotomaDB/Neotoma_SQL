CREATE OR REPLACE FUNCTION ts.updatedatasetnotes(_datasetid integer, _datasetnotes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

  BEGIN
   IF _datasetnotes IS NOT NULL THEN
        UPDATE     ndb.datasets
        SET        ndb.datasets.notes = _datasetnotes
        WHERE     (ndb.datasets.datasetid = _datasetid);
   ELSE
        UPDATE     ndb.datasets
        SET        ndb.datasets.notes = NULL
        WHERE     (ndb.datasets.datasetid = _datasetid);
    END IF;
  END;
  $function$
