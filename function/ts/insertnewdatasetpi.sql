CREATE OR REPLACE FUNCTION ts.insertnewdatasetpi(_datasetid integer, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.datasetpis(datasetid, contactid, piorder)
  VALUES      (_datasetid, _contactid, (SELECT count(*) + 1 FROM ndb.datasetpis WHERE (datasetid = _datasetid)))
$function$
