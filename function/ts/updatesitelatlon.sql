CREATE OR REPLACE FUNCTION ts.updatesitelatlon(_siteid integer, _stewardcontactid integer, _east numeric, _north numeric, _west numeric, _south numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
	oldgeo geometry := (SELECT geog FROM ndb.sites WHERE siteid = _siteid);
	geo geometry;
	wkt text;

BEGIN
	IF ((_north > _south) AND (_east > _west)) THEN
		wkt := 'POLYGON(('::text ||
              CAST(CAST(_west AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_south AS numeric(20,15)) AS text) || ', ' ||
              CAST(CAST(_east AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_south AS numeric(20,15)) AS text) || ', ' ||
			  CAST(CAST(_east AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_north AS numeric(20,15)) AS text) || ', ' ||
			  CAST(CAST(_west AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_north AS numeric(20,15)) AS text) || ', ' ||
			  CAST(CAST(_west AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_south AS numeric(20,15)) AS text) || '))';
		geo := ST_MakeValid(ST_GeometryFromText(wkt,4326));
	ELSE
		wkt := 'POINT(' || CAST(CAST(_west AS numeric(20,15)) AS text) || ' ' || CAST(CAST(_north AS numeric(20,15)) AS text) || ')';
		geo := ST_MakeValid(ST_GeometryFromText(wkt, 4326));
	END IF;

	IF (ST_Equals(geo,oldgeo) IS FALSE) THEN
	    UPDATE ndb.sites
	    SET    geog = geo::geography WHERE siteid = _siteid;
	    INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
     	VALUES (_stewardcontactid, 'Sites', _siteid, 'Update', 'geog');
	END IF;

END;
$function$
