CREATE OR REPLACE FUNCTION ap.siteobject(_siteid integer)
 RETURNS TABLE(siteid integer, 
               sitename character varying,
               sitedescription character varying,
               geography text,
               area double precision,
               altitude double precision,
               notes text,
               geopolitical character varying[])
 LANGUAGE sql
AS $function$
    SELECT sts.siteid,
        sts.sitename as sitename,
        sts.sitedescription AS sitedescription,
        ST_AsGeoJSON(sts.geog,5,2) as geography,
        sts.area AS area,
        sts.altitude AS altitude,
        sts.notes AS notes,
        gpn.names AS geopolitical
    FROM
    ndb.sites AS sts
    LEFT JOIN ap.geopolnames AS gpn ON gpn.siteid = sts.siteid
    WHERE sts.siteid = _siteid
    GROUP BY sts.siteid, sts.sitename, sts.sitedescription, ST_AsGeoJSON(sts.geog,5,2), 
		 sts.area, sts.altitude, sts.notes, gpn.names;
$function$;

CREATE OR REPLACE FUNCTION ap.siteobject(_siteid integer[])
 RETURNS TABLE(siteid integer, 
               sitename character varying,
               sitedescription character varying,
               geography text,
               area double precision,
               altitude double precision,
               notes text,
               geopolitical character varying[])
 LANGUAGE sql
AS $function$
    SELECT sts.siteid,
        sts.sitename as sitename,
        sts.sitedescription AS sitedescription,
        ST_AsGeoJSON(sts.geog,5,2) as geography,
        sts.area AS area,
        sts.altitude AS altitude,
        sts.notes AS notes,
        gpn.names AS geopolitical
    FROM
    ndb.sites AS sts
    LEFT JOIN ap.geopolnames AS gpn ON gpn.siteid = sts.siteid
    WHERE sts.siteid = ANY(_siteid)
    GROUP BY sts.siteid, sts.sitename, sts.sitedescription, ST_AsGeoJSON(sts.geog,5,2), 
		 sts.area, sts.altitude, sts.notes, gpn.names;
$function$;