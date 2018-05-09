CREATE OR REPLACE FUNCTION ti.getdatasetpublications(_datasetid int)
RETURNS TABLE(publicationid int, pubtypeid int, year varchar(64), citation text, articletitle text, journal text, volume varchar(16), issue varchar(8),
		pages varchar(24), citationnumber varchar(24), doi varchar(128), booktitle text, numvolumes varchar(8), edition varchar(24), volumetitle text,
		seriestitle text, seriesvolume varchar(16), publisher varchar(255), url text, city varchar(64), state varchar(64), country varchar(64),
		originallanguage varchar(64), notes text)
AS $$
SELECT ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle, 
       ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi, 
       ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle, 
       ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country, 
       ndb.publications.originallanguage, ndb.publications.notes
FROM ndb.datasetpublications INNER JOIN ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE ndb.datasetpublications.datasetid = _datasetid;
$$ LANGUAGE SQL;