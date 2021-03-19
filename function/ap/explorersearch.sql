CREATE OR REPLACE FUNCTION ap.explorersearch(_taxonids integer[] DEFAULT NULL::integer[],
                                             _elemtypeids integer[] DEFAULT NULL::integer[],
                                             _taphtypeids integer[] DEFAULT NULL::integer[],
                                             _depenvids integer[] DEFAULT NULL::integer[],
                                             _abundpct integer DEFAULT NULL::integer,
                                             _datasettypeid integer DEFAULT NULL::integer,
                                             _keywordid integer DEFAULT NULL::integer,
                                             _coords character varying DEFAULT NULL::character varying,
                                             _gpid integer DEFAULT NULL::integer,
                                             _altmin integer DEFAULT NULL::integer,
                                             _altmax integer DEFAULT NULL::integer,
                                             _coltypeid integer DEFAULT NULL::integer,
                                             _dbid integer DEFAULT NULL::integer,
                                             _sitename character varying DEFAULT NULL::character varying,
                                             _contactid integer DEFAULT NULL::integer,
                                             _ageold integer DEFAULT NULL::integer,
                                             _ageyoung integer DEFAULT NULL::integer,
                                             _agedocontain boolean DEFAULT true,
                                             _agedirectdate boolean DEFAULT false,
                                             _subdate date DEFAULT NULL::date,
                                             _debug boolean DEFAULT false)
 RETURNS TABLE(datasetid integer, datasettype character varying, databasename character varying, minage integer, maxage integer, ageyoungest integer, ageoldest integer, siteid integer, sitename character varying, sitedescription text, notes text, collunithandle character varying, collunitname character varying, latitudenorth double precision, latitudesouth double precision, longitudeeast double precision, longitudewest double precision)
 LANGUAGE plpgsql
AS $function$

DECLARE thesql varchar;
        paramlist varchar;
        doAbund boolean := false;
        doElem boolean := false;
        doTaph boolean := false;
        doDepEnv boolean := false;
        noTaxa boolean := false;
        sumGroupId int := NULL;
        poly geography := NULL;
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
    debugLenTaxonids integer;
    debugIsPoly boolean;
