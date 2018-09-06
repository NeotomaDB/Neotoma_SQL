CREATE OR REPLACE FUNCTION ti.getisovariablescaletypes()
 RETURNS TABLE(isovariable character varying, isoscaleacronym character varying)
 LANGUAGE sql
AS $function$
SELECT 
         tx.taxonname AS isovariable, 
  ist.isoscaleacronym
 FROM ndb.isovariablescaletypes AS ivst
 INNER JOIN   ndb.isoscaletypes AS ist ON ivst.isoscaletypeid = ivst.isoscaletypeid
 INNER JOIN       ndb.variables AS var ON     ivst.variableid = var.variableid
 INNER JOIN            ndb.taxa AS tx  ON          tx.taxonid = var.taxonid 
 ORDER BY tx.taxonname, ist.isoscaleacronym;
$function$
