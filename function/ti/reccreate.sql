CREATE OR REPLACE FUNCTION ti.reccreate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN 
	NEW.recdatecreated = (current_timestamp at time zone 'UTC'); 
	Return NEW; 
END
$function$
