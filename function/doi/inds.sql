CREATE OR REPLACE FUNCTION doi.inds(dsid integer)
 RETURNS boolean
 LANGUAGE sql
AS $function$
  SELECT COUNT(*) = 1 FROM
  ndb.datasets AS ds
  WHERE ds.datasetid = dsid;
$function$
