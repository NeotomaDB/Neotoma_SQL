CREATE OR REPLACE FUNCTION doi.doireturn(dsid integer[])
RETURNS TABLE (datasetid integer, dois jsonb)
AS
$function$
  SELECT doi.datasetid, jsonb_agg(doi.doi) AS dois
  FROM ndb.datasetdoi AS doi
  WHERE doi.datasetid = ANY(dsid)
  GROUP BY doi.datasetid;
$function$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION doi.doireturn(dsid integer)
RETURNS TABLE (datasetid integer, dois jsonb)
AS
$function$
  SELECT doi.datasetid, jsonb_agg(doi.doi) AS dois
  FROM ndb.datasetdoi AS doi
  WHERE doi.datasetid = dsid
  GROUP BY doi.datasetid;
$function$ LANGUAGE sql;
