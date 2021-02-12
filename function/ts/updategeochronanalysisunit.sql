CREATE OR REPLACE FUNCTION ts.updategeochronanalysisunit(_geochronid integer,
     _analysisunitid integer,
     _depth double precision DEFAULT NULL::double precision,
     _thickness double precision DEFAULT NULL::double precision,
     _analysisunitname CHARACTER varying DEFAULT NULL::CHARACTER varying) RETURNS void LANGUAGE PLPGSQL AS $function$

DECLARE
  _collunitid integer[] := (SELECT au.collectionunitid
    FROM ndb.analysisunits AS au
    WHERE (au.analysisunitid = _analysisunitid));
  _naus bigint := (SELECT COUNT(*)
    FROM ndb.analysisunits AS au
    WHERE ((_collunitid IS NULL) OR (au.collectionunitid = _collunitid))
      AND (au.analysisunitid <> _analysisunitid)
      AND ((_analysisunitname IS NULL) OR (analysisunitname = _analysisunitname))
      AND ((_depth IS NULL) OR (depth = _depth))
      AND ((_thickness IS NULL) OR (thickness = _thickness))
    GROUP BY au.collectionunitid,
             au.analysisunitid,
             au.analysisunitname,
             au.depth,
             au.thickness);
  _nau integer[] := (SELECT au.analysisunitid
    FROM ndb.analysisunits AS au
    WHERE ((_collunitid IS NULL) OR (au.collectionunitid = _collunitid))
     AND (au.analysisunitid <> _analysisunitid)
     AND ((_analysisunitname IS NULL) OR (analysisunitname = _analysisunitname))
     AND ((_depth IS NULL) OR (depth = _depth))
     AND ((_thickness IS NULL) OR (thickness = _thickness)));
  _geochronsampleid integer := (SELECT gc.sampleid
    FROM ndb.geochronology AS gc
    WHERE gc.geochronid = _geochronid);

/*
This procedure updates the depth, thickness, and name of the analysis
unit for a geochronologic measurement. If no other samples are assigned
to the analysis unit, then the analysis unit is simply updated.
If other samples are assigned to the analysis unit then either
  1 - the geochron sample is reassigned to another analysis unit with
      the same depth, thickness, and name from the same Collection Unit,
  - or -
  2 - the sample is reassigned to a new analysis unit. The return value
      is the AnalysisUnitID to which the sample is assigned after the
      update.
*/

  BEGIN
    IF _sampleid <> _geochronsampleid THEN
      RAISE EXCEPTION 'The geochron sample ID does not match the sampleid for the Geochron Analysis Unit';
    END IF;

  /* If the analysis unit only has one sample it's pretty straightforward: */

    IF (SELECT COUNT(*)
      FROM ndb.samples AS smp
      GROUP BY smp.analysisunitid
      HAVING (smp.analysisunitid = _analysisunitid)) = 1
    THEN
      UPDATE ndb.analysisunits AS au
        SET au.depth = _depth,
            au.thickness = _thickness,
            au.analysisunitname = _analysisunitname
        WHERE au.analysisunitid = _analysisunitid;
    ELSE
    /* If we're dealing with multiple sample units */
    /* First we need to know how many analysis units match the ids: */

    END IF;

    IF (_nau IS NOT NULL) THEN
      UPDATE ndb.samples AS smp
        SET smp.analysisunitid = _nau
        WHERE (smp.sampleid = _geochronsampleid);
    ELSE
     -- assign geochron sample to new existing analysis unit
      INSERT INTO ndb.analysisunits(collectionunitid,
          analysisunitname,
          depth,
          thickness,
          mixed)
        VALUES (_collunitid, _analysisunitname, _depth, _thickness, 0)
        RETURNING id;
      UPDATE ndb.samples AS smp
        SET smp.analysisunitid = LASTVAL()
        WHERE (smp.sampleid = _geochronsampleid);
    END IF;
  END;

$function$
