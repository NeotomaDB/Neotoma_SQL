CREATE OR REPLACE FUNCTION ap.gettaxaindatasetsv2()
 RETURNS TABLE(taxonid integer, taxonname character varying, taxagroupid character varying, datasettypeid integer)
 LANGUAGE sql
AS $function$

    SELECT t.taxonid, t.taxonname, t.taxagroupid, dtgt.datasettypeid
    FROM ndb.taxa AS t LEFT JOIN
    ndb.datasettaxagrouptypes AS dtgt ON t.taxagroupid = dtgt.taxagroupid INNER JOIN
    ndb.variables AS v ON t.taxonid = v.taxonid 
    WHERE t.valid = 1
    GROUP BY t.taxonid, t.taxonname, dtgt.datasettypeid, t.taxagroupid
    ORDER BY t.taxonname, dtgt.datasettypeid

$function$
