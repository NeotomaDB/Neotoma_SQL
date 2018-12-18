CREATE OR REPLACE FUNCTION ts.updateissurfacesample(
  _datasetid INTEGER,
  _issamp boolean)
RETURNS void
LANGUAGE plpgsql
AS $$

  BEGIN
    IF _issamp = True AND
       (SELECT COUNT(*) = 0
        FROM ndb.samples AS smp
        INNER JOIN ndb.analysisunits AS au ON smp.analysisunitid = au.analysisunitid
        WHERE (au.depth is null) AND (smp.datasetid = _datasetid)) AND
       (SELECT COUNT(*)
        FROM ndb.samples AS smp
        JOIN ndb.analysisunits AS au ON smp.analysisunitid = au.analysisunitid
		    JOIN ndb.samplekeywords AS sk ON sk.sampleid = smp.sampleid
        WHERE (smp.datasetid = _datasetid AND sk.keywordid = 1)) THEN

        WITH mindepth AS (
          SELECT MIN(au.depth) AS mind
                      FROM ndb.samples AS smp
                      JOIN ndb.analysisunits AS au ON smp.analysisunitid = au.analysisunitid
                      WHERE (smp.datasetid = _datasetid)
        ),
        sampleid AS (
          SELECT smp.sampleid AS top
                      FROM ndb.samples AS smp
                      JOIN ndb.analysisunits AS au ON smp.analysisunitid = au.analysisunitid
                      WHERE (smp.datasetid = _datasetid) AND
                      au.depth = (SELECT mind FROM mindepth)
        )
        INSERT INTO ndb.samplekeywords(sampleid, keywordid)
              VALUES      ((SELECT top FROM sampleid), 1);

    ELSIF _issamp = False THEN
      WITH smpid AS (
    		SELECT sampleid
    		FROM ndb.samples AS smp
    		WHERE smp.datasetid = _datasetid
  		)
	    DELETE
      FROM ndb.samplekeywords AS sk
      WHERE (sk.sampleid IN (SELECT sampleid FROM smpid) AND (sk.keywordid = 1));
    END IF;
  END
$$
