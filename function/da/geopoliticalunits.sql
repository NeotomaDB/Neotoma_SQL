CREATE MATERIALIZED VIEW da.geopoliticalunits AS
 SELECT DISTINCT sgp.geopoliticalid,
    gpu.geopoliticalname,
    gpu.rank,
    gpu.highergeopoliticalid
   FROM ndb.sitegeopolitical sgp
     JOIN ndb.geopoliticalunits gpu ON gpu.geopoliticalid = sgp.geopoliticalid
  ORDER BY gpu.geopoliticalname;

CREATE INDEX geopolrank ON da.geopoliticalunits USING hash(rank);

 CREATE OR REPLACE FUNCTION da.refresh_sitegeopol()
 RETURNS TRIGGER LANGUAGE plpgsql
 AS $$
   BEGIN
   REFRESH MATERIALIZED VIEW CONCURRENTLY da.geopoliticalunits;
   RETURN NULL;
END $$;

CREATE TRIGGER da_geopol_trigger
   AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
   ON ndb.sitegeopolitical
   FOR EACH STATEMENT
EXECUTE PROCEDURE da.refresh_sitegeopol(); 