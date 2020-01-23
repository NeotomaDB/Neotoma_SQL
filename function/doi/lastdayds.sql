CREATE OR REPLACE FUNCTION doi.lastdayds()
 RETURNS TABLE(datasets integer[], contactname character varying, leadinginitials character varying, givennames character varying, familyname character varying, suffix character varying, title character varying, phone character varying, email character varying, address character varying, url character varying)
 LANGUAGE sql
AS $function$

  SELECT array_agg(ds.datasetid) AS datasets,
        cts.contactname,
		    cts.leadinginitials,
        cts.givennames,
        cts.familyname,
        cts.suffix,
        cts.title,
        cts.phone,
        cts.email,
        cts.address,
        cts.url
  FROM ndb.datasets AS ds
  JOIN ndb.datasetpis AS dspi ON dspi.datasetid = ds.datasetid
  JOIN ndb.contacts AS cts ON cts.contactid = dspi.contactid
  LEFT JOIN ndb.datasetdoi AS dsdoi ON dsdoi.datasetid = ds.datasetid
	LEFT JOIN doi.frozen AS frz ON frz.datasetid = ds.datasetid
  WHERE
  dsdoi.doi IS NULL AND
	frz.download IS NULL AND
  age(ds.recdatecreated) > interval '1 day'
  GROUP BY cts.contactname,
		cts.leadinginitials,
		cts.givennames,
		cts.familyname,
		cts.suffix,
		cts.title,
		cts.phone,
		cts.email,
		cts.address,
		cts.url
$function$
