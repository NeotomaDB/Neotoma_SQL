CREATE OR REPLACE FUNCTION ap.gettaxaindatasets()
 RETURNS TABLE(taxonid integer,
               taxonname character varying,
               taxagroupid character varying,
               datasettypeid jsonb)
 LANGUAGE sql
AS $function$
    SELECT t.taxonid,
           t.taxonname,
           t.taxagroupid,
           jsonb_agg(dtgt.datasettypeid) as datasettypeid
    FROM ndb.taxa AS t
    LEFT JOIN ndb.datasettaxagrouptypes AS dtgt ON t.taxagroupid = dtgt.taxagroupid
    INNER JOIN ndb.variables AS v ON t.taxonid = v.taxonid
    WHERE t.valid = True
    GROUP BY t.taxonid, t.taxonname, t.taxagroupid
    ORDER BY t.taxonname
$function$;