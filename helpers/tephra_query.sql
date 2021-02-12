SELECT ds.datasetid,
       dst.datasettype,
       st.sitename,
       ST_asText(st.geog),
       ds.notes AS datasetnotes,
       au.analysisunitid,
       au.analysisunitname,
       au.notes AS analysisunitnotes,
       ev.eventname,
       tph.notes AS tephranotes
FROM ndb.tephras AS tph
INNER JOIN ndb.analysisunits AS au ON au.analysisunitid = tph.analysisunitid
INNER JOIN ndb.collectionunits AS cu ON au.collectionunitid = cu.collectionunitid
INNER JOIN ndb.events AS ev ON ev.eventid = tph.eventid
INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
INNER JOIN ndb.datasettypes AS dst ON ds.datasettypeid = dst.datasettypeid
INNER JOIN ndb.sites AS st ON st.siteid = cu.siteid
WHERE ev.eventname ILIKE'%tephra%'
