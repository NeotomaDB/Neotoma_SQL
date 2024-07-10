CREATE FUNCTION ap.dailyquerytable(_interval VARCHAR)
RETURNS TABLE (siteid INT,
        sitename VARCHAR,
        datasetid INT,
        chronologyid INT,
        altitude FLOAT,
        datasettype VARCHAR,
        databaseid INT,
        collectionunitid INT,
        colltype VARCHAR,
        depenvt VARCHAR,
        geog GEOGRAPHY,
        older FLOAT,
        younger FLOAT,
        agetype VARCHAR,
        publications INT[],
        taxa INT[],
        keywords INT[],
        contacts INT[],
        collectionunit JSONB,
        geopol INT[])
AS $$
WITH allids AS (
        SELECT st.siteid,
        unnest(array_append(gp.geoout, gp.geoin::int)) AS geopol
        FROM ndb.sites AS st
        INNER JOIN ndb.sitegeopolitical AS sgp ON st.siteid = sgp.siteid
        INNER JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
        INNER JOIN ndb.geopaths AS gp ON gp.geoin = sgp.geopoliticalid
    ),
    sgp AS (
        SELECT siteid, array_agg(DISTINCT geopol) AS geopol
        FROM allids
        GROUP BY siteid
    )
    SELECT st.siteid,
        st.sitename,
        ds.datasetid,
        chron.chronologyid,
        st.altitude,
        dst.datasettype,
        dsdb.databaseid,
        cu.collectionunitid,
        cut.colltype,
        dvt.depenvt,
        st.geog,
        arg.older,
        arg.younger,
        agetypes.agetype,
        array_remove(array_agg(DISTINCT dspb.publicationid), NULL) AS publications,
        array_remove(array_agg(DISTINCT var.taxonid), NULL) AS taxa,
        array_remove(array_agg(DISTINCT smpkw.keywordid), NULL) AS keywords,
        array_remove(array_agg(DISTINCT dpi.contactid) || array_agg(DISTINCT sma.contactid), NULL) AS contacts,
        jsonb_build_object('collectionunitid', cu.collectionunitid,
							 'collectionunit', cu.collunitname,
									 'handle', cu.handle,
						 'collectionunittype', cut.colltype,
								   'datasets', json_agg(DISTINCT jsonb_build_object('datasetid', ds.datasetid,
                                                                        'datasettype', dst.datasettype))) AS collectionunit,
        sgp.geopol
    FROM ndb.sites AS st
    LEFT OUTER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
    LEFT OUTER JOIN ndb.collectiontypes AS cut ON cut.colltypeid = cu.colltypeid
    LEFT OUTER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
    LEFT OUTER JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = cu.depenvtid
    LEFT OUTER JOIN ndb.datasetpis AS dpi ON dpi.datasetid = ds.datasetid
    LEFT OUTER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    LEFT OUTER JOIN ndb.datasetdatabases AS dsdb ON ds.datasetid = dsdb.datasetid
    LEFT OUTER JOIN ndb.datasetpublications AS dspb ON dspb.datasetid = ds.datasetid
    LEFT OUTER JOIN ndb.chronologies AS chron ON chron.collectionunitid = ds.collectionunitid
    LEFT OUTER JOIN ndb.dsageranges AS arg ON ds.datasetid = arg.datasetid AND chron.agetypeid = arg.agetypeid
    LEFT OUTER JOIN ndb.agetypes  AS agetypes ON agetypes.agetypeid = arg.agetypeid
    LEFT OUTER JOIN ndb.samples AS smp ON smp.datasetid = ds.datasetid 
    LEFT OUTER JOIN ndb.sampleanalysts AS sma ON sma.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.samplekeywords AS smpkw ON smpkw.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.variables AS var ON var.variableid = dt.variableid
    LEFT OUTER JOIN sgp AS sgp ON st.siteid = sgp.siteid
    WHERE ds.recdatemodified > current_date - (_interval || 'day')::INTERVAL OR
          smp.recdatemodified > current_date - (_interval || 'day')::INTERVAL OR
          st.recdatemodified > current_date - (_interval || 'day')::INTERVAL    
    GROUP BY st.siteid,
        cu.collectionunitid,
        st.sitename,
        ds.datasetid,
        cut.colltype,
        chron.chronologyid,
        dsdb.databaseid,
        st.altitude,
        dst.datasettype,
        st.geog,
        arg.older,
        arg.younger,
        agetypes.agetype,
        sgp.geopol,
        dvt.depenvt
$$ LANGUAGE sql;