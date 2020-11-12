CREATE OR REPLACE FUNCTION ti.site_bounding() RETURNS TRIGGER
AS $$
BEGIN
   IF NEW.latitudenorth IS NULL AND NEW.geom IS NOT NULL THEN
   UPDATE ndb.sites
   SET (longitudeeast, latitudenorth, longitudewest, latitudesouth) =
     (ST_XMax(geog::geometry),
      ST_YMax(geog::geometry),
      ST_XMin(geog::geometry),
      ST_YMin(geog::geometry));
   END IF;
   RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER updatelocations
AFTER INSERT ON ndb.sites
FOR EACH ROW
EXECUTE PROCEDURE ti.site_bounding()
