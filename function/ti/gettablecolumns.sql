CREATE OR REPLACE FUNCTION ti.gettablecolumns(_tablename character varying)
 RETURNS TABLE(columnname character varying, datatype character varying, maxlength integer)
 LANGUAGE plpgsql
AS $function$
	DECLARE _schema varchar; 
			_table varchar;
	BEGIN
	  _schema = split_part(_tablename, '.', 1);
	  _table = split_part(_tablename, '.', 2);
	  
	  IF _schema is not null AND _table is not null then
		RETURN QUERY
			select column_name::varchar as columnname, data_type::varchar as datatype, character_maximum_length::integer as maxlength 
			from information_schema.columns
			where table_schema = _schema
			and table_name = _table;
		END IF;
	END;
$function$
