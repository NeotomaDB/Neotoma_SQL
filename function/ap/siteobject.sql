
DROP FUNCTION ap.siteobject(_siteid integer);
CREATE OR REPLACE FUNCTION ap.siteobject(_siteid integer)
 RETURNS TABLE(siteid integer, site jsonb)
 LANGUAGE sql
AS $function$
    SELECT sts.siteid,
        jsonb_build_object('sitename', sts.sitename,
                    'sitedescription', sts.sitedescription,
                          'geography', ST_AsGeoJSON(sts.geog,5,2),
                               'area', sts.area,
                           'altitude', sts.altitude,
                              'notes', sts.notes,
                       'geopolitical', gpn.names) AS site
    FROM
    ndb.sites AS sts
    LEFT JOIN ap.geopolnames AS gpn ON gpn.siteid = sts.siteid
    WHERE sts.siteid = _siteid
    GROUP BY sts.siteid, sts.sitename, sts.sitedescription, ST_AsGeoJSON(sts.geog,5,2), 
		 sts.area, sts.altitude, sts.notes, gpn.names;
$function$;

COMMENT ON FUNCTION ap.siteobject(_siteid integer) IS 'Create the JSON object used to return relevant site metadata from a single siteid.';

DROP FUNCTION ap.siteobject(_siteid integer[]);
CREATE OR REPLACE FUNCTION ap.siteobject(_siteid integer[])
 RETURNS TABLE(siteid integer, site jsonb)
 LANGUAGE sql
AS $function$
    SELECT sts.siteid,
        jsonb_build_object('sitename', sts.sitename,
                    'sitedescription', sts.sitedescription,
                          'geography', ST_AsGeoJSON(sts.geog,5,2),
                               'area', sts.area,
                           'altitude', sts.altitude,
                              'notes', sts.notes,
                       'geopolitical', gpn.names) AS site
    FROM
    ndb.sites AS sts
    LEFT JOIN ap.geopolnames AS gpn ON gpn.siteid = sts.siteid
    WHERE sts.siteid = ANY(_siteid)
    GROUP BY sts.siteid, sts.sitename, sts.sitedescription, ST_AsGeoJSON(sts.geog,5,2), 
		 sts.area, sts.altitude, sts.notes, gpn.names;
$function$;
COMMENT ON FUNCTION ap.siteobject(_siteid integer[]) IS 'Create the JSON object used to return relevant site metadata from an array of siteids.';