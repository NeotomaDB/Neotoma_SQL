CREATE OR REPLACE FUNCTION ti.gettaxonvarunits(_taxonname character varying)
 RETURNS TABLE(variableunits character varying)
 LANGUAGE sql
AS $function$
  SELECT vu.variableunits
  FROM              ndb.variables AS var
    INNER JOIN          ndb.taxa AS tx ON        var.taxonid = tx.taxonid
	INNER JOIN ndb.variableunits AS vu ON vu.variableunitsid = var.variableunitsid
  WHERE
    tx.taxonname ILIKE _taxonname
  GROUP BY vu.variableunits
$function$
