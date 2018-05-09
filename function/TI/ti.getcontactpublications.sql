CREATE OR REPLACE FUNCTION ti.getcontactpublications(_contactid int)
RETURNS TABLE(contactid int, citation text, year varchar(64), articletitle text, journal text, volume varchar(16), issue varchar(8), pages varchar(24),
		citationnumber varchar(24), doi varchar(24), booktitle text, numvolumes varchar(8), edition varchar(24), volumetitle text, seriestitle text, 
       	seriesvolume varchar(16), publisher varchar(255), url text, city varchar(64), state varchar(64), country varchar(64), originallanguage varchar(64))
AS $$
SELECT ndb.publicationauthors.contactid, ndb.publications.citation, ndb.publications.year, ndb.publications.articletitle, ndb.publications.journal, 
       ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi, 
       ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle, 
       ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, 
       ndb.publications.country, ndb.publications.originallanguage
FROM ndb.publicationauthors INNER JOIN
     ndb.publications ON ndb.publicationauthors.publicationid = ndb.publications.publicationid
WHERE ndb.publicationauthors.contactid = _contactid;
$$ LANGUAGE SQL;