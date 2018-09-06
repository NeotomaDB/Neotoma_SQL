CREATE OR REPLACE FUNCTION ti.getvarelemsbydatasettypeandtaxaidlist(_datasettype character varying, _taxaids character varying)
 RETURNS TABLE(variableelement character varying, taxonid integer)
 LANGUAGE sql
AS $function$
select     ve.variableelement, vr.taxonid
from
                  ndb.datasettypes AS dt
  inner join         ndb.datasets AS ds  ON     dt.datasettypeid = ds.datasettypeid 
  INNER JOIN     ndb.dsdatasample AS dss ON         ds.datasetid = dss.datasetid
  INNER JOIN        ndb.variables AS vr  ON       dss.variableid = vr.variableid 
  INNER JOIN ndb.variableelements AS ve  ON vr.variableelementid = ve.variableelementid
WHERE 
  dt.datasettype LIKE _datasettype
group by 
  ve.variableelement, 
  vr.taxonid
having 
  vr.taxonid IN (SELECT unnest(string_to_array(_taxaids,'$'))::int)
$function$
