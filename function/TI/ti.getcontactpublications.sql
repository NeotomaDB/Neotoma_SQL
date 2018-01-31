CREATE OR REPLACE FUNCTION ti.getcontactpublications(_contactid int) RETURNS SETOF record
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