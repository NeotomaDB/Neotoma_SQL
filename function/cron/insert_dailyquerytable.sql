SELECT cron.schedule('00 00 * * *', 

    'INSERT INTO ap.querytable SELECT * FROM ap.dailyquerytable(''2'')
    ON CONFLICT (datasetid, chronologyid) DO UPDATE
   SET siteid = EXCLUDED.siteid,
       sitename = EXCLUDED.sitename,
       datasetid = EXCLUDED.datasetid,
       chronologyid = EXCLUDED.chronologyid,
       altitude = EXCLUDED.altitude,
       datasettype = EXCLUDED.datasettype,
       databaseid = EXCLUDED.databaseid,
       collectionunitid = EXCLUDED.collectionunitid,
       colltype = EXCLUDED.colltype,
       depenvt = EXCLUDED.depenvt,
       geog = EXCLUDED.geog,
       older = EXCLUDED.older,
       younger = EXCLUDED.younger,
       agetype = EXCLUDED.agetype,
       taxa = EXCLUDED.taxa,
       keywords = EXCLUDED.keywords,
       contacts = EXCLUDED.contacts,
       collectionunit = EXCLUDED.collectionunit,
       publications = EXCLUDED.publications,
       geopol = EXCLUDED.geopol;');