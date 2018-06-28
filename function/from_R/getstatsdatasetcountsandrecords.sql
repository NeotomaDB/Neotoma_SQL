CREATE OR REPLACE FUNCTION ti.getstatsdatasetcountsandrecords()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT  top 
100
 percent datasettype, datasetcount, datarecordcount
 FROM @stats
order by datasettype;
$function$