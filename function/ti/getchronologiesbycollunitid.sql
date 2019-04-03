CREATE OR REPLACE FUNCTION ti.getchronologiesbycollunitid(collunitid integer)
 RETURNS TABLE(chronologyid integer,
               agetype character varying,
               chronologyname character varying,
               isdefault boolean,
               agemodel character varying,
               ageboundolder integer,
               ageboundyounger integer,
               contactid integer,
               dateprepared character varying,
               notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.chronologies.chronologyid, ndb.agetypes.agetype, ndb.chronologies.chronologyname,
       ndb.chronologies.isdefault, ndb.chronologies.agemodel, ndb.chronologies.ageboundolder, ndb.chronologies.ageboundyounger,
       ndb.chronologies.contactid, ndb.chronologies.dateprepared::varchar(10) AS dateprepared, ndb.chronologies.notes
FROM ndb.chronologies INNER JOIN ndb.agetypes ON ndb.chronologies.agetypeid = ndb.agetypes.agetypeid
WHERE ndb.chronologies.collectionunitid = collunitid
ORDER BY ndb.chronologies.chronologyid;
$function$
