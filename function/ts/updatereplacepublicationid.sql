CREATE OR REPLACE FUNCTION updatereplacepublicationid(_keeppubid integer, _deposepubid integer)
RETURNS TABLE(id integer,
              result character varying)
LANGUAGE plpgsql
AS $function$
  DECLARE
    rec RECORD;
  BEGIN
    CREATE TEMP TABLE resulting AS (
      SELECT c.conrelid::regclass::varchar AS tbl,
        NULL::varchar AS updated
          FROM pg_catalog.pg_attribute  AS a1
          JOIN pg_catalog.pg_constraint AS c  ON c.confrelid = a1.attrelid
                          AND c.confkey   = ARRAY[a1.attnum]
          JOIN pg_catalog.pg_attribute  AS a2 ON a2.attrelid = c.conrelid
                          AND a2.attnum   = c.conkey[1]
        WHERE quote_ident(a2.attname) = 'publicationid'
        AND    c.contype   = 'f');

    FOR rec IN
        SELECT
          c.conrelid::regclass AS tbl,
          quote_ident(a2.attname) AS col
            FROM pg_catalog.pg_attribute  AS a1
            JOIN pg_catalog.pg_constraint AS c  ON c.confrelid = a1.attrelid
                            AND c.confkey   = ARRAY[a1.attnum]
            JOIN pg_catalog.pg_attribute  AS a2 ON a2.attrelid = c.conrelid
                            AND a2.attnum   = c.conkey[1]
          WHERE quote_ident(a2.attname) = 'publicationid'
          AND    c.contype   = 'f'
      LOOP
        EXECUTE format('
          UPDATE resulting
          SET    updated = (SELECT ''Replaced ''|| COUNT(*) || '' to %1$s'' AS result FROM %1$s WHERE %2$s = %4$s)
          WHERE  tbl::varchar = %3$s;'
        ,rec.tbl, rec.col, quote_literal(rec.tbl), _deposepubid);
        EXECUTE format('
          UPDATE %1$s
          SET    %2$s = %3$s
          WHERE  %2$s = %4$s;'
        ,rec.tbl, rec.col, _keeppubid, _deposepubid);
      END LOOP;
      RETURN QUERY
      SELECT NULL::int AS id, updated AS result
      FROM resulting;
  END;
$function$
