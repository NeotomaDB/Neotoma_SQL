CREATE OR REPLACE FUNCTION ti.getdatasetvariables(_datasetid int)
RETURNS TABLE(variableid int, taxoncode varchar(64), taxonname varchar(80), author varchar(128), variableelement varchar(255),
		variableunits varchar(64), variablecontext varchar(64))
AS $$ 
SELECT ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement,
		ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext
FROM ndb.variableelements RIGHT OUTER JOIN
	ndb.samples INNER JOIN
 	ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
 	ndb.variables ON ndb.data.variableid = ndb.variables.variableid INNER JOIN
	ndb.taxa ON ndb.variables.taxonid = ndb.taxa.taxonid LEFT OUTER JOIN
	ndb.variablecontexts ON ndb.variables.variablecontextid = ndb.variablecontexts.variablecontextid LEFT OUTER JOIN
	ndb.variableunits ON ndb.variables.variableunitsid = ndb.variableunits.variableunitsid ON 
	ndb.variableelements.variableelementid = ndb.variables.variableelementid
WHERE ndb.samples.datasetid = _datasetid
GROUP BY ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement,
	ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext
$$ LANGUAGE SQL;