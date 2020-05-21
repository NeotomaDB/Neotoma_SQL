CREATE OR REPLACE FUNCTION ti.getelementtypefromvariableelement(_variableelement character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE plpgsql
AS $function$
#variable_conflict use_column
DECLARE
	semicolon varchar(1) := ';';
BEGIN
IF position(';' in _variableelement) = 0 THEN
    RETURN QUERY SELECT elementtypeid, elementtype
    FROM ndb.elementtypes
	WHERE elementtype ILIKE $1;
ELSE
    RETURN QUERY SELECT elementtypeid, elementtype
    FROM  ndb.elementtypes
    WHERE elementtype ILIKE left($1, char_length(elementtype)) AND substring($1, char_length(elementtype)+1, 1) = semicolon
    ORDER BY char_length(elementtype) DESC
	LIMIT 1;
END IF;
END;
$function$
