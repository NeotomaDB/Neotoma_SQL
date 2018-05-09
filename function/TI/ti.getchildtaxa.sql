CREATE OR REPLACE FUNCTION ti.getchildtaxa(taxonname varchar(80))
RETURNS TABLE(taxonid int, taxonname varchar(80), author varchar(128), highertaxonid int, level int)
AS $$
WITH  RECURSIVE taxacte 
AS 
(
	SELECT taxonid AS basetaxonid, taxonid, taxonname, author, highertaxonid, 0 AS level
    FROM ndb.taxa
    WHERE taxonname = $1
      
    UNION ALL
    
    SELECT parent.basetaxonid, child.taxonid, child.taxonname, child.author, child.highertaxonid, parent.level +1 AS level
    FROM taxacte AS parent
      INNER JOIN ndb.taxa AS child
        ON parent.taxonid = child.highertaxonid
)
 SELECT taxonid, taxonname, author, highertaxonid, level 
 FROM taxacte
 ORDER BY level
$$ LANGUAGE SQL;