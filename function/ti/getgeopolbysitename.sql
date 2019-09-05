CREATE OR REPLACE FUNCTION ti.getgeopolbysitename(_sitename character varying, _east double precision, _north double precision, _west double precision, _south double precision)
 RETURNS TABLE(siteid integer, sitename character varying, distkm double precision, geopolitical text)
 LANGUAGE plpgsql
AS $function$
  DECLARE
    _site1 geometry;
    _geopolname1 varchar(255);
    _geopolname2 varchar(255);
    _geopolname3 varchar(255);
    _geopolname4 varchar(255);
    _geopolstring varchar(255);


  BEGIN
  --simple point of polygon test for inputs
  IF ((_north > _south) AND (_east > _west)) THEN

    SELECT ST_GeomFromText('POLYGON((' ||
                 cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || ', ' ||
                 cast(cast(_east as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || ', ' ||
           cast(cast(_east as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_north as decimal(20,15)) as varchar(20)) || ', ' ||
           cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_north as decimal(20,15)) as varchar(20)) || ', ' ||
           cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || '))', 4326)
       into _site1 ;

  ELSE
    SELECT ST_GeomFromText('POINT(' ||
            cast(cast(_west as decimal(20,15)) as varchar(20))
            || ' ' || cast(cast(_north as decimal(20,15)) as varchar(20)) || ')', 4326)
       into _site1 ;
  END IF;

  RETURN QUERY
  SELECT
      s.siteid,
      s.sitename,
      ST_Distance(ST_Centroid(_site1)::geography, s.geog)/1000 as "distkm",
      concat_ws('|',g1.geopolname1, g2.geopolname2, g2.geopolname2, g3.geopolname3, g4.geopolname4) as geopolitical
  FROM
      ndb.sites s LEFT OUTER JOIN
      ti.geopol1 g1 on s.siteid = g1.siteid left outer join
      ti.geopol2 g2 on s.siteid = g2.siteid left outer join
      ti.geopol3 g3 on s.siteid = g3.siteid left outer join
      ti.geopol4 g4 on s.siteid = g4.siteid
  WHERE   (s.sitename LIKE _sitename)
  ORDER BY distkm ;

  END;
$function$
