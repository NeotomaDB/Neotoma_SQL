CREATE OR REPLACE FUNCTION ap.explorersearch(_taxonids integer[], _elemtypeids integer[], _taphtypeids integer[], _depenvids integer[], _abundpct integer DEFAULT NULL::integer, _datasettypeid integer DEFAULT NULL::integer, _keywordid integer DEFAULT NULL::integer, _coords character varying DEFAULT NULL::character varying, _gpid integer DEFAULT NULL::integer, _altmin integer DEFAULT NULL::integer, _altmax integer DEFAULT NULL::integer, _coltypeid integer DEFAULT NULL::integer, _dbid integer DEFAULT NULL::integer, _sitename character varying DEFAULT NULL::character varying, _contactid integer DEFAULT NULL::integer, _ageold integer DEFAULT NULL::integer, _ageyoung integer DEFAULT NULL::integer, _agedocontain boolean DEFAULT true, _agedirectdate boolean DEFAULT false, _subdate date DEFAULT NULL::date, _debug boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE sql varchar;
		paramlist varchar;
		doAbund boolean = '0';
		doElem boolean = '0';
		doTaph boolean = '0';
		doDepEnv boolean = '0';
		noTaxa boolean = '0';
		sumGroupId int = NULL;
		poly geography = NULL;
		cteBase varchar;
		cteBaseSelect varchar;
		cteBaseFrom varchar;
		cteBaseWhere varchar;
		cteAges varchar;
		cteAgesSelect varchar;
		cteAgesFrom varchar;
		cteAgesWhere varchar;
		cteDs varchar;
		cteDsSelect varchar;
		cteDsFrom varchar;
		cteDsWhere varchar;

BEGIN
	IF array_length(_depEnvIds,1) > 0 THEN
	  doDepEnv := '1';
	END IF;
	IF array_length(_taxonIds,1) < 1 THEN
	  noTaxa := '1';
	  --some kind of GOTO dataset here--
	END IF;

	IF array_length(_elemTypeIds,1) > 0 THEN
		doElem := '1';
	END IF;

	IF array_length(_taphTypeIds,1) > 0 THEN
		doTaph := '1';
	END IF;

	IF _abundPct IS NOT NULL THEN
		BEGIN
			-- get SumGroupID of the first (or only) taxon id
			 sumGroupId := (SELECT sg.sumgroupid FROM ndb.ecolgroups eg
				JOIN ap.pollensumgroups sg ON eg.ecolgroupid = sg.ecolgroupid
			WHERE	
				eg.taxonid IN (SELECT _taxonIds[1]));
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
			  		v.taxonid IN (array_to_string(_taxonIds,',')';
		        IF doElem = '1' THEN
				  BEGIN
				    cteBaseFrom := cteBaseFrom || '
			  			JOIN ndb.variableelements ve ON v.variableelementid = ve.variableelementid';
			        cteBaseWhere = cteBaseWhere || '
			  			AND ve.elementtypeid IN (array_to_string(_elemTypeIds,','))';
			      END;
				END IF;
			    IF doTaph = '1' THEN
			      BEGIN
			        cteBaseFrom := cteBaseFrom || '
			      		JOIN ndb.summarydatataphonomy ta ON ta.dataid = d.dataid';
			        cteBaseWhere := cteBaseWhere || '
			      		AND ta.taphonomictypeid IN (array_to_string(_taphTypeIds,','))';
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
		  ' AND base.taxonid IN (array_to_string(_taxonIds,',')))';
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
	-- END building ages CTE

	 RAISE NOTICE 'cteAges = %', cteAges;


END;
$function$
