CREATE OR REPLACE FUNCTION ts.insertlakeparameter(_siteid integer, _lakeparameterid integer, _value float)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.lakeparameters(siteid, lakeparameterid, value)
  VALUES (_siteid, _lakeparameterid, _value)
$function$;
