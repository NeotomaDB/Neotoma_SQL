# Adding a constraint on `ndb.variables`

## Find Duplicated Records

There are a set of conditions where the `ndb.variables` has multiple `variableid` values for the same combination of `(taxonid, variableelementid, variableunitsid, variablecontextid)`. We need to sort these out first, and then clean it all up so we can add the constraint on the data in the table.

```sql
with minid as (
	SELECT MIN(variableid) AS varid, taxonid, variableelementid, variableunitsid, variablecontextid FROM ndb.variables
	GROUP BY taxonid, variableelementid, variableunitsid, variablecontextid
	HAVING COUNT(variableid) > 1),
vrs as (
	select vr.variableid, mn.varid from ndb.variables as vr
	inner join minid as mn on 
		    ((mn.taxonid = vr.taxonid) or (mn.taxonid is null and vr.taxonid is null)) 
		and ((mn.variableelementid = vr.variableelementid) or (mn.variableelementid is null and vr.variableelementid is NULL))
		and ((mn.variableunitsid = vr.variableunitsid) or (mn.variableunitsid is null and vr.variableunitsid is NULL)) 
		and ((mn.variablecontextid = vr.variablecontextid) or (mn.variablecontextid is null AND vr.variablecontextid is NULL)))
select * from vrs;
```

With the results from this query we can see every `variableid` that is duplicated, and the minimum `variableid` that accomodates the record.

## Update FOREIGN KEY Tables

The `vrs` table then lets us replace the `variableid` values from tables that use `variableid` as a foreign key.

For example, we should be able to:

```sql
with minid as (
	SELECT MIN(variableid) AS varid, taxonid, variableelementid, variableunitsid, variablecontextid FROM ndb.variables
	GROUP BY taxonid, variableelementid, variableunitsid, variablecontextid
	HAVING COUNT(variableid) > 1),
vrs as (
	select vr.variableid, mn.varid from ndb.variables as vr
	inner join minid as mn on 
		    ((mn.taxonid = vr.taxonid) or (mn.taxonid is null and vr.taxonid is null)) 
		and ((mn.variableelementid = vr.variableelementid) or (mn.variableelementid is null and vr.variableelementid is NULL))
		and ((mn.variableunitsid = vr.variableunitsid) or (mn.variableunitsid is null and vr.variableunitsid is NULL)) 
		and ((mn.variablecontextid = vr.variablecontextid) or (mn.variablecontextid is null AND vr.variablecontextid is NULL)))
update ndb.isovariablescaletypes as dt
set variableid = vrs.varid
from vrs
where vrs.variableid = dt.variableid;
```

We can then repeat that for each table with the `variableid` as a foreign key. These tables include:

`ndb.data`; `ndb.datasetvariable`; `ndb.isoinstrumentation`; `ndb.isosrmetadata`; `ndb.isostandards`; `ndb.isovariablescaletypes`

## Delete the Duplicated Records

Once those tables have been updated, we can remove the duplicated variables:

```sql
with minid as (
	SELECT MIN(variableid) AS varid, taxonid, variableelementid, variableunitsid, variablecontextid FROM ndb.variables
	GROUP BY taxonid, variableelementid, variableunitsid, variablecontextid
	HAVING COUNT(variableid) > 1),
vrs as (
	select vr.variableid, mn.varid from ndb.variables as vr
	inner join minid as mn on 
		    ((mn.taxonid = vr.taxonid) or (mn.taxonid is null and vr.taxonid is null)) 
		and ((mn.variableelementid = vr.variableelementid) or (mn.variableelementid is null and vr.variableelementid is NULL))
		and ((mn.variableunitsid = vr.variableunitsid) or (mn.variableunitsid is null and vr.variableunitsid is NULL)) 
		and ((mn.variablecontextid = vr.variablecontextid) or (mn.variablecontextid is null AND vr.variablecontextid is NULL)))
DELETE FROM ndb.variables
WHERE variableid = (SELECT variableid FROM vrs) AND NOT variableid = (SELECT varid FROM vrs)
```

## Add the UNIQUE Constraint

Then we finish by updating the table to enforce a `UNIQUE` constraint on the table:

```sql
ALTER TABLE ndb.variables ADD CONSTRAINT variables_unique UNIQUE (taxonid, variableelementid, variableunitsid, variablecontextid);
```

