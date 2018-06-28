CREATE OR REPLACE FUNCTION ti.getisobiomarkers()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      top 
100
 percent ndb.isobiomarkertypes.isobiomarkertype, ndb.isobiomarkerbandtypes.isobiomarkerbandtype
 FROM ndb.isobiomarkertypes inner join
                      ndb.isobiomarkerbandtypes on ndb.isobiomarkertypes.isobiomarkertypeid = ndb.isobiomarkerbandtypes.isobiomarkertypeid
order by ndb.isobiomarkertypes.isobiomarkertype, ndb.isobiomarkerbandtypes.isobiomarkerbandtype;
$function$