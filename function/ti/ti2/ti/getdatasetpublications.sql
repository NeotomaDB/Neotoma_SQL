CREATE OR REPLACE FUNCTION ti.getdatasetpublications(_datasetid integer)
 RETURNS TABLE(publicationid integer, pubtypeid integer, year character varying, citation text, articletitle text, journal text, volume character varying, issue character varying, pages character varying, citationnumber character varying, doi character varying, booktitle text, numvolumes character varying, edition character varying, volumetitle text, seriestitle text, seriesvolume character varying, publisher character varying, url text, city character varying, state character varying, country character varying, originallanguage character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle, 
       ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi, 
       ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle, 
       ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country, 
       ndb.publications.originallanguage, ndb.publications.notes
FROM ndb.datasetpublications INNER JOIN ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE ndb.datasetpublications.datasetid = _datasetid;
$function$
