SELECT DISTINCT
SDTables.table_catalog as DatabaseName,
SDTables.table_schema as ParentSchema,
SDTables.table_name as ParentTable,
SDColumns.column_name as ColumnName,
SDColumns.ordinal_position as ColumnOrder,
SDColumns.data_type as DataType,
SDColumns.character_maximum_length as ColumnSize,
SDConstraints.constraint_type as ConstraintType,
SDKeys2.table_schema as ChildSchema,
SDKeys2.table_name as ChildTable,
SDKeys2.column_name as ChildColumn
FROM information_schema.tables SDTables
NATURAL LEFT JOIN information_schema.columns SDColumns
LEFT JOIN
(information_schema.key_column_usage SDKeys
NATURAL JOIN information_schema.table_constraints SDConstraints
NATURAL LEFT JOIN information_schema.referential_constraints SDReference
)
ON SDColumns.table_catalog=SDKeys.table_catalog AND SDColumns.table_schema=SDKeys.table_schema AND SDColumns.table_name=SDKeys.table_name AND SDColumns.column_name=SDKeys.column_name
LEFT JOIN information_schema.key_column_usage SDKeys2
ON SDKeys.position_in_unique_constraint=SDKeys2.ordinal_position AND SDReference.unique_constraint_catalog=SDKeys2.constraint_catalog AND SDReference.unique_constraint_schema=SDKeys2.constraint_schema AND SDReference.unique_constraint_name=SDKeys2.constraint_name
WHERE SDTables.TABLE_TYPE='BASE TABLE' AND SDTables.table_schema NOT IN('information_schema','pg_catalog')
ORDER BY ParentSchema, ParentTable, ColumnOrder;