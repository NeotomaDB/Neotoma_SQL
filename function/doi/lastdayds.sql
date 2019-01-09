CREATE  OR REPLACE FUNCTION doi.lastdayds()
RETURNS TABLE(datasets INTEGER[],
			   contactname CHARACTER VARYING,
		       leadinginitials CHARACTER VARYING,
			   givennames CHARACTER VARYING,
			  familyname CHARACTER VARYING,
			  suffix CHARACTER VARYING,
			  title CHARACTER VARYING,
			  phone CHARACTER VARYING,
			  email CHARACTER VARYING,
			  address CHARACTER VARYING,
			  url CHARACTER VARYING)
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
	frz.record IS NULL AND
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
