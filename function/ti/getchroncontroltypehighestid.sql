CREATE OR REPLACE FUNCTION ti.getchroncontroltypehighestid(_chroncontroltypeid integer)
 RETURNS TABLE(chroncontroltypeid integer,
                 chroncontroltype character varying,
         higherchroncontroltypeid integer)
 LANGUAGE sql
AS $function$
  WITH RECURSIVE climbchron AS (
    SELECT cct.chroncontroltypeid,
           cct.higherchroncontroltypeid
    FROM ndb.chroncontroltypes AS cct
    WHERE (cct.chroncontroltypeid = _chroncontroltypeid)
    UNION ALL
    SELECT cctb.chroncontroltypeid,
           cctb.higherchroncontroltypeid
    FROM ndb.chroncontroltypes AS cctb
    JOIN climbchron ON climbchron.higherchroncontroltypeid = cctb.chroncontroltypeid
    WHERE NOT climbchron.chroncontroltypeid = climbchron.higherchroncontroltypeid)

  SELECT cctact.chroncontroltypeid,
         cctact.chroncontroltype,
  	     cctact.higherchroncontroltypeid
  FROM                       climbchron AS chrons
  LEFT OUTER JOIN ndb.chroncontroltypes AS cctact
  ON    cctact.chroncontroltypeid = chrons.chroncontroltypeid
  WHERE cctact.chroncontroltypeid = cctact.higherchroncontroltypeid
$function$
