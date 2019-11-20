CREATE OR REPLACE FUNCTION ti.getchronologiesbycollunitid(_collectionunitid integer)
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
SELECT chn.chronologyid,
       aty.agetype,
       chn.chronologyname,
       chn.isdefault,
       chn.agemodel,
       chn.ageboundolder,
       chn.ageboundyounger,
       chn.contactid,
       chn.dateprepared::varchar(10) AS dateprepared,
       chn.notes
FROM ndb.chronologies AS chn
INNER JOIN ndb.agetypes AS aty ON chn.agetypeid = aty.agetypeid
WHERE chn.collectionunitid = _collunitid
ORDER BY chn.chronologyid;
$function$
