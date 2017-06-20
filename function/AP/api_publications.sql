CREATE OR REPLACE FUNCTION publications (
  PublicationID = null
  , Year = null
  , PubType = null
  , Authors = null
  , Citation = null) 
RETURNS TABLE (PublicationID int, Year int, PubType text, Authors text[], Citation text) AS $pubs$
SELECT * FROM pubs WHERE
pubs.Year = Year,
pubs.PublicationID = PublicationID,

FROM Publications as pubs
   END; LANGUAGE plpgsql;