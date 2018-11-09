CREATE OR REPLACE FUNCTION ts.insertaggregatesampleages(_aggregatedatasetid integer, _aggregatechronid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

	DECLARE
		_nrows int;
		_currentid int = 0;
		_sampleageid int;
		_count int;
	BEGIN
		CREATE TEMPORARY TABLE _sampleageids (
			id SERIAL,
  			sampleageid int
		);

		
		INSERT INTO _sampleageids (sampleageid)
		SELECT   ndb.sampleages.sampleageid
		FROM     ndb.aggregatesamples INNER JOIN
		            ndb.sampleages ON ndb.aggregatesamples.sampleid = ndb.sampleages.sampleid
		WHERE   (ndb.aggregatesamples.aggregatedatasetid = _aggregatedatasetid);
	
		SELECT count(*)
		FROM _sampleageids
		INTO _nrows;

		
		WHILE _currentid < _nrows LOOP
			_currentid := _currentid + 1;
			_sampleageid := (SELECT sampleageid FROM _sampleageids WHERE id = _currentid);
			SELECT COUNT(*) FROM ndb.aggregatesampleages
                  WHERE (sampleageid = _sampleageid) AND 
                  (aggregatedatasetid = _aggregatedatasetid) AND 
                  (aggregatechronid = _aggregatechronid)
            INTO _count;
			
			IF _count = 0 THEN
			    INSERT INTO ndb.aggregatesampleages (aggregatedatasetid, aggregatechronid, sampleageid)
		        VALUES (_aggregatedatasetid, _aggregatechronid, _sampleageid);  
		    END IF;

		END LOOP;

		DROP TABLE _sampleageids;
		
	END;


	$function$
