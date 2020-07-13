CREATE OR REPLACE FUNCTION ti.update_dateupdated()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN 
	NEW.dateupdated = (current_timestamp at time zone 'UTC'); 
	Return NEW; 
END
 

$function$
