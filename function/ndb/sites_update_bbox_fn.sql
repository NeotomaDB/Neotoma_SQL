CREATE OR REPLACE FUNCTION ndb.sites_update_bbox_fn()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE 
    	currGeom geometry;
	BEGIN
		--no need to check for point or polygon
		currGeom := ST_GeomFromText(ST_AsText(NEW.geog));
			NEW.latitudenorth := ST_YMax(currGeom);
			NEW.latitudesouth := ST_YMin(currGeom);
			NEW.longitudeeast := ST_XMax(currGeom);
			NEW.longitudewest := ST_XMin(currGeom);
			RETURN NEW;		

	END
  $function$
