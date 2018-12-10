CREATE OR REPLACE FUNCTION ts.updatedatavariable(
  _datasetid integer,
  _oldvariableid integer,
  _newvariableid integer,
  _contactid integer)
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
  WHERE dataid = (SELECT dataid FROM dataids);

  WITH dataids AS (
	SELECT    dsds.dataid
	FROM      ndb.dsdatasample AS dsds
	WHERE     (dsds.datasetid = _datasetid) AND (dsds.variableid = _oldvariableid)
  )
  INSERT INTO ti.stewardupdates(contactid, tablename,pk1, operation, columnname)
  SELECT _contactid, 'Data', dids.dataid, 'Update', 'variableid'
  FROM (SELECT * FROM dataids) AS dids
$function$