BEGIN
    IF array_length(_depenvids,1) > 0 THEN
      doDepEnv := true;
    END IF;


    debugLenTaxonids := array_length(_taxonids,1);

    RAISE NOTICE '_taxonids length is %', debugLenTaxonids;

    IF array_length(_taxonids,1) < 1 OR _taxonids is null THEN
      noTaxa := true;
      RAISE NOTICE 'noTaxa is %', noTaxa;

    END IF;


    IF ( (array_length(_elemtypeids,1) > 0 OR _elemtypeids IS NOT NULL) AND noTaxa = false ) THEN
        doElem := true;
    RAISE NOTICE 'doElem is %', doElem;
    END IF;

    IF ( (array_length(_taphtypeids,1) > 0 OR _taphtypeids IS NOT NULL )AND noTaxa = false ) THEN
        doTaph := true;
    RAISE NOTICE 'doTaph is %', doTaph;
    END IF;

    IF ( _abundpct IS NOT NULL AND noTaxa = false ) THEN
    RAISE NOTICE '_abundpct is % and noTaxa is %', doTaph, noTaxa;
        BEGIN
            -- get SumGroupID of the first (or only) taxon id
            sumGroupId := (
                SELECT  sg.sumgroupid
                FROM    ndb.ecolgroups eg
                        JOIN ap.pollensumgroups sg ON eg.ecolgroupid = sg.ecolgroupid
                WHERE
                    eg.taxonid IN (_taxonids[1])
                );
            IF sumGroupId > 0 THEN
                doAbund := true;
            END IF;
        END;
    END IF;

    RAISE NOTICE '_agedirectdate is % and noTaxa is %', _agedirectdate, noTaxa;
    -- START building standard base CTE, skip if noTaxa = true
    IF ( (_agedirectdate = false OR _agedirectdate IS NULL) AND noTaxa = false ) THEN
        BEGIN
            cteBase := 'WITH base AS (';
            cteBaseSelect := '
                SELECT s.sampleid, s.datasetid ';
            cteBaseFrom := '
                FROM ndb.samples s
                JOIN ndb.data d ON s.sampleid = d.sampleid
                JOIN ndb.variables v ON d.variableid = v.variableid ';
            cteBaseWhere := '
                WHERE';

            IF doAbund = true THEN
              BEGIN
                cteBaseSelect := cteBaseSelect || ',
                    v.taxonid,
                    (CASE WHEN (SUM(d.value) OVER(PARTITION BY s.sampleid)) IS NOT NULL AND 
					          (SUM(d.value) OVER(PARTITION BY s.sampleid)) <>0 THEN
						            (CAST(d.value / SUM(d.value) OVER (PARTITION BY s.sampleid) * 100 AS DECIMAL(5,2))) 
					          ELSE
						            NULL END
   					        ) AS abundance';
                cteBaseFrom := cteBaseFrom || '
                    JOIN ndb.taxa t ON v.taxonid = t.taxonid
                    JOIN ndb.ecolgroups e ON t.taxonid = e.taxonid
                    JOIN ap.pollensumgroups sg ON e.ecolgroupid = sg.ecolgroupid';
                cteBaseWhere := cteBaseWhere || '
                    sg.sumgroupid = ' || sumGroupId;
              END;
            ELSE
              BEGIN
                --cteBaseWhere := cteBaseWhere || ' 1 = 1';
                cteBaseWhere := cteBaseWhere || '
                    v.taxonid IN (' || array_to_string( _taxonids ,',') || ')';
                IF doElem = true THEN
                  BEGIN
                    cteBaseFrom := cteBaseFrom || '
                        JOIN ndb.variableelements ve ON v.variableelementid = ve.variableelementid';
                    cteBaseWhere = cteBaseWhere || '
                        AND ve.elementtypeid IN (array_to_string(_elemTypeIds,'',''))';
                  END;
                END IF;
                IF doTaph = true THEN
                  BEGIN
                    cteBaseFrom := cteBaseFrom || '
                        JOIN ndb.summarydatataphonomy ta ON ta.dataid = d.dataid';
                    cteBaseWhere := cteBaseWhere || '
                        AND ta.taphonomictypeid IN (array_to_string(_taphTypeIds,'',''))';
                  END;
                END IF;
              END;
            END IF;

            IF _keywordid IS NOT NULL THEN
              BEGIN
                cteBaseFrom := cteBaseFrom || '
                    JOIN ndb.samplekeywords k on s.sampleid = k.sampleid';
                cteBaseWhere := cteBaseWhere || '
                    AND k.keywordid = _keywordid';
              END;
            END IF;

            cteBase := cteBase || cteBaseSelect || cteBaseFrom || cteBaseWhere || '
                )';
        END;
    END IF;
    -- END building base CTE

    -- START building standard ages CTE
    IF ( (_agedirectdate = false OR _agedirectdate IS NULL) AND noTaxa = false ) THEN
      BEGIN
        cteAges := ',
            ages AS (';
        cteAgesSelect := '
            SELECT
              base.datasetid,
              MIN(sa.age) AS minage,
              MAX(sa.age) AS maxage,
              MIN(sa.ageyounger) AS ageyoungest,
              MAX(sa.ageolder) AS ageoldest';
        cteAgesFrom := '
            FROM
              base';
        cteAgesWhere := '
            WHERE
              1=1';

        IF doAbund THEN
          cteAgesWhere := cteAgesWhere || '
              AND base.abundance > ' || _abundpct ||
              ' AND base.taxonid IN (' || array_to_string( _taxonids ,',') || ')';
        END IF;

        IF NOT (_ageold IS NULL AND _ageyoung IS NULL  AND noTaxa = false) THEN
            BEGIN
                cteAgesFrom := cteAgesFrom || '
                    JOIN da.vsampagesstd sa ON base.sampleid = sa.sampleid';

                IF _ageold IS NULL THEN
                  _ageold := 10000000;
                END IF;

                IF _ageyoung IS NULL THEN
                  _ageyoung := -250;
                END IF;

                IF _agedocontain = true THEN
                  cteAgesWhere := cteAgesWhere || '
                      AND (
                        (' || _ageyoung || '<= sa.age AND sa.age <= ' || _ageold || ') OR
                        (' || _ageyoung || '<= sa.ageyounger AND sa.ageolder <= ' || _ageold || ')
                      )';
                ELSE
                  cteAgesWhere := cteAgesWhere || '
                      AND (
                        (' || _ageyoung || ' <= sa.age AND sa.age <= ' || _ageold || ') OR
                        NOT (sa.ageolder < ' || _ageyoung || ' OR ' || _ageold || '< sa.ageyounger)
                      )';
                END IF;
            END;
        ELSE
            cteAgesFrom := cteAgesFrom || ' LEFT JOIN da.vsampagesstd sa ON base.sampleid = sa.sampleid';
        END IF;

        cteAges := cteAges || cteAgesSelect || cteAgesFrom || cteAgesWhere || ' GROUP BY base.datasetid)';
      END;
    END IF;
    -- END building ages CTE

    -- START alternative combined base/ages CTE for directly dated specimens
    IF ( _agedirectdate = true and noTaxa = false ) THEN
      BEGIN
        cteBase := '';

        IF _ageold IS NULL THEN
            _ageold := 10000000;
        END IF;

        IF _ageyoung IS NULL THEN
            _ageyoung := -250;
        END IF;

        cteAges := '
            WITH ages AS (
                SELECT
                  s.datasetid,
                  MIN(c.calage) AS minage,
                  MAX(c.calage) AS maxage,
                  MIN(c.calageyounger) AS ageyoungest,
                  MAX(c.calageolder) AS ageoldest
                FROM
                  ndb.samples s
                  JOIN ndb.specimendates sd ON s.sampleid = sd.sampleid
                  JOIN ndb.specimendatescal c ON sd.specimendateid = c.specimendateid
                WHERE
                  sd.taxonid IN (' || array_to_string( _taxonids ,',') || ')
        ';

        IF doElem = true THEN
            cteAges := cteAges || '
                AND sd.elementtypeid IN (array_to_string(' || _elemtypeids || ','',''))';
        END IF;

        IF _agedocontain = false THEN
            cteAges := cteAges || '
            AND NOT (c.calageolder < ' || _ageyoung || ' OR ' || _ageold || ' < c.calageyounger)';
        ELSE
            cteAges := cteAges || '
            AND NOT (' || _ageyoung || ' <= c.calageyounger AND c.calageolder <= ' || _ageold || ' )';
        END IF;

        cteAges := cteAges || '
            GROUP BY s.datasetid
            )';
        END;
    END IF;
    -- END alternative ages CTE for directly dated specimens

    -- START building ds (dataset) CTE


    IF noTaxa = true THEN
      BEGIN
        cteBase := '';
        cteAges := '';
        cteDs := '       WITH ';
      END;
    ELSE
      cteDs := ',
      ';
    END IF;

    cteDs := cteDs || 'ds AS (';

    cteDsSelect := '
        SELECT
          ds.datasetid,
          ds.datasettypeid,
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
          ages.minage ';

    cteDsFrom := '
          join ndb.collectionunits cu on ds.collectionunitid = cu.collectionunitid
          join ndb.sites s on cu.siteid = s.siteid';

    IF noTaxa = true THEN
      BEGIN
        cteBase := '';
        cteAges := '';

        cteDsFrom := '
            FROM
              ndb.datasets ds' || cteDsFrom ;

        IF NOT (_ageold IS NULL AND _ageyoung IS NULL) THEN
          cteDsFrom := cteDsFrom || '
            JOIN da.vbestdatasetages ages ON ds.datasetid = ages.datasetid';
        ELSE
          cteDsFrom := cteDsFrom || '
            LEFT JOIN da.vbestdatasetages ages ON ds.datasetid = ages.datasetid ';
        END IF;
      END;
    ELSE
      BEGIN
        cteDsFrom := '
            FROM
              ages
              JOIN ndb.datasets ds ON ages.datasetid = ds.datasetid ' || cteDsFrom;
      END;
    END IF;

    cteDsWhere := '
        WHERE
          1=1 ';

    IF _sitename IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND s.sitename ILIKE ''%' || _sitename || '%''' ;
    END IF;

    IF _subdate IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND ds.recdatecreated >= ''%' || _subdate || '%''';
    END IF;

    IF _gpid IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND EXISTS (SELECT *
                      FROM   ndb.sitegeopolitical gp
                      WHERE  gp.siteid = s.siteid
                      AND    gp.geopoliticalid = ' || _gpid || ' )';
    END IF;

    IF doDepEnv = true THEN
      cteDsWhere := cteDsWhere || '
          AND cu.depenvtid IN (array_to_string(' || depEnvIds || ','',''))';
    END IF;

    IF _coltypeid IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND cu.CollTypeID = ' || _coltypeid;
    END IF;

    IF _altmin IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND s.Altitude >= ' || _altmin;
    END IF;

    IF _altmax IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND s.Altitude <= ' || _altmax;
    END IF;

    IF _dbid IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND EXISTS (SELECT *
                      FROM   ndb.datasetdatabases db
                      WHERE  db.datasetid = ds.datasetid
                      AND    db.databaseid = ' || _dbid || ' )';
    END IF;

    IF _contactid IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND EXISTS (SELECT *
                      FROM   ap.datasetpisauthors p
                      WHERE  p.datasetid = ds.datasetid
                      AND    p.contactid = ' || _contactid || ' )';
    END IF;

    IF _keywordid IS NOT NULL AND noTaxa = true THEN
      cteDsWhere := cteDsWhere || '
          AND EXISTS (SELECT k.datasetid, k.keywordid
                      FROM   ap.datasetkeywords k
                      WHERE  k.datasetid = ds.datasetid
                      AND    k.keywordid = ' || _keywordid || ' )';
    END IF;

    IF _datasettypeid IS NOT NULL THEN
      cteDsWhere := cteDsWhere || '
          AND ds.DatasetTypeID = ' || _datasettypeid;
    END IF;

    IF noTaxa = true AND NOT (_ageold IS NULL AND _ageyoung IS NULL) THEN
      BEGIN
        IF _ageold IS NULL THEN
          _ageold := 10000000;
        END IF;
        IF _ageyoung IS NULL THEN
          _ageyoung := -250;
        END IF;
        IF _agedocontain = true THEN
          cteDsWhere := cteDsWhere || '
              AND (
                ( ' || _ageyoung || ' <= ages.ageyoungest AND ' || _ageold || ' >= ages.ageoldest) OR
                ( ' || _ageyoung || ' <= ages.minage AND ' || _ageold || ' >= ages.maxage)
              )';
        ELSE
            cteDsWhere := cteDsWhere || '
              AND (
                (' || _ageyoung || ' <= ages.ageyoungest AND ages.ageoldest <= ' || _ageold || ' ) OR
            	  NOT (ages.maxage < ' || _ageyoung || ' OR ' || _ageold || ' < ages.minage)
              )';
        END IF;
      END;
    END IF;

--todo review postgis syntax ---

    RAISE NOTICE '_coords value %', _coords;
    IF _coords IS NOT NULL THEN
      BEGIN
        poly := ST_GeogFromText(_coords)::geography;

        cteDsWhere := format( '%s' || '
          AND ST_Intersects(s.geog,' || '%L' || ') = true', cteDsWhere, poly);
      END;
    END IF;

    cteDs := cteDs || cteDsSelect || cteDsFrom || cteDsWhere || '
      )';
    -- END building ds (dataset) CTE
    --call CTEs


    thesql := format(
        '%s' || '%s' || '%s' ||
          ' SELECT
            ds.datasetid,
            dt.datasettype,
            cdb.databasename,
            ds.minage::integer,
            ds.maxage::integer,
            ds.ageyoungest::integer,
            ds.ageoldest::integer,
            ds.siteid,
            ds.sitename,
            ds.sitedescription,
            ds.notes,
            ds.handle as collunithandle,
            ds.collunitname,
            ds.latitudenorth,
            ds.latitudesouth,
            ds.longitudeeast,
            ds.longitudewest
          from
            ds
            join ndb.datasettypes dt on ds.datasettypeid = dt.datasettypeid
            left join (ndb.datasetdatabases dd join ndb.constituentdatabases cdb on dd.databaseid = cdb.databaseid) on ds.datasetid = dd.datasetid
        '
        , cteBase, cteAges, cteDs);

RAISE NOTICE '%', thesql;

    RETURN QUERY EXECUTE thesql;



END;

$function$
