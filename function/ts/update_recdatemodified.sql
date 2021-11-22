CREATE OR REPLACE FUNCTION ts.update_recdatemodified()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN 
	NEW.recdatemodified = (current_timestamp at time zone 'UTC'); 
	Return NEW; 
END
$function$
