CREATE OR REPLACE FUNCTION ti.getdatasettoptaxa(
  _datasetid int,
  _topx int,
  _grouptaxa CHARACTER VARYING DEFAULT NULL,
  _alwaysshowtaxa CHARACTER VARYING[] DEFAULT NULL)
RETURNS TABLE (id integer,
               taxonname character varying,
               ecologicalgroupid CHAR(4))
LANGUAGE sql
AS
$function$
WITH wholesum AS (
  SELECT tx.taxonid,
	       tx.taxonname,
         ec.ecolgroupid,
	       row_number() OVER (ORDER BY SUM(dt.value) DESC) AS index
  FROM          ndb.samples AS sm
  INNER JOIN       ndb.data AS dt  ON sm.sampleid = dt.sampleid
  INNER JOIN  ndb.variables AS var ON dt.variableid = var.variableid
  INNER JOIN       ndb.taxa AS tx  ON var.taxonid = tx.taxonid
  INNER JOIN ndb.ecolgroups AS ec  ON tx.taxonid = ec.taxonid
  WHERE var.variableelementid = ANY('{141,166}')
    AND          sm.datasetid = _datasetid
  GROUP BY ec.ecolsetid,
           ec.ecolgroupid,
           tx.taxonname,
  		     tx.taxonid,
           var.variableunitsid
  ORDER BY SUM(dt.value) DESC)
  SELECT taxonid AS id,
         taxonname AS taxon,
         ecolgroupid AS ecologicalgroupid
  FROM wholesum
  WHERE index <= _topx
    OR taxonname = ANY(_alwaysshowtaxa)
$function$
