CREATE OR REPLACE FUNCTION ti.getvariabletextbyid(_variableid integer)
 RETURNS TABLE(taxonname character varying, variableelement character varying, variableunits character varying, variablecontext character varying)
 LANGUAGE sql
AS $function$
SELECT tx.taxonname,
       ve.variableelement,
       vu.variableunits,
       vc.variablecontext
FROM ndb.variables AS vr
  INNER JOIN            ndb.taxa AS tx ON           vr.taxonid = tx.taxonid
  LEFT JOIN ndb.variablecontexts AS vc ON vr.variablecontextid = vc.variablecontextid
  LEFT JOIN    ndb.variableunits AS vu ON   vr.variableunitsid = vu.variableunitsid
  LEFT JOIN ndb.variableelements AS ve ON vr.variableelementid = ve.variableelementid
WHERE     (vr.variableid = $1)

$function$
