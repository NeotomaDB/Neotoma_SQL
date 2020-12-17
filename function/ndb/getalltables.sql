CREATE OR REPLACE FUNCTION ndb.getalltables(_schema text)
  RETURNS TABLE(schema text, "table" text,
                "column" text, data_type text,
                "default" text)
  LANGUAGE sql
AS
$function$
  SELECT table_schema, table_name, column_name, data_type, column_default
  FROM   information_schema.columns
  WHERE table_schema = _schema
  ORDER  BY table_name, ordinal_position;
$function$
