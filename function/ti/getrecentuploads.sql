create or replace function ti.getrecentuploads(_months integer DEFAULT 1,
                                               _databaseid integer DEFAULT null,
                                               _datasettypeid integer DEFAULT null,
                                               _limit integer DEFAULT 400)
RETURNS TABLE(datasetid integer,
              datasettype character varying,
              sitename character varying,
              geopolitical character varying,
              databasename character varying,
              investigator character varying,
              recdatecreated character varying,
              steward character varying)
LANGUAGE sql
AS $function$
  SELECT ds.datasetid,
         dst.datasettype,
         sts.sitename,
         case when gp2.geopolname2 is null then gp1.geopolname1
 	            when gp3.geopolname3 is null then concat(gp1.geopolname1, ' | ', gp2.geopolname2)
 	            else concat(gp1.geopolname1, ' | ', gp2.geopolname2, ' | ', gp3.geopolname3)
        	end as geopolitical,
          cdb.databasename,
          STRING_AGG(pic.contactname, '; ') AS investigator,
          to_CHAR(ds.recdatecreated, 'text') AS recdatecreated,
   		    STRING_AGG(ct.contactname, '; ') as steward
  FROM ndb.datasets AS ds
    INNER JOIN         ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    INNER JOIN      ndb.collectionunits AS cu  ON ds.collectionunitid = cu.collectionunitid
    INNER JOIN                ndb.sites AS sts ON cu.siteid = sts.siteid
    INNER JOIN               ti.geopol1 AS gp1 ON sts.siteid = gp1.siteid
    INNER JOIN   ndb.datasetsubmissions AS dss ON ds.datasetid = dss.datasetid
    INNER JOIN ndb.constituentdatabases AS cdb ON dss.databaseid = cdb.databaseid
    INNER JOIN             ndb.contacts AS ct  ON dss.contactid = ct.contactid
    INNER JOIN           ndb.datasetpis AS dpi ON dpi.datasetid = ds.datasetid
    INNER JOIN             ndb.contacts AS pic ON pic.contactid = dpi.contactid
    LEFT OUTER JOIN          ti.geopol3 AS gp3 ON sts.siteid = gp3.siteid
    LEFT OUTER JOIN          ti.geopol2 AS gp2 ON sts.siteid = gp2.siteid
  WHERE
    (_databaseid IS NULL OR _databaseid = dss.databaseid) AND
    (dss.recdatecreated >= 'now'::timestamp - CONCAT(_months, ' month')::interval) AND
    (_datasettypeid IS NULL OR ds.datasettypeid = _datasettypeid)
  GROUP BY ds.datasetid, dst.datasettype, sts.sitename, gp1.geopolname1, gp2.geopolname2, gp3.geopolname3, cdb.databasename, ds.recdatecreated
    order by ds.recdatecreated desc

  LIMIT _limit
$function$
