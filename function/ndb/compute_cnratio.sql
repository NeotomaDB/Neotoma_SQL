CREATE OR REPLACE FUNCTION ndb.compute_cnratio()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
	--[percentc]/(12))/([percentn]/(14)
    if (new."percentn") = 0 or (new."percentn") = 0
    then
	new."cnratio" = 0;
	return new;
    else
	new."cnratio" = ((new."percentc")/12) /((new."percentn")/14);
	return new;
    end if;
end
$function$
