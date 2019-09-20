CREATE OR REPLACE FUNCTION ti.getchronconroltypebyname(_chroncontroltype varchar(64))
RETURNS TABLE(chroncontroltypeid int, chroncontroltype varchar(64), higherchroncontroltypeid int) AS $$
SELECT chroncontroltypeid,
       chroncontroltype,
       higherchroncontroltypeid
FROM ndb.chroncontroltypes
WHERE (chroncontroltype ILIKE _chroncontroltype);
$$ LANGUAGE SQL;
