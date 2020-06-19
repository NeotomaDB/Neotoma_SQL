CREATE OR REPLACE FUNCTION ts.combinecontacts(_keepcontactid integer,
                                              _contactidlist character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  DECLARE
    rec RECORD;
	BEGIN
    FOR rec IN
    	SELECT
        c.conrelid::regclass AS tbl,
        quote_ident(a2.attname) AS col
    		  FROM pg_catalog.pg_attribute  AS a1
    		  JOIN pg_catalog.pg_constraint AS c  ON c.confrelid = a1.attrelid
    											AND c.confkey   = ARRAY[a1.attnum]
    		  JOIN pg_catalog.pg_attribute  AS a2 ON a2.attrelid = c.conrelid
    											AND a2.attnum   = c.conkey[1]
    		WHERE quote_ident(a2.attname) = 'contactid'
    		AND    c.contype   = 'f'
    	LOOP
          EXECUTE format('
            UPDATE %1$s
            SET    %2$s = _keepcontactid
            WHERE  %2$s IN (SELECT UNNEST(STRING_TO_ARRAY(_contactidlist,'$')))::int'
           ,rec.tbl, rec.col)
        USING _keepcontactid, (SELECT UNNEST(STRING_TO_ARRAY(_contactidlist, '$')))::int;
      END LOOP;

    EXECUTE format('DELETE FROM %s WHERE %s IN _keepcontactid', _tbl, _col)
      USING (SELECT UNNEST(STRING_TO_ARRAY(_contactidlist,'$')))::int;
  END;
$function$
