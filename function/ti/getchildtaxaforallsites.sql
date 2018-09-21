CREATE OR REPLACE FUNCTION ti.getchildtaxaforallsites(_taxonname character varying)
 RETURNS TABLE(taxonid integer, taxonname character varying, sitename character varying)
 LANGUAGE sql
AS $function$
WITH RECURSIVE taxacte
AS
(
  SELECT taxonid AS basetaxonid, taxonid, taxonname, author, highertaxonid, 0 AS level
  FROM ndb.taxa
  WHERE taxonname = _taxonname

  UNION ALL

  SELECT parent.basetaxonid, child.taxonid, child.taxonname, child.author, child.highertaxonid, parent.level +1 AS level
  FROM taxacte AS parent
    INNER JOIN ndb.taxa AS child
      ON parent.taxonid = child.highertaxonid
)

SELECT     taxacte.taxonid, taxacte.taxonname, ndb.sites.sitename
FROM         taxacte INNER JOIN
                      ndb.variables ON taxacte.taxonid = ndb.variables.taxonid INNER JOIN
                      ndb.data ON ndb.variables.variableid = ndb.data.variableid INNER JOIN
                      ndb.samples ON ndb.data.sampleid = ndb.samples.sampleid INNER JOIN
                      ndb.datasets ON ndb.samples.datasetid = ndb.datasets.datasetid INNER JOIN
                      ndb.collectionunits ON ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
                      ndb.sites ON ndb.collectionunits.siteid = ndb.sites.siteid
GROUP BY taxacte.taxonid, taxacte.taxonname, ndb.sites.sitename;
$function$
