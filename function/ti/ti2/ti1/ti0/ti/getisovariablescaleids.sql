CREATE OR REPLACE FUNCTION ti.getisovariablescaleids()
 RETURNS TABLE(isovariable character varying, isoscaletypeid integer, isoscaleacronym character varying)
 LANGUAGE sql
AS $function$
SELECT
 tx.taxonname as isovariable, 
 ivst.isoscaletypeid,
 ist.isoscaleacronym
 FROM ndb.isovariablescaletypes AS ivst 
 INNER JOIN   ndb.isoscaletypes AS ist  ON ivst.isoscaletypeid = ist.isoscaletypeid
 INNER JOIN       ndb.variables AS var  ON     ivst.variableid = var.variableid
 INNER JOIN            ndb.taxa AS tx   ON          tx.taxonid = var.taxonid
ORDER BY isovariable;
$function$
