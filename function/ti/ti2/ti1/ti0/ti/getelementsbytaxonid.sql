CREATE OR REPLACE FUNCTION ti.getelementsbytaxonid(_taxonid integer)
 RETURNS TABLE(variableelementid integer, elementtype character varying, symmetry character varying, portion character varying, maturity character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.variableelements.variableelementid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion, 
                      ndb.elementmaturities.maturity
FROM ndb.variables INNER JOIN
	ndb.variableelements ON ndb.variables.variableelementid = ndb.variableelements.variableelementid LEFT OUTER JOIN
	ndb.elementmaturities ON ndb.variableelements.maturityid = ndb.elementmaturities.maturityid LEFT OUTER JOIN
	ndb.elementportions ON ndb.variableelements.portionid = ndb.elementportions.portionid LEFT OUTER JOIN
	ndb.elementsymmetries ON ndb.variableelements.symmetryid = ndb.elementsymmetries.symmetryid LEFT OUTER JOIN
	ndb.elementtypes ON ndb.variableelements.elementtypeid = ndb.elementtypes.elementtypeid
GROUP BY ndb.variables.taxonid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity, 
                      ndb.variableelements.variableelementid
HAVING ndb.variables.taxonid = _taxonid
ORDER BY ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity
$function$
