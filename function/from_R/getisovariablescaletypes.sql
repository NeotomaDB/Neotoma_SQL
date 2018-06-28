CREATE OR REPLACE FUNCTION ti.getisovariablescaletypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      top 
100
 percent ndb.taxa.taxonname as isovariable, ndb.isoscaletypes.isoscaleacronym
 FROM ndb.isovariablescaletypes inner join
                      ndb.isoscaletypes on ndb.isovariablescaletypes.isoscaletypeid = ndb.isoscaletypes.isoscaletypeid inner join
                      ndb.taxa inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid on ndb.isovariablescaletypes.variableid = ndb.variables.variableid
order by ndb.taxa.taxonname, ndb.isoscaletypes.isoscaleacronym;
$function$