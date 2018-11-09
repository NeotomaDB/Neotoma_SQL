CREATE OR REPLACE FUNCTION ap.explorersearch3(_taxonids da.int_list_type, _elemtypeids da.int_list_type, _taphtypeids da.int_list_type, _depenvids da.int_list_type, _abundpct integer DEFAULT NULL::integer, _datasettypeid integer DEFAULT NULL::integer, _keywordid integer DEFAULT NULL::integer, _coords character varying DEFAULT NULL::character varying, _gpid integer DEFAULT NULL::integer, _altmin integer DEFAULT NULL::integer, _altmax integer DEFAULT NULL::integer, _coltypeid integer DEFAULT NULL::integer, _dbid integer DEFAULT NULL::integer, _sitename character varying DEFAULT NULL::character varying, _contactid integer DEFAULT NULL::integer, _ageold integer DEFAULT NULL::integer, _ageyoung integer DEFAULT NULL::integer, _agedocontain boolean DEFAULT true, _agedirectdate boolean DEFAULT false, _subdate date DEFAULT NULL::date, _debug boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE sql varchar;
		paramlist varchar;
		doabund boolean := '0';
		doelem boolean := '0';
		dotaph boolean := '0';
		dodepenv boolean := '0';
		notaxa boolean := '0';
		sumgroupid int := null;
		poly geography := null;
		ctebase varchar;
		ctebaseselect varchar;
		ctebasefrom varchar;
		ctebasewhere varchar;
		cteages varchar;
		cteagesselect varchar;
		cteagesfrom varchar;
		cteageswhere varchar;
		cteds varchar;
		ctedsselect varchar;
		ctedsfrom varchar;
		ctedswhere varchar;

BEGIN
	IF (SELECT count(*) from _depenvids) > 0 THEN
	  dodepenv := '1';
	END IF;
	IF (SELECT count(*) from _taxonids) < 1 THEN
	  notaxa := '1';
	  --some kind of GOTO dataset here--

		IF notaxa = 1 THEN
			ctebase := '';
			cteages := '';
			cteds := '       WITH ';
		ELSE
			cteds := ',
			';
			cteds := cteds + 'ds AS (';
			ctedsselect := '
				SELECT
				  ds.datasetid,
				  ds.datasettypeid,
				  ds.isembargo,
				  ds.recdatecreated,
				  cu.colltypeid,
				  cu.depenvtid,
				  cu.handle,
				  cu.collunitname,
				  s.siteid,
				  s.sitename,
				  s.sitedescription,
				  s.notes,
				  s.altitude,
				  s.geog,
				  s.latitudenorth,
				  s.latitudesouth,
				  s.longitudeeast,
				  s.longitudewest,
				  ages.ageoldest,
				  ages.ageyoungest,
				  ages.maxage,
				  ages.minage';
			cteDsFrom := '
				JOIN ndb.collectionunits cu ON ds.collectionunitid = cu.collectionunitid
				JOIN ndb.sites s ON cu.siteid = s.siteid';
		END IF;
		IF notaxa = 1 THEN
		  ctedsfrom := '
			FROM
			  ndb.datasets ds' + ctedsfrom;
			IF NOT (ageold IS NULL AND ageyoung IS NULL) THEN
			  ctedsfrom := ctedsfrom + '
			  JOIN da.vbestdatasetages ages ON ds.datasetid = ages.datasetid';
			ELSE
			  ctedsfrom := ctedsfrom + '
			  LEFT JOIN da.vbestdatasetages ages ON ds.datasetid = ages.datasetid';
			END IF;
		ELSE
	 		ctedsfrom := '
				FROM
			  		ages
			  		JOIN ndb.datasets ds ON ages.datasetid = ds.datasetid' + ctedsfrom;
	    END IF;
	
		ctedswhere := '
			WHERE
			  1=1';


		IF siteName IS NOT NULL THEN                                           
			ctedswhere := ctedswhere + ' 
			  AND s.sitename LIKE ''%'' + sitename + ''%''';
		END IF;
		IF subdate IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND ds.recdatecreated >= subdate';
		END IF;
		IF gpid IS NOT NULL THEN                                               
		  ctedswhere := ctedswhere + ' 
			  AND EXISTS (SELECT *
						  FROM   ndb.sitegeopolitical gp
						  WHERE  gp.siteid = s.siteid
						  AND    gp.geopoliticalid = gpid)';
		END IF;
		IF dodepenv = 1 THEN
		  ctedswhere := ctedswhere + ' 
			  AND cu.depenvtid IN (SELECT n FROM depenvids)';
		END IF;
		IF coltypeid IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND cu.colltypeid = coltypeid';
		END IF;
		IF altmin IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND s.altitude >= altmin';
		END IF;
		IF altMax IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND s.altitude <= altmax';
		END IF;
		IF dbid IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND EXISTS (SELECT *
						  FROM   ndb.datasetdatabases db
						  WHERE  db.datasetid = ds.datasetid
						  AND    db.databaseid = dbid)';
		END IF;
		IF contactid IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND EXISTS (SELECT *
						  FROM   ap.datasetpisauthors p
						  WHERE  p.datasetid = ds.datasetid
						  AND    p.contactid = contactid)';
		END IF;
		IF keywordid IS NOT NULL AND notaxa = 1 THEN                                              
		  ctedswhere := ctedswhere + ' 
			  AND EXISTS (SELECT k.datasetid, k.keywordid
						  FROM   ap.datasetkeywords k
						  WHERE  k.datasetid = ds.datasetid
						  AND    k.keywordid = keywordid)';
		END IF;
		IF datasettypeid IS NOT NULL THEN
		  ctedswhere := ctedswhere + ' 
			  AND ds.datasettypeid = datasettypeid';
		END IF;
		IF noTaxa = 1 AND NOT (_ageold IS NULL AND _ageyoung IS NULL) THEN
		  	IF _ageold IS NULL THEN
			  _ageold := 10000000;
			END IF;
			IF _ageyoung IS NULL THEN
			  _ageyoung := -250;
			END IF;
			IF _agedocontain = 1 THEN
			  ctedswhere := ctedswhere + ' 
			  AND (
				(ageyoung <= ages.ageyoungest AND _ageold >= ages.ageoldest) OR 
				(ageyoung <= ages.minage AND _ageold >= ages.maxage)
			  )';
			  ELSE
				ctedswhere = ctedswhere + '
			  AND (
				NOT (ages.ageyoungest < _ageold OR ages.ageoldest > _ageyoung ) OR
				NOT (ages.agemin < _ageold OR ages.agemax > _ageyoung )
			  )';
			END IF;
		END IF;
		IF coords IS NOT NULL THEN
			/* SET poly = STPolyFromText(_coords, 4326);
			-- re-orient poly of ring defined clockwise
			IF poly.EnvelopeAngle() >= 90 THEN
			  SET poly = poly.ReorientObject();
			END IF */
			ctedswhere := ctedswhere + ' 
			  AND s.geog.STIntersects(poly) = 1';
		 END IF;

		cteds := cteds + ctedsselect + ctedsfrom + ctedswhere + '
		  )';

	  RAISE NOTICE 'cteds = %', cteds;

	  --end of dataset block--
   	END IF;

	IF (SELECT count(*) from _elemTypeIds) > 0 THEN
		doElem := '1';
	END IF;

	IF (SELECT count(*) from _taphTypeIds) > 0 THEN
		doTaph := '1';
	END IF;

	IF _abundPct IS NOT NULL THEN
		BEGIN
			-- get SumGroupID of the first (or only) taxon id
			 sumGroupId := (SELECT sg.sumgroupid FROM ndb.ecolgroups eg
				JOIN ap.pollensumgroups sg ON eg.ecolgroupid = sg.ecolgroupid
			WHERE	
				eg.taxonid IN (SELECT n FROM _taxonIds LIMIT 1));
			IF sumGroupId > 0 THEN
		  		doAbund := '1';
			END IF;
		END;
	END IF;

	-- START building standard base CTE
	IF _ageDirectDate = '0' THEN
		BEGIN
			cteBase := 'WITH base AS (';
		    cteBaseSelect := '
		    SELECT s.sampleid, s.datasetid';
		    cteBaseFrom := '
		    FROM ndb.samples s
		    JOIN ndb.data d ON s.sampleid = d.sampleid
		    JOIN ndb.variables v ON d.variableid = v.variableid';
		    cteBaseWhere := '
		    	WHERE';
	
		    IF doAbund = '1' THEN
		      BEGIN
		        cteBaseSelect := cteBaseSelect || ',
		        v.taxonid,
		        CAST(d.value / SUM(d.value) OVER(PARTITION BY s.sampleid) * 100 AS DECIMAL(5,2)) AS abundance';   
			    cteBaseFrom := cteBaseFrom || '  
			  		JOIN ndb.taxa t ON v.taxonid = t.taxonid 
			  		JOIN ndb.ecolgroups e ON t.taxonid = e.taxonid 
			  		JOIN ap.pollensumgroups sg ON e.ecolgroupid = sg.ecolgroupid';
			    cteBaseWhere := cteBaseWhere || '
			  		sg.sumgroupid = ' || sumGroupId;
		      END;
		    ELSE
		      BEGIN
			    cteBaseWhere := cteBaseWhere || '
			  		v.taxonid IN (SELECT n FROM _taxonIds)';
		        IF doElem = '1' THEN
				  BEGIN
				    cteBaseFrom := cteBaseFrom || '
			  			JOIN ndb.variableelements ve ON v.variableelementid = ve.variableelementid';
			        cteBaseWhere = cteBaseWhere || '
			  			AND ve.elementtypeid IN (SELECT n FROM _elemTypeIds)';
			      END;
				END IF;
			    IF doTaph = '1' THEN
			      BEGIN
			        cteBaseFrom := cteBaseFrom || '
			      		JOIN ndb.summarydatataphonomy ta ON ta.dataid = d.dataid';
			        cteBaseWhere := cteBaseWhere || '
			      		AND ta.taphonomictypeid IN (SELECT n FROM _taphTypeIds)';
			      END;
				END IF;
		      END;
			END IF;
		    IF _keywordId IS NOT NULL THEN
		      BEGIN
			    cteBaseFrom := cteBaseFrom || '
			  		JOIN ndb.samplekeywords k on s.sampleid = k.sampleid';
			    cteBaseWhere := cteBaseWhere || '
			  		AND k.KeywordID = _keywordId';
			  END;
			END IF;
	
	        -- cteBase := cteBase || cteBaseSelect || cteBaseFrom || cteBaseWhere || '
		  	--	)';

			cteBase := cteBaseSelect || cteBaseFrom || cteBaseWhere;
		END;	
	END IF; 
	-- END building base CTE

	-- START building standard ages CTE
	IF _ageDirectDate = '0' THEN
	  BEGIN
	    cteAges := ',
	  ages AS (';
	    cteAgesSelect := '
	    SELECT
		  base.datasetid,
		  MIN(sa.age) AS MinAge,
		  MAX(sa.age) AS MaxAge,
		  MIN(sa.ageyounger) AS AgeYoungest,
		  MAX(sa.ageolder) AS AgeOldest';
	    cteAgesFrom := '
	    FROM
		  base';
	    cteAgesWhere := '
	    WHERE
		  1=1';

	   IF doAbund THEN
		  cteAgesWhere := cteAgesWhere || '
		  AND base.abundance > ' || _abundPct ||
		  ' AND base.taxonid IN (SELECT n FROM _taxonIds))';
	   END IF;
		
	    IF NOT (_ageOld IS NULL AND _ageYoung IS NULL) THEN
	      BEGIN
	  	    cteAgesFrom := cteAgesFrom || '
		  JOIN da.vsampagesstd sa ON base.sampleid = sa.sampleid';
		    IF _ageOld IS NULL THEN
		      _ageOld := 10000000;
			END IF;
		    IF _ageYoung IS NULL THEN
		      _ageYoung := -250;
			END IF;
		    IF _ageDoContain = '1' THEN
		      cteAgesWhere := cteAgesWhere || ' 
		  AND (
			(' || _AgeYoung || '<= sa.age AND sa.age <= ' || _AgeOld || ') OR
			(' || _AgeYoung || '<= sa.ageyounger AND sa.ageolder <= ' || _AgeOld || ')
		  )';
		    ELSE
		      cteAgesWhere := cteAgesWhere || '
		  AND (
			(' || _AgeYoung || ' <= sa.age AND sa.age <= ' || _AgeOld || ') OR
			NOT (sa.ageolder < ' || _ageYoung || ' OR ' || _ageOld || '< sa.ageyounger)
		  )';
		    END IF;
		  END;
	    ELSE
	      cteAgesFrom := cteAgesFrom + '
		  LEFT JOIN da.vsampagesstd sa ON base.sampleid = sa.sampleid';
		END IF;

        cteAges := cteAges || cteAgesSelect || cteAgesFrom || cteAgesWhere || ' GROUP BY base.datasetid)';
	  END;
	END IF;
	-- END building ages CTE --

	 RAISE NOTICE 'cteAges = %', cteAges;

	-- block for alternative combined base/ages CTE for directly dated specimens will go here --


END;
$function$
