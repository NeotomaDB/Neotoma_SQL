/* Code from here: */
SELECT 'select '
        || trim(trailing ')'
           from replace(pg_get_expr(d.adbin, d.adrelid),
                        'nextval', 'setval'))
        || ', (select max( ' || a.attname || ') from only '
        || nspname || '.' || relname || '));'
  FROM pg_class c
       JOIN pg_namespace n ON n.oid = c.relnamespace
       JOIN pg_attribute a ON a.attrelid = c.oid
       JOIN pg_attrdef d ON d.adrelid = a.attrelid
                          AND d.adnum = a.attnum
                          AND a.atthasdef
WHERE relkind = 'r' and a.attnum > 0
  AND pg_get_expr(d.adbin, d.adrelid) ~ '^nextval';
