CREATE OR REPLACE FUNCTION ti.getprocedureinputparams(_procedurename character varying)
 RETURNS TABLE(name character varying,
               type character varying,
               isdefault boolean,
               paramorder bigint)
 LANGUAGE sql
AS $function$
SELECT     
    parameters.parameter_name,
    parameters.data_type, 
    (SELECT CASE WHEN parameters.parameter_default IS NOT NULL THEN TRUE ELSE FALSE END)  isdefault,
    parameters.ordinal_position::bigint
    
FROM information_schema.routines
    LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
WHERE routines.specific_schema ILIKE split_part(_procedurename, '.', 1)
    and routine_name ILIKE split_part(_procedurename, '.', 2)
ORDER BY parameters.ordinal_position;
$function$
