CREATE OR REPLACE FUNCTION ti.gettaxonvarelements(_taxonname character varying)
 RETURNS TABLE(variableelement character varying)
 LANGUAGE sql
AS $function$
  SELECT
   ve.variableelement AS variableelement
   FROM ndb.variables AS var
   inner join ndb.taxa AS tx on var.taxonid = tx.taxonid
   inner join ndb.variableelements AS ve ON var.variableelementid = ve.variableelementid
   where      (tx.taxonname ILIKE _taxonname)
   group by ve.variableelement
$function$
