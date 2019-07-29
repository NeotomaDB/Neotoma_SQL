CREATE OR REPLACE FUNCTION doi.doireturn(dsid integer)
 RETURNS TABLE(datasetid integer, dois json)
 LANGUAGE sql
AS $function$
  SELECT doi.datasetid, json_agg(doi.doi)
  FROM ndb.datasetdoi AS doi
  WHERE doi.datasetid = dsid
  GROUP BY doi.datasetid;
$function$
