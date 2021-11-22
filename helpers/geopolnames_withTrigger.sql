DROP MATERIALIZED VIEW ap.geopolnames;
CREATE MATERIALIZED VIEW ap.geopolnames AS (
SELECT DISTINCT siteid, array_agg(geopoliticalname) AS names FROM
(SELECT DISTINCT p.siteid, gpu.geopoliticalname, gpu.rank
    FROM ndb.geopoliticalunits AS gpu
    INNER JOIN 
        (SELECT p.siteid,
                UNNEST(p.geopol)
         FROM ap.querytable AS p) AS p ON p.unnest = gpu.geopoliticalid
    ORDER BY p.siteid, gpu.rank ASC) AS sq
    GROUP BY sq.siteid);

CREATE UNIQUE INDEX gpsiteidindex ON ap.geopolnames(siteid);

CREATE OR REPLACE FUNCTION ap.updategpsites()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
BEGIN
REFRESH MATERIALIZED VIEW CONCURRENTLY ap.geopolnames;
RETURN NULL;
END $$;

CREATE TRIGGER updategeopol
AFTER INSERT OR DELETE
ON ndb.sites
FOR EACH STATEMENT
EXECUTE PROCEDURE ap.updategpsites();

REASSIGN OWNED BY sug335 TO functionwriter;