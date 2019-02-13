CREATE OR REPLACE FUNCTION ti.gettablerecordcountbymonth(_tablename character varying)
 RETURNS TABLE(year integer, month integer, count integer, runningcount integer)
 LANGUAGE plpgsql
AS $function$

BEGIN
  RETURN QUERY
  EXECUTE format(
  	'select distinct 
	year
	, month
	, count(*)::integer as count
	,(SUM(COUNT(*)) OVER (ORDER BY year, month))::integer AS runningcount	
	from 
	(select 
	Extract(Year From recdatecreated)::integer AS year
	, Extract(Month From recdatecreated)::integer as month from ndb.' || '%s' || ') as _createdates
	group by year, month
	order by year, month', _tablename);
END;

$function$
