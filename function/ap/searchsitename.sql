CREATE OR REPLACE FUNCTION ap.searchsitename(_sitename character varying)
 RETURNS TABLE(siteid integer, geog geography, datasetid integer, datasettype character varying, collunithandle character varying, collunitname character varying, databasename character varying, sitename character varying, sitedescription text, longitudeeast double precision, latitudenorth double precision, longitudewest double precision, latitudesouth double precision, minage integer, maxage integer, ageyoungest integer, ageoldest integer, precedence integer)
 LANGUAGE sql
AS $function$

    SELECT     
            s.siteid,  
			s.geog as "geog", 
			ndb.datasets.datasetid, 
			ndb.datasettypes.datasettype, 
			ndb.collectionunits.handle as "collunithandle", 
			ndb.collectionunits.collunitname, 
			ndb.constituentdatabases.databasename,
			s.sitename, 
			s.sitedescription, 
			s.longitudeeast, 
			s.latitudenorth, 
            s.longitudewest, 
			s.latitudesouth, 
			null::integer as minage, 
			null::integer as maxage, 
			ch.ageboundyounger as ageyoungest, 
			ch.ageboundolder as ageoldest, 
			at.precedence
    FROM         
            ndb.datasets inner join
            ndb.datasettypes on ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid left join
            ndb.datasetdatabases on ndb.datasetdatabases.datasetid = ndb.datasets.datasetid left join
            ndb.constituentdatabases on ndb.constituentdatabases.databaseid = ndb.datasetdatabases.databaseid inner join
            ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
            ndb.sites as s on ndb.collectionunits.siteid = s.siteid left join
            ndb.chronologies as ch on ch.collectionunitid = ndb.collectionunits.collectionunitid left join
            ndb.agetypes as at on at.agetypeid = ch.agetypeid

     where  s.sitename like _sitename
     order by siteid, datasetid, precedence;

$function$
