CREATE OR REPLACE FUNCTION ti.getchroncontroltypestable()
RETURNS TABLE(chroncontroltypeid int, chroncontroltype varchar(64), higherchroncontroltypeid int) AS $$
SELECT chroncontroltypeid, chroncontroltype, higherchroncontroltypeid
FROM ndb.chroncontroltypes;
$$ LANGUAGE SQL;