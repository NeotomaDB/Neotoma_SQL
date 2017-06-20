--
-- STORED PROCEDURE
--     Delete_SearchPeople
--
-- DESCRIPTION
--     Queries the Publications table and returns a table object with the key
--     publication data.
--
-- PARAMETERS
--     @contactid
--         * @contactid is the .
--
-- RETURN VALUE
--         * All sites associated with an individual.
--
-- PROGRAMMING NOTES
--     This is a straightforward wrapper for the Publications, and mostly just a container
--     for the eventual stored procedure.
--
-- CHANGE HISTORY
--     20 May 2017 - Simon Goring
--        * Started the function.

CREATE OR REPLACE FUNCTION "AP"."Delete_SearchPeople"(contactid int)

SELECT NDB.Sites.SiteID, NDB.Datasets.DatasetID, NDB.DatasetTypes.DatasetType, 
       NDB.CollectionUnits.Handle as 'CollUnitHandle', NDB.CollectionUnits.CollUnitName, 
       NDB.ConstituentDatabases.DatabaseName, NDB.Sites.SiteDescription, NDB.Sites.SiteName, 
       NDB.Sites.LongitudeEast, NDB.Sites.LatitudeNorth, NDB.Sites.LongitudeWest, 
       NDB.Sites.LatitudeSouth, NULL AS MinAge, NULL AS MaxAge, ch.AgeBoundYounger AS AgeYoungest, 
       ch.AgeBoundOlder AS AgeOldest
FROM   NDB.DatasetPIs INNER JOIN
       NDB.Datasets ON NDB.DatasetPIs.DatasetID = NDB.Datasets.DatasetID INNER JOIN
	   NDB.DatasetDatabases on NDB.DatasetDatabases.DatasetID = NDB.Datasets.DatasetID INNER JOIN
	   NDB.ConstituentDatabases ON NDB.ConstituentDatabases.DatabaseID = NDB.DatasetDatabases.DatabaseID INNER JOIN
	   NDB.DatasetTypes on NDB.DatasetTypes.DatasetTypeID =  NDB.Datasets.DatasetTypeID INNER JOIN
       NDB.CollectionUnits ON NDB.Datasets.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID INNER JOIN
       NDB.Sites ON NDB.CollectionUnits.SiteID = NDB.Sites.SiteID INNER JOIN
	   NDB.Chronologies as ch on ch.CollectionUnitID = NDB.CollectionUnits.CollectionUnitID

 where NDB.DatasetPIs.contactId = $1
 ORDER By SiteId;
