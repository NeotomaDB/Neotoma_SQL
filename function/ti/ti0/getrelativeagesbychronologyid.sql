CREATE OR REPLACE FUNCTION ti.getrelativeagesbychronologyid(_chronologyid integer)
 RETURNS TABLE(chroncontrolid integer, relativeage character varying)
 LANGUAGE sql
AS $function$
select
  rc.chroncontrolid, 
  ra.relativeage
from         ndb.analysisunits AS au 
  inner join ndb.relativechronology AS rc ON au.analysisunitid = rc.analysisunitid 
  inner join       ndb.chronologies AS ch ON au.collectionunitid = ch.collectionunitid
  inner join       ndb.relativeages AS ra on rc.relativeageid = ra.relativeageid
where     (ch.chronologyid = _chronologyid) and (rc.chroncontrolid is not null)

$function$
