CREATE TABLE ap.sitetable WITH (autovacuum_enabled = false) AS (
    WITH collunit AS (
        SELECT sts.siteid,
            jsonb_build_object('collectionunitid', clu.collectionunitid,
                                'collectionunit', clu.collunitname,
                                        'handle', clu.handle,
                            'collectionunittype', cts.colltype,
                                    'datasets', jsonb_agg(jsonb_build_object('datasetid', dts.datasetid,
                                                                           'datasettype', dst.datasettype))) AS collectionunit
        FROM
            ndb.datasets AS dts
            LEFT JOIN ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid
            LEFT JOIN           ndb.sites AS sts ON           sts.siteid = clu.siteid
            LEFT OUTER JOIN    ndb.datasettypes AS dst ON    dst.datasettypeid = dts.datasettypeid
            LEFT OUTER JOIN ndb.collectiontypes AS cts ON       clu.colltypeid = cts.colltypeid
        GROUP BY sts.siteid, clu.collectionunitid, cts.colltype
    ),
    geopol AS (
        SELECT DISTINCT sts.siteid,
        unnest(array_append(gp.geoout, gp.geoin::int)) AS gpid
        FROM ndb.sites AS sts
        LEFT JOIN ndb.sitegeopolitical AS sgp ON sts.siteid = sgp.siteid
        LEFT JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
        LEFT JOIN ndb.geopaths AS gp ON gp.geoin = sgp.geopoliticalid
        
    )
    SELECT sts.siteid,
        sts.sitename as sitename,
        ST_AsGeoJSON(sts.geog,5,2) as geography,
        array_agg(DISTINCT gp.gpid) AS geopol,
        sts.altitude AS altitude,
        sts.area AS area,
        sts.notes AS notes,
        jsonb_agg(DISTINCT cus.collectionunit) AS collectionunits
    FROM
    (SELECT * FROM collunit) AS cus
    LEFT JOIN ndb.sites AS sts ON cus.siteid = sts.siteid
    LEFT JOIN geopol AS gp ON gp.siteid = sts.siteid
    GROUP BY sts.siteid LIMIT 15;
    );

CREATE INDEX sitetable_siteidindex ON ap.sitetable(siteid);
CREATE INDEX sitetable_sitenameindex ON ap.sitetable USING GIST (sitename gist_trgm_ops);
CREATE INDEX sitetable_altitudeidx ON ap.sitetable(altitude);
