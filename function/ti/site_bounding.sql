CREATE OR REPLACE FUNCTION ti.site_bounding()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
   IF NEW.latitudenorth IS NULL AND NEW.geog IS NOT NULL THEN
   UPDATE ndb.sites
   SET (longitudeeast, latitudenorth, longitudewest, latitudesouth) =
     (ST_XMax(geog::geometry),
      ST_YMax(geog::geometry),
      ST_XMin(geog::geometry),
      ST_YMin(geog::geometry));
   END IF;
   RETURN NEW;
END;

$function$
