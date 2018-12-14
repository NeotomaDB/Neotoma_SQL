CREATE OR REPLACE FUNCTION ti.getnearestsites(_east numeric, _north numeric, _west numeric, _south numeric, _distkm numeric)
 RETURNS TABLE(siteid integer, sitename character varying, distkm double precision, geopolitical text)
 LANGUAGE plpgsql
AS $function$
DECLARE
	_distm integer := 1000*_distkm;
	_site1 geography;

BEGIN
	IF ((_north > _south) and (_east > _west)) THEN
	  _site1 :=  ST_GeomFromEWKT('SRID=4326;POLYGON((' ||
				   cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || ', ' ||
				   cast(cast(_east as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || ', ' ||
				   cast(cast(_east as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_north as decimal(20,15)) as varchar(20)) || ', ' ||
				   cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_north as decimal(20,15)) as varchar(20)) || ', ' ||
				   cast(cast(_west as decimal(20,15)) as varchar(20)) || ' ' || cast(cast(_south as decimal(20,15)) as varchar(20)) || '))')::geography;
	ELSE
	  _site1 := st_geomfromtext('point(' + cast(cast(_west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(_north as decimal(20,15)) as varchar(20)) + ')', 4326)::geography;

	END IF;

	return query select     ndb.sites.siteid, ndb.sites.sitename, ST_DISTANCE(ST_Centroid(_site1::geometry), ST_Centroid(geog::geometry), true)/1000 as distkm,
			   (ti.geopol1.geopolname1 ||
			   (CASE WHEN ti.geopol2.geopolname2 IS NOT NULL THEN '|' || ti.geopol2.geopolname2 ||
				    (CASE WHEN ti.geopol3.geopolname3 IS NOT NULL THEN '|' || ti.geopol3.geopolname3 ELSE '' END) ||
				   (CASE WHEN ti.geopol4.geopolname4 IS NOT NULL THEN '|' || ti.geopol4.geopolname4 ELSE '' END) ELSE '' END)) as geopolitical
	from       ndb.sites left outer join
						  ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid left outer join
						  ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid left outer join
						  ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
						  ti.geopol4 on ndb.sites.siteid = ti.geopol4.siteid
	where  ST_DISTANCE(ST_Centroid(_site1::geometry), ST_Centroid(geog::geometry), true) <= _distm
	order by distkm;

END;
$function$
