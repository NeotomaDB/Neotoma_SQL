CREATE OR REPLACE FUNCTION ti.getisobiomarkers()
 RETURNS TABLE(isobiomarkertype character varying, isobiomarkerbandtype character varying)
 LANGUAGE sql
AS $function$


select    ibmt.isobiomarkertype, ibbt.isobiomarkerbandtype
from      ndb.isobiomarkertypes ibmt inner join
          ndb.isobiomarkerbandtypes ibbt on ibmt.isobiomarkertypeid = ibbt.isobiomarkertypeid
order by  ibmt.isobiomarkertype, ibbt.isobiomarkerbandtype

$function$
