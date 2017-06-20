--
-- STORED PROCEDURE
--     getpublication
--
-- DESCRIPTION
--     Queries the Publications table and returns a table object with the key
--     publication data.
--
-- PARAMETERS
--     @pubid
--         * @pubid is the unique identifier for publications and is associated with
--           the PublicationID.
--
-- RETURN VALUE
--         * A table with the appropriate column headings associated with a publication.
--
-- PROGRAMMING NOTES
--     This is a straightforward wrapper for the Publications, and mostly just a container
--     for the eventual stored procedure.
--
-- CHANGE HISTORY
--     20 May 2017 - Simon Goring
--        * Started the function.

CREATE OR REPLACE FUNCTION "getpublication_id"(pubid integer)
RETURNS TABLE("ArticleTitle" text, "RecDateCreated" text) AS $$
BEGIN
  SELECT "PublicationID", "Year", "PubType", 
         "ArticleTitle", "RecDateCreated",
         "Citation"	 FROM "Publications" WHERE "PublicationID" = $1;
END
$$ LANGUAGE SQL
  COST 100
  ROWS 1;
