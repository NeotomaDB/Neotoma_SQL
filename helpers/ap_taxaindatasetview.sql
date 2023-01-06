CREATE OR REPLACE VIEW ap.taxaindatasetview
AS
SELECT t.taxonid,
           t.taxonname,
           t.taxagroupid,
           jsonb_agg(dtgt.datasettypeid) AS datasettypeids
    FROM ndb.taxa AS t
    LEFT JOIN ndb.datasettaxagrouptypes AS dtgt ON t.taxagroupid = dtgt.taxagroupid
    INNER JOIN ndb.variables AS v ON t.taxonid = v.taxonid
    WHERE t.valid = True
    GROUP BY t.taxonid, t.taxonname, t.taxagroupid
    ORDER BY t.taxonname;
REASSIGN OWNED BY sug335 TO functionwriter;
GRANT SELECT ON ap.querytable TO neotomawsreader;
