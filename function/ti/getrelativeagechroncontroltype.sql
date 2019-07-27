CREATE OR REPLACE FUNCTION ti.getrelativeagechroncontroltype(_relativeage character varying)
 RETURNS TABLE(chroncontroltypeid integer, chroncontroltype character varying)
 LANGUAGE sql
AS $function$
select     cct.chroncontroltypeid,
		   cct.chroncontroltype
from       ndb.relativeages as ra
	inner join ndb.relativeagescales as ras on ra.relativeagescaleid = ras.relativeagescaleid
	inner join ndb.chroncontroltypes as cct on ras.relativeagescale = cct.chroncontroltype
where     (ra.relativeage = _relativeage)
$function$
