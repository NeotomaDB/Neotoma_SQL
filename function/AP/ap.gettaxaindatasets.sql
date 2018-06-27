CREATE OR REPLACE FUNCTION ap.gettaxaindatasets()
RETURNS TABLE(taxonid int, taxonname varchar(80), taxagroupid varchar(3), datasettypeid int)  
AS $$
SELECT t.taxonid, t.taxonname, t.taxagroupid, dtgt.datasettypeid
FROM ndb.taxa AS t LEFT JOIN
ndb.datasettaxagrouptypes AS dtgt ON t.taxagroupid = dtgt.taxagroupid INNER JOIN
ndb.variables AS v ON t.taxonid = v.taxonid 
WHERE t.valid = 1
GROUP BY t.taxonid, t.taxonname, dtgt.datasettypeid, t.taxagroupid
ORDER BY t.taxonname, dtgt.datasettypeid
$$ LANGUAGE SQL;