CREATE OR REPLACE FUNCTION ti.getdatasetpublications(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle, 
       ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi, 
       ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle, 
       ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country, 
       ndb.publications.originallanguage, ndb.publications.notes
FROM ndb.datasetpublications INNER JOIN ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE ndb.datasetpublications.datasetid = _datasetid;
$$ LANGUAGE SQL;