CREATE OR REPLACE VIEW ndb.pubtsv AS
  SELECT pu.publicationid,
    setweight(to_tsvector(coalesce(pu.articletitle,'')), 'A')    ||
    setweight(to_tsvector(coalesce(pu.booktitle,'')), 'A')    ||
    setweight(to_tsvector(coalesce(pu.journal,'')), 'B')  ||
    setweight(to_tsvector(coalesce(pu.seriestitle,'')), 'B') ||
    setweight(to_tsvector(coalesce(pu.volumetitle,'')), 'B') ||
    setweight(to_tsvector(coalesce(pu.citation,'')), 'C') AS pubtsv
  FROM ndb.publications AS pu;
