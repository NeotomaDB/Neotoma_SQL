COPY
(SELECT fk_nsp.nspname || '.' || fk_table AS fk_table,
        array_agg(fk_att.attname ORDER BY fk_att.attnum) AS fk_columns,
        tar_nsp.nspname || '.' || target_table AS target_table,
        array_agg(tar_att.attname ORDER BY fk_att.attnum) AS target_columns
 FROM (
   SELECT
            fk.oid AS fk_table_id,
            fk.relnamespace AS fk_schema_id,
            fk.relname AS fk_table,
            unnest(con.conkey) as fk_column_id,

            tar.oid AS target_table_id,
            tar.relnamespace AS target_schema_id,
            tar.relname AS target_table,
            unnest(con.confkey) as target_column_id,

            con.connamespace AS constraint_nsp,
            con.conname AS constraint_name

        FROM pg_constraint con
        JOIN pg_class fk ON con.conrelid = fk.oid
        JOIN pg_class tar ON con.confrelid = tar.oid
        WHERE con.contype = 'f'
    ) sub
    JOIN pg_attribute fk_att ON fk_att.attrelid = fk_table_id AND fk_att.attnum = fk_column_id
    JOIN pg_attribute tar_att ON tar_att.attrelid = target_table_id AND tar_att.attnum = target_column_id
    JOIN pg_namespace fk_nsp ON fk_schema_id = fk_nsp.oid
    JOIN pg_namespace tar_nsp ON target_schema_id = tar_nsp.oid
    GROUP BY 1, 3, sub.constraint_nsp, sub.constraint_name)
    TO '/tmp/selfref.csv' CSV HEADER;
