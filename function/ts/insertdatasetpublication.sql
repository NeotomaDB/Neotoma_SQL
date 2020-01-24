
CREATE OR REPLACE FUNCTION ts.insertdatasetpublication(_DATASETID int, _PUBLICATIONID int, _PRIMARYPUB boolean)
RETURNS VOID
LANGUAGE 'plpgsql'

    COST 100
    VOLATILE     
AS $function$

  DECLARE _nrecs integer;

  BEGIN

    SELECT COUNT(*) 
    FROM ndb.datasetpublications 
    GROUP BY datasetid, publicationid 
    HAVING (datasetid = _datasetid) AND (publicationid = _publicationid)
    INTO _nrecs;


    IF _nrecs IS NULL THEN
        INSERT INTO ndb.datasetpublications(datasetid, publicationid, primarypub)
        VALUES      (_datasetid, _publicationid, _primarypub);
    END IF;

  END;

$function$