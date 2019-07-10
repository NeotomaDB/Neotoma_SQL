CREATE OR REPLACE FUNCTION ts.updatesite(_siteid int,
	_stewardcontactid int,
	_sitename varchar, 
	_east numeric DEFAULT NULL,
	_north numeric DEFAULT NULL,
	_west numeric DEFAULT NULL,
	_south numeric DEFAULT NULL,
	_altitude int DEFAULT NULL,
	_area numeric DEFAULT NULL,
	_descript varchar DEFAULT NULL,
	_notes varchar DEFAULT NULL)

RETURNS	void
AS $$
DECLARE

	oldsitename varchar(128) := (SELECT sitename FROM ndb.sites WHERE siteid = _siteid);
	oldaltitude numeric := (SELECT altitude FROM ndb.sites WHERE siteid = _siteid);
	oldarea numeric := (SELECT area FROM ndb.sites WHERE siteid = _siteid);
	oldsitedescription varchar := (SELECT sitedescription FROM ndb.sites WHERE siteid = _siteid);
	oldnotes varchar := (SELECT notes FROM ndb.sites WHERE siteid = _siteid);
	oldgeo geometry := (SELECT geog FROM ndb.sites WHERE siteid = _siteid);
	geo geometry;
	wkt text;
                                                                              

BEGIN

	IF oldsitename <> _sitename	THEN
		UPDATE ndb.sites
		SET sitename = _sitename WHERE siteid = _siteid;
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES      (_stewardcontactid, 'sites', _siteid, 'Update', 'sitename');
  	END IF;

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
     	VALUES      (_stewardcontactid, 'Sites', _siteid, 'Update', 'geog');
	END IF;

	IF _altitude IS NULL THEN
		IF oldaltitude IS NOT NULL THEN
			UPDATE ndb.sites
			SET altitude = NULL WHERE siteid = siteid; 
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
			VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'altitude');
		END IF;
	ELSIF (oldaltitude IS NULL) OR (_altitude <> oldaltitude) THEN
		UPDATE ndb.sites
		SET altitude = _altitude WHERE siteid = siteid; 
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'altitude');
	END IF;

	IF _area IS NULL THEN
		IF oldarea IS NOT NULL THEN
			UPDATE ndb.sites
			SET area = NULL WHERE siteid = siteid; 
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
			VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'area');
		END IF;
	ELSIF (oldarea IS NULL) OR (_area <> oldarea) THEN
		UPDATE ndb.sites
		SET area = _area WHERE siteid = siteid; 
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'area');
	END IF;

	IF _descript IS NULL THEN
		IF oldsitedescription IS NOT NULL THEN
			UPDATE ndb.sites
			SET sitedescription = NULL WHERE siteid = siteid; 
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
			VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'sitedescription');
		END IF;
	ELSIF (oldsitedescription IS NULL) OR (_descript <> oldsitedescription) THEN
		UPDATE ndb.sites
		SET sitedescription = _descript WHERE siteid = siteid; 
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'sitedescription');
	END IF;

	IF _notes IS NULL THEN
		IF oldnotes IS NOT NULL THEN
			UPDATE ndb.sites
			SET notes = NULL WHERE siteid = siteid; 
			INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
			VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'notes');
		END IF;
	ELSIF (oldnotes IS NULL) OR (_notest <> oldnotes) THEN
		UPDATE ndb.sites
		SET notes = _notes WHERE siteid = siteid; 
		INSERT INTO ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
		VALUES (_stewardcontactid, 'sites', _siteid, 'update', 'notes');
	END IF;
    
END;
$$ LANGUAGE plpgsql;