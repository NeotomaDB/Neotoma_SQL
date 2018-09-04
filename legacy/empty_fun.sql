CREATE OR REPLACE FUNCTION ti. ()
 RETURNS TABLE()
 LANGUAGE sql
AS $function$

$function$


This:  TI.func_IntListToIN(@VARIABLEIDS,'$')   Goes to:

WHERE (ndb.variables.variableid IN (
    SELECT unnest(string_to_array(_variableids,'$'))::int
    ))
