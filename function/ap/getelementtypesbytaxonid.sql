CREATE OR REPLACE FUNCTION ap.getelementtypesbytaxonid(_taxonid integer)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$
    select     distinct et.elementtypeid, et.elementtype
from         ndb.taxa inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid inner join
                      ndb.data on ndb.variables.variableid = ndb.data.variableid left outer join
                      ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid inner join
                      ndb.elementtypes as et on ndb.variableelements.elementtypeid = et.elementtypeid
where     (ndb.taxa.taxonid = _taxonid)
order by elementtype
$function$
