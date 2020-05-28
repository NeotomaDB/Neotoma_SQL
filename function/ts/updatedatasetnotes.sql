CREATE OR REPLACE FUNCTION ts.updatedatasetnotes(_datasetid integer,
                                              _datasetnotes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  BEGIN
   IF _datasetnotes IS NOT NULL THEN
        UPDATE     ndb.datasets
        SET        notes = _datasetnotes
        WHERE     (datasetid = _datasetid);
   ELSE
        UPDATE     ndb.datasets
        SET        notes = NULL
        WHERE     (datasetid = _datasetid);
    END IF;
  END;
$function$
