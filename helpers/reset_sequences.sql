SELECT 'select '
        || trim(trailing ')'
           from replace(pg_get_expr(d.adbin, d.adrelid),
                        'nextval', 'setval'))
        || ', (select max( ' || a.attname || ') from only '
        || nspname || '.' || relname || '));'
  FROM pg_class c
       JOIN pg_namespace n on n.oid = c.relnamespace
       JOIN pg_attribute a on a.attrelid = c.oid
       JOIN pg_attrdef d on d.adrelid = a.attrelid
                          and d.adnum = a.attnum
                          and a.atthasdef
 WHERE relkind = 'r' and a.attnum > 0
       and pg_get_expr(d.adbin, d.adrelid) ~ '^nextval';
