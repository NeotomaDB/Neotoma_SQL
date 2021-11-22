CREATE OR REPLACE FUNCTION ti.trigger_set_timecreate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.recdatecreated = NOW();
  RETURN NEW;
END;
$function$
