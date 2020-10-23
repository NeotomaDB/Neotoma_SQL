CREATE OR REPLACE FUNCTION ts.updatedatavariable(_datasetid integer, _oldvariableid integer, _newvariableid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	WITH dataids AS (
    SELECT    dsds.dataid
    FROM      ndb.dsdatasample AS dsds
    WHERE     (dsds.datasetid = _datasetid) AND (dsds.variableid = _oldvariableid)
  )
  UPDATE ndb.data
  SET variableid = _newvariableid
  WHERE dataid IN (SELECT dataid FROM dataids);

$function$
