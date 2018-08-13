-- ----------------------------
-- procedure structure for getaggregatechronbydatasetid
-- ----------------------------




create procedure [getaggregatechronbydatasetid](@aggregatedatasetid int)
as
select     aggregatechronid, aggregatedatasetid, agetypeid, isdefault, chronologyname, ageboundyounger, ageboundolder, notes
from         ndb.aggregatechronologies
where     (aggregatedatasetid = @aggregatedatasetid)






go

-- ----------------------------
-- procedure structure for getaggregatedatasetbyname
-- ----------------------------



create procedure [getaggregatedatasetbyname](@name nvarchar(255))
as
select     aggregatedatasetid, aggregatedatasetname, aggregateordertypeid, notes
from       ndb.aggregatedatasets
where     (aggregatedatasetname = @name)





go

-- ----------------------------
-- procedure structure for getanalysisunit
-- ----------------------------



create procedure [getanalysisunit](@collectionuniid int, @analunitname nvarchar(80) = null, @depth float = null, @thickness float = null)
as
if @analunitname is null and @depth is not null and @thickness is not null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname is null) and (depth = @depth) and (thickness = @thickness)
end
else if @analunitname is null and @depth is not null and @thickness is null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname is null) and (depth = @depth) and (thickness is null)
end
else if @analunitname is not null and @depth is not null and @thickness is null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname = @analunitname) and (depth = @depth) and (thickness is null)
end
else if @analunitname is not null and @depth is null and @thickness is null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname = @analunitname) and (depth is null) and (thickness is null)
end
else if @analunitname is not null and @depth is null and @thickness is not null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname = @analunitname) and (depth is null) and (thickness = @thickness)
end
else if @analunitname is not null and @depth is not null and @thickness is not null
begin
  select analysisunitid
  from   ndb.analysisunits
  where  (collectionunitid = @collectionuniid) and (analysisunitname = @analunitname) and (depth = @depth) and (thickness = @thickness)
end
go

-- ----------------------------
-- procedure structure for getanalysisunitbyid
-- ----------------------------



create procedure [getanalysisunitbyid](@analyunitid int)
as
select     collectionunitid, analysisunitname, depth, thickness
from         ndb.analysisunits
where     (analysisunitid = @analyunitid)






go

-- ----------------------------
-- procedure structure for getanalysisunitsamplecount
-- ----------------------------



-- gets number of samples assigned to analysis unit
create procedure [getanalysisunitsamplecount](@analunitid int)
as
select     count(analysisunitid) as count
from       ndb.samples
where      (analysisunitid = @analunitid)



go

-- ----------------------------
-- procedure structure for getanalysisunitsbycollunitid
-- ----------------------------




create procedure [getanalysisunitsbycollunitid](@collunitid int)
as
select     analysisunitid, analysisunitname, depth, thickness
from       ndb.analysisunits
where      (collectionunitid = @collunitid)




go

-- ----------------------------
-- procedure structure for getbiochemdatasetbyid
-- ----------------------------




create procedure [getbiochemdatasetbyid](@datasetid int)
as

declare @datasettypeid int = (select datasettypeid from ndb.datasets where (datasetid = @datasetid))
if @datasettypeid = 27
  begin
    select     top (100) percent ndb.data.sampleid, ndb.analysisunits.analysisunitname, ndb.samples.samplename, convert(nvarchar(10),ndb.samples.sampledate,120) as sampledate,
	                  ndb.taxa.taxonname, taxa_1.taxonname as variable, ndb.variableelements.variableelement, ndb.variableunits.variableunits, ndb.data.value
    from         ndb.samples inner join
                      ndb.taxa on ndb.samples.taxonid = ndb.taxa.taxonid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.taxa as taxa_1 on ndb.variables.taxonid = taxa_1.taxonid left outer join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid left outer join
                      ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid
    where     (ndb.samples.datasetid = @datasetid)
    order by ndb.data.sampleid
  end
else
  select n'dataset is not biochemistry'


go

-- ----------------------------
-- procedure structure for getchildtaxaforallsites
-- ----------------------------




create procedure [getchildtaxaforallsites](@taxonname nvarchar(80))
as
with taxacte
as
(
  select taxonid as basetaxonid, taxonid, taxonname, author, highertaxonid, 0 as level
  from ndb.taxa
  where taxonname = @taxonname

  union all

  select parent.basetaxonid, child.taxonid, child.taxonname, child.author, child.highertaxonid, parent.level +1 as level
  from taxacte as parent
    inner join ndb.taxa as child
      on parent.taxonid = child.highertaxonid
)

select     taxacte.taxonid, taxacte.taxonname, ndb.sites.sitename
from         taxacte inner join
                      ndb.variables on taxacte.taxonid = ndb.variables.taxonid inner join
                      ndb.data on ndb.variables.variableid = ndb.data.variableid inner join
                      ndb.samples on ndb.data.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid
group by taxacte.taxonid, taxacte.taxonname, ndb.sites.sitename




go


-- ----------------------------
-- procedure structure for getchroncontroltypehighestid
-- ----------------------------



create procedure [getchroncontroltypehighestid](@chroncontroltypeid int)
as
declare @id int
declare @higherid int
set @id = @chroncontroltypeid
set @higherid = (select higherchroncontroltypeid from ndb.chroncontroltypes where (chroncontroltypeid = @id))
while @id <> @higherid
begin
  set @id = @higherid
  set @higherid = (select higherchroncontroltypeid from ndb.chroncontroltypes where (chroncontroltypeid = @id))
end
select chroncontroltypeid, chroncontroltype, higherchroncontroltypeid
from ndb.chroncontroltypes
where (chroncontroltypeid = @id)




go


-- ----------------------------
-- procedure structure for getchronocontrolsbyanalysisunitid
-- ----------------------------




create procedure [getchronocontrolsbyanalysisunitid](@analunitid int)
as
select    chroncontrolid
from      ndb.chroncontrols
where     (analysisunitid = @analunitid)


go


-- ----------------------------
-- procedure structure for getcontactlinks
-- ----------------------------



create procedure [getcontactlinks](@contactid int)
as
declare @linkedtables table
(
  linkid int not null identity(1,1) primary key,
  tablename nvarchar(255),
  number int
)

declare @count int

set @count = (select count(contactid) as count from ndb.chronologies where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'chronologies', @count)
end

set @count = (select count(contactid) as count from ndb.collectors where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'collectors', @count)
end

set @count = (select count(contactid) as count from ndb.constituentdatabases where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'constituentdatabases', @count)
end

set @count = (select count(contactid) as count from ndb.dataprocessors where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'dataprocessors', @count)
end

set @count = (select count(contactid) as count from ndb.datasetpis where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'datasetpis', @count)
end

set @count = (select count(contactid) as count from ndb.publicationauthors where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'publicationauthors', @count)
end

set @count = (select count(contactid) as count from ndb.sampleanalysts where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'sampleanalysts', @count)
end

set @count = (select count(contactid) as count from ndb.siteimages where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'siteimages', @count)
end

set @count = (select count(contactid) as count from ti.stewards where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'stewards', @count)
end

set @count = (select count(contactid) as count from ti.stewardupdates where (contactid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'stewardupdates', @count)
end

set @count = (select count(validatorid) as count from ndb.taxa where (validatorid = @contactid))
if (@count > 0)
begin
  insert into @linkedtables(tablename, number) values(n'taxa', @count)
end


select tablename, number
from   @linkedtables



go


-- ----------------------------
-- procedure structure for getdatasetauthorsdatasettypes
-- ----------------------------




create procedure [getdatasetauthorsdatasettypes](@datasettypeidlist nvarchar(max) = null)
as
if @datasettypeidlist is null
  begin
    select ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
    from   ndb.datasets inner join
               ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
               ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
               ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid inner join
               ndb.contacts on ndb.publicationauthors.contactid = ndb.contacts.contactid
    group by ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
  end
else
  begin
    select ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
    from   ndb.datasets inner join
               ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
               ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
               ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid inner join
               ndb.contacts on ndb.publicationauthors.contactid = ndb.contacts.contactid
    group by ndb.contacts.contactid, ndb.datasets.datasettypeid, ndb.datasets.datasetid, ndb.contacts.contactname
    having (ndb.datasets.datasettypeid in (select value from ti.func_nvarcharlisttoin(@datasettypeidlist,',')))
  end

go

-- ----------------------------
-- procedure structure for getdatasetcountbycollunittype
-- ----------------------------



create procedure [getdatasetcountbycollunittype](@collunittypeid int)
as
select     top (100) percent ndb.datasettypes.datasettype, count(ndb.datasets.datasetid) as count
from         ndb.collectionunits inner join
                      ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                      ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
group by ndb.collectionunits.colltypeid, ndb.datasettypes.datasettype
having      (ndb.collectionunits.colltypeid = @collunittypeid)
order by count desc





go

-- ----------------------------
-- procedure structure for getdatasetdata
-- ----------------------------



create procedure [getdatasetdata](@datasetid int)
as
select     ndb.data.dataid, ndb.data.sampleid, ndb.data.variableid, ndb.data.value, ndb.summarydatataphonomy.taphonomictypeid
from         ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid left outer join
                      ndb.summarydatataphonomy on ndb.data.dataid = ndb.summarydatataphonomy.dataid
where     (ndb.samples.datasetid = @datasetid)



go

-- ----------------------------
-- procedure structure for getdatasetdatabase
-- ----------------------------




create procedure [getdatasetdatabase](@datasetid int)
as
select     ndb.constituentdatabases.databaseid, ndb.constituentdatabases.databasename
from       ndb.datasets inner join
                      ndb.datasetsubmissions on ndb.datasets.datasetid = ndb.datasetsubmissions.datasetid inner join
                      ndb.constituentdatabases on ndb.datasetsubmissions.databaseid = ndb.constituentdatabases.databaseid
where     (ndb.datasets.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getdatasetidbycollunitandtype
-- ----------------------------




create procedure [getdatasetidbycollunitandtype](@collunitid int, @datasettypeid int)
as
select    datasetid
from      ndb.datasets
where     (datasettypeid = @datasettypeid) and (collectionunitid = @collunitid)





go

-- ----------------------------
-- procedure structure for getdatasetidsbytaxonid
-- ----------------------------





create procedure [getdatasetidsbytaxonid](@taxonid int)
as
select     ndb.datasets.datasetid
from         ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid
group by ndb.datasets.datasetid, ndb.variables.taxonid
having      (ndb.variables.taxonid = @taxonid)




go

-- ----------------------------
-- procedure structure for getdatasetpis
-- ----------------------------


create procedure [getdatasetpis](@datasetid int)
as select      ndb.datasetpis.piorder, ndb.contacts.familyname, ndb.contacts.leadinginitials
from          ndb.datasetpis inner join
                        ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
where      (ndb.datasetpis.datasetid = @datasetid)
order by ndb.datasetpis.piorder





go

-- ----------------------------
-- procedure structure for getdatasetpisdatasettypes
-- ----------------------------



create procedure [getdatasetpisdatasettypes](@datasettypeidlist nvarchar(max) = null)
as
if @datasettypeidlist is null
  begin
    select ndb.datasetpis.contactid, ndb.datasets.datasettypeid, ndb.datasetpis.datasetid, ndb.contacts.contactname
    from   ndb.datasetpis inner join
               ndb.datasets on ndb.datasetpis.datasetid = ndb.datasets.datasetid inner join
               ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
  end
else
  begin
    select ndb.datasetpis.contactid, ndb.datasets.datasettypeid, ndb.datasetpis.datasetid, ndb.contacts.contactname
    from   ndb.datasetpis inner join
               ndb.datasets on ndb.datasetpis.datasetid = ndb.datasets.datasetid inner join
               ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
    where  (ndb.datasets.datasettypeid in (select value from ti.func_nvarcharlisttoin(@datasettypeidlist,',')))
  end

go

-- ----------------------------
-- procedure structure for getdatasetpublicationids
-- ----------------------------





create procedure [getdatasetpublicationids](@datasetid int)
as
select     publicationid
from       ndb.datasetpublications
where     (datasetid = @datasetid)






go

-- ----------------------------
-- procedure structure for getdatasetpublications
-- ----------------------------



create procedure [getdatasetpublications](@datasetid int)
as
select     ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle,
                      ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi,
                      ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle,
                      ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country,
                      ndb.publications.originallanguage, ndb.publications.notes
from         ndb.datasetpublications inner join
                      ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid
where     (ndb.datasetpublications.datasetid = @datasetid)




go

-- ----------------------------
-- procedure structure for getdatasetpublicationstatus
-- ----------------------------




create procedure [getdatasetpublicationstatus](@datasetid int, @publicationid int)
as
select     primarypub
from       ndb.datasetpublications
where      (datasetid = @datasetid) and (publicationid = @publicationid)





go

-- ----------------------------
-- procedure structure for getdatasetrepository
-- ----------------------------



create procedure [getdatasetrepository](@datasetid int)
as
select     ndb.repositoryinstitutions.repositoryid, ndb.repositoryinstitutions.acronym, ndb.repositoryinstitutions.repository, ndb.repositoryinstitutions.notes
from         ndb.repositoryspecimens inner join
                      ndb.repositoryinstitutions on ndb.repositoryspecimens.repositoryid = ndb.repositoryinstitutions.repositoryid
where     (ndb.repositoryspecimens.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getdatasetrepositoryspecimennotes
-- ----------------------------




create procedure [getdatasetrepositoryspecimennotes](@datasetid int)
as
select repositoryid, notes
from   ndb.repositoryspecimens
where  (datasetid = @datasetid)






go

-- ----------------------------
-- procedure structure for getdatasetsampleanalysts
-- ----------------------------




create procedure [getdatasetsampleanalysts](@datasetid int)
as
select     ndb.sampleanalysts.sampleid, ndb.sampleanalysts.contactid
from         ndb.samples inner join
                      ndb.sampleanalysts on ndb.samples.sampleid = ndb.sampleanalysts.sampleid
where     (ndb.samples.datasetid = @datasetid)






go

-- ----------------------------
-- procedure structure for getdatasetsampledepagents
-- ----------------------------






create procedure [getdatasetsampledepagents](@datasetid int)
as
select     ndb.samples.sampleid, ndb.depagenttypes.depagent
from         ndb.depagents inner join
                      ndb.samples on ndb.depagents.analysisunitid = ndb.samples.analysisunitid inner join
                      ndb.depagenttypes on ndb.depagents.depagentid = ndb.depagenttypes.depagentid
where     (ndb.samples.datasetid = @datasetid)







go

-- ----------------------------
-- procedure structure for getdatasetsampleids
-- ----------------------------




create procedure [getdatasetsampleids](@datasetid int)
as
select     top (100) percent sampleid
from         ndb.samples
where     (datasetid = @datasetid)
order by sampleid





go

-- ----------------------------
-- procedure structure for getdatasetsamplekeywords
-- ----------------------------





create procedure [getdatasetsamplekeywords](@datasetid int)
as
select     ndb.samplekeywords.sampleid, ndb.keywords.keyword
from         ndb.samples inner join
                      ndb.samplekeywords on ndb.samples.sampleid = ndb.samplekeywords.sampleid inner join
                      ndb.keywords on ndb.samplekeywords.keywordid = ndb.keywords.keywordid
where     (ndb.samples.datasetid = @datasetid)







go

-- ----------------------------
-- procedure structure for getdatasetsamples
-- ----------------------------



create procedure [getdatasetsamples](@datasetid int)
as
select     ndb.samples.sampleid, ndb.samples.samplename, convert(nvarchar(10),ndb.samples.sampledate,120) as sampledate,
                      convert(nvarchar(10),ndb.samples.analysisdate,120) as analysisdate, ndb.samples.labnumber,
                      ndb.samples.preparationmethod, ndb.samples.notes as samplenotes, ndb.analysisunits.analysisunitid, ndb.analysisunits.analysisunitname,
					  ndb.analysisunits.depth, ndb.analysisunits.thickness, ndb.analysisunits.faciesid, ndb.faciestypes.facies, ndb.analysisunits.mixed,
					  ndb.analysisunits.igsn, ndb.analysisunits.notes as analunitnotes
from         ndb.samples inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid left outer join
                      ndb.faciestypes on ndb.analysisunits.faciesid = ndb.faciestypes.faciesid
where     (ndb.samples.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getdatasetsbycontactid
-- ----------------------------



create procedure [getdatasetsbycontactid](@contactid int)
as select     top (100) percent ndb.datasetpis.datasetid, ndb.datasettypes.datasettype, ndb.sites.siteid, ndb.sites.sitename, ti.geopol1.geopolname1,
                      ti.geopol2.geopolname2, ti.geopol3.geopolname3
from         ndb.datasetpis inner join
                      ndb.datasets on ndb.datasetpis.datasetid = ndb.datasets.datasetid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid inner join
                      ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid left outer join
                      ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                      ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid left outer join
                      ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid
where     (ndb.datasetpis.contactid = @contactid)
order by ndb.sites.sitename





go

-- ----------------------------
-- procedure structure for getdatasetsbyid
-- ----------------------------



create procedure [getdatasetsbyid](@datasets nvarchar(max))
as
select     ndb.datasets.datasetid, ndb.datasets.collectionunitid, ndb.datasets.datasettypeid, ndb.datasettypes.datasettype, ndb.datasets.datasetname,
                      ndb.datasets.notes
from         ndb.datasets inner join
                      ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
where (datasetid in (
		            select value
		            from ti.func_nvarcharlisttoin(@datasets,'$')
                    ))


go

-- ----------------------------
-- procedure structure for getdatasetsbysiteid
-- ----------------------------


create procedure [getdatasetsbysiteid](@siteid int)
as select      ndb.collectionunits.collectionunitid, ndb.collectionunits.collunitname, ndb.datasets.datasetid, ndb.datasettypes.datasettype
from          ndb.sites inner join
                        ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                        ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                        ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
where      (ndb.sites.siteid = @siteid)




go

-- ----------------------------
-- procedure structure for getdatasetsbysitename
-- ----------------------------


create procedure [getdatasetsbysitename](@sitename nvarchar(128))
as
select     ndb.sites.siteid, ndb.sites.sitename, ndb.datasets.datasetid, ndb.datasettypes.datasettype
from         ndb.sites inner join
                      ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                      ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                      ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
where      (ndb.sites.sitename like @sitename)





go

-- ----------------------------
-- procedure structure for getdatasetsbytaxon
-- ----------------------------





create procedure [getdatasetsbytaxon](@taxon nvarchar(80))
as
select     ndb.taxa.taxonname, ndb.variableelements.variableelement, ndb.datasets.datasetid, ndb.datasettypes.datasettype, ndb.collectionunits.collectionunitid,
                      ndb.sites.siteid, ndb.sites.sitename
from         ndb.taxa inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid inner join
                      ndb.data on ndb.variables.variableid = ndb.data.variableid inner join
                      ndb.samples on ndb.data.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid inner join
                      ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid left outer join
                      ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid
group by ndb.taxa.taxonname, ndb.variableelements.variableelement, ndb.datasets.datasetid, ndb.collectionunits.collectionunitid, ndb.sites.siteid,
                      ndb.sites.sitename, ndb.datasettypes.datasettype
having      (ndb.taxa.taxonname = @taxon)






go

-- ----------------------------
-- procedure structure for getdatasetspecimendates
-- ----------------------------



create procedure [getdatasetspecimendates](@datasetid int)
as
select     top (100) percent ndb.specimens.specimenid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth, ndb.analysisunits.thickness,
                      ndb.taxa.taxonname, ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext, ndb.elementtypes.elementtype,
                      ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity, ndb.specimensextypes.sex,
                      ndb.specimendomesticstatustypes.domesticstatus, ndb.specimens.nisp, ndb.specimens.preservative, ndb.repositoryinstitutions.repository,
                      ndb.specimens.specimennr, ndb.specimens.fieldnr, ndb.specimens.arctosnr, ndb.specimengenbank.genbanknr, ndb.specimens.notes,
                      ndb.geochrontypes.geochrontype, ndb.geochronology.labnumber, ndb.fractiondated.fraction, ndb.geochronology.age, ndb.geochronology.errorolder,
                      ndb.geochronology.erroryounger, ndb.geochronology.infinite, ndb.specimendatescal.calageolder, ndb.specimendatescal.calageyounger,
                      ndb.calibrationcurves.calibrationcurve, ndb.calibrationprograms.calibrationprogram, ndb.calibrationprograms.version
from         ndb.specimengenbank right outer join
                      ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.specimens on ndb.data.dataid = ndb.specimens.dataid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid on ndb.specimengenbank.specimenid = ndb.specimens.specimenid left outer join
                      ndb.calibrationcurves inner join
                      ndb.specimendatescal on ndb.calibrationcurves.calibrationcurveid = ndb.specimendatescal.calibrationcurveid inner join
                      ndb.calibrationprograms on ndb.specimendatescal.calibrationprogramid = ndb.calibrationprograms.calibrationprogramid right outer join
                      ndb.geochrontypes inner join
                      ndb.geochronology on ndb.geochrontypes.geochrontypeid = ndb.geochronology.geochrontypeid inner join
                      ndb.fractiondated inner join
                      ndb.specimendates on ndb.fractiondated.fractionid = ndb.specimendates.fractionid on ndb.geochronology.geochronid = ndb.specimendates.geochronid on
                      ndb.specimendatescal.specimendateid = ndb.specimendates.specimendateid on
                      ndb.specimens.specimenid = ndb.specimendates.specimenid left outer join
                      ndb.repositoryinstitutions on ndb.specimens.repositoryid = ndb.repositoryinstitutions.repositoryid left outer join
                      ndb.specimendomesticstatustypes on ndb.specimens.domesticstatusid = ndb.specimendomesticstatustypes.domesticstatusid left outer join
                      ndb.specimensextypes on ndb.specimens.sexid = ndb.specimensextypes.sexid left outer join
                      ndb.elementsymmetries on ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid left outer join
                      ndb.elementmaturities on ndb.specimens.maturityid = ndb.elementmaturities.maturityid left outer join
                      ndb.elementportions on ndb.specimens.portionid = ndb.elementportions.portionid left outer join
                      ndb.elementtypes on ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid left outer join
                      ndb.variablecontexts on ndb.variables.variablecontextid = ndb.variablecontexts.variablecontextid left outer join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid
where     (ndb.datasets.datasetid = @datasetid)
order by ndb.specimens.specimenid






go

-- ----------------------------
-- procedure structure for getdatasetspecimengenbanknrs
-- ----------------------------







create procedure [getdatasetspecimengenbanknrs](@datasetid int)
as
select     ndb.specimens.specimenid, ndb.specimengenbank.genbanknr
from         ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.specimens on ndb.data.dataid = ndb.specimens.dataid inner join
                      ndb.specimengenbank on ndb.specimens.specimenid = ndb.specimengenbank.specimenid
where     (ndb.samples.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getdatasetspecimens
-- ----------------------------






create procedure [getdatasetspecimens](@datasetid int)
as
select     ndb.specimens.specimenid, ndb.specimens.dataid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion,
                      ndb.elementmaturities.maturity, ndb.specimensextypes.sex, ndb.specimendomesticstatustypes.domesticstatus, ndb.specimens.preservative,
                      ndb.specimens.nisp, ndb.repositoryinstitutions.repository, ndb.specimens.specimennr, ndb.specimens.fieldnr, ndb.specimens.arctosnr,
                      ndb.specimens.notes, ndb.taxa.taxonname, ndb.taxagrouptypes.taxagroup
from         ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.specimens on ndb.data.dataid = ndb.specimens.dataid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
                      ndb.taxagrouptypes on ndb.taxa.taxagroupid = ndb.taxagrouptypes.taxagroupid left outer join
                      ndb.repositoryinstitutions on ndb.specimens.repositoryid = ndb.repositoryinstitutions.repositoryid left outer join
                      ndb.specimendomesticstatustypes on ndb.specimens.domesticstatusid = ndb.specimendomesticstatustypes.domesticstatusid left outer join
                      ndb.specimensextypes on ndb.specimens.sexid = ndb.specimensextypes.sexid left outer join
                      ndb.elementmaturities on ndb.specimens.maturityid = ndb.elementmaturities.maturityid left outer join
                      ndb.elementsymmetries on ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid left outer join
                      ndb.elementtypes on ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid left outer join
                      ndb.elementportions on ndb.specimens.portionid = ndb.elementportions.portionid
where     (ndb.samples.datasetid = @datasetid)




go

-- ----------------------------
-- procedure structure for getdatasetspecimentaphonomy
-- ----------------------------








create procedure [getdatasetspecimentaphonomy](@datasetid int)
as
select    ndb.specimens.specimenid, ndb.taphonomicsystems.taphonomicsystem, ndb.taphonomictypes.taphonomictype
from         ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.specimens on ndb.data.dataid = ndb.specimens.dataid inner join
                      ndb.specimentaphonomy on ndb.specimens.specimenid = ndb.specimentaphonomy.specimenid inner join
                      ndb.taphonomictypes on ndb.specimentaphonomy.taphonomictypeid = ndb.taphonomictypes.taphonomictypeid inner join
                      ndb.taphonomicsystems on ndb.taphonomictypes.taphonomicsystemid = ndb.taphonomicsystems.taphonomicsystemid
where     (ndb.samples.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getdatasetsynonyms
-- ----------------------------


create procedure [getdatasetsynonyms](@datasetid int)
as
select     top (100) percent ndb.synonymy.synonymyid, ndb.taxa.taxonname as validname, taxa_1.taxonname as refname, ndb.synonymy.fromcontributor,
                      ndb.synonymy.publicationid, ndb.synonymy.notes
from         ndb.synonymy inner join
                      ndb.taxa on ndb.synonymy.taxonid = ndb.taxa.taxonid inner join
                      ndb.taxa as taxa_1 on ndb.synonymy.reftaxonid = taxa_1.taxonid
where     (ndb.synonymy.datasetid = @datasetid)
order by ndb.synonymy.synonymyid



go

-- ----------------------------
-- procedure structure for getdatasettaxonnotes
-- ----------------------------



create procedure [getdatasettaxonnotes](@datasetid int)
as
select     ndb.datasettaxonnotes.taxonid, ndb.taxa.taxonname, ndb.datasettaxonnotes.notes
from         ndb.datasettaxonnotes inner join
                      ndb.taxa on ndb.datasettaxonnotes.taxonid = ndb.taxa.taxonid
where     (ndb.datasettaxonnotes.datasetid = @datasetid)

go

-- ----------------------------
-- procedure structure for getdatasettaxonnotesbytaxonid
-- ----------------------------




create procedure [getdatasettaxonnotesbytaxonid](@datasetid int, @taxonid int)
as
select     ndb.datasettaxonnotes.taxonid, ndb.taxa.taxonname, ndb.datasettaxonnotes.notes
from         ndb.datasettaxonnotes inner join
                      ndb.taxa on ndb.datasettaxonnotes.taxonid = ndb.taxa.taxonid
where     (ndb.datasettaxonnotes.datasetid = @datasetid and ndb.datasettaxonnotes.taxonid = @taxonid)


go

-- ----------------------------
-- procedure structure for getdatasettoptaxa
-- ----------------------------


create procedure [getdatasettoptaxa](@datasetid int, @topx int, @grouptaxa nvarchar(max) = null, @alwaysshowtaxa nvarchar(max) = null)
as
/*
@grouptaxa are taxa to be lumped, for example: n'picea$pinus$fraxinus'
@alwaysshowtaxa are taxa to always show, for example: n'fagus$amaranthaceae'
*/

declare @groupedtaxa table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80)
)

if @grouptaxa is not null
begin
  insert into @groupedtaxa (taxonname)
  select taxonname
  from ndb.taxa
  where (taxonname in (
		              select value
		              from ti.func_nvarcharlisttoin(@grouptaxa,'$')
                      ))
end

declare @alwaysshow table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80)
)

if @alwaysshowtaxa is not null
begin
  insert into @alwaysshow (taxonname)
  select taxonname
  from ndb.taxa
  where (taxonname in (
		              select value
		              from ti.func_nvarcharlisttoin(@alwaysshowtaxa,'$')
                      ))
end

declare @pollensums table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  pollensum float,
  ecolgroupid nvarchar(4)
)

declare @newpollensums table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  pollensum float,
  ecolgroupid nvarchar(4)
)

declare @taxalist table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4)
)

declare @toptaxa table
(
  id int not null primary key,
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4)
)

declare @therest table
(
  id int not null primary key,
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4)
)

declare @lumptaxa table
(
  id int not null primary key identity(1,1),
  taxonid int,
  taxonname nvarchar(80),
  author nvarchar(128),
  highertaxonid int,
  level int
)

declare @currentid int
declare @maxgroupid int
declare @lumpsum float
declare @taxonname nvarchar(80)
declare @count int
declare @count1 int
declare @itr int
declare @maxid int
declare @taxonid int
declare @ecolgroupid nvarchar(4)
declare @lumpedtaxon nvarchar(80)
declare @ngrouped int
declare @nalways int
declare @toptaxamaxid int
declare @trsh float = 0
declare @uphe float = 0
declare @vacr float = 0

select     top (100) percent ndb.taxa.taxonname, sum(ndb.data.value) as pollensum, ndb.ecolgroups.ecolgroupid
from       ndb.samples inner join
             ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
             ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
             ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
             ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid
where     (ndb.variables.variableelementid = 141) and (ndb.samples.datasetid = @datasetid) or
             (ndb.variables.variableelementid = 166) and (ndb.samples.datasetid = @datasetid)
group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.taxa.taxonname, ndb.variables.variableunitsid
having    (ndb.ecolgroups.ecolsetid = 1) and (ndb.ecolgroups.ecolgroupid = n'trsh' or
             ndb.ecolgroups.ecolgroupid = n'uphe') and (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28) or
             (ndb.ecolgroups.ecolsetid = 1) and (ndb.ecolgroups.ecolgroupid = n'vacr') and (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28)
order by pollensum desc

insert into @taxalist (taxonname, ecolgroupid)
select top (100) percent taxonname, ecolgroupid
from @pollensums

set @ngrouped = (select count(*) as count from @groupedtaxa)

if (@ngrouped > 0)
begin
  set @currentid = (select min(id) from @groupedtaxa)
  set @maxgroupid = (select max(id) from @groupedtaxa)
  while(@currentid <= @maxgroupid)
    begin
	  set @lumpedtaxon = (select taxonname from @groupedtaxa where (id = @currentid))

	  insert into @lumptaxa (taxonid, taxonname, author, highertaxonid, level)
      exec ti.getchildtaxa @lumpedtaxon

	  set @lumpsum = 0
      set @itr = (select min(id) from @pollensums)
      set @maxid = (select max(id) from @pollensums)

	  while (@itr <= @maxid)
        begin
		  set @taxonname = (select taxonname from @pollensums where id = @itr)
          set @count = (select count(taxonname) from @lumptaxa where (taxonname = @taxonname))
          if (@count > 0)
            begin
			  set @lumpsum = @lumpsum + (select pollensum from @pollensums where id = @itr)
	          delete from @pollensums where (id = @itr)
	        end
          set @itr = @itr + 1
        end

      if (@lumpsum > 0)
        begin
          set @taxonid = (select taxonid from @lumptaxa where taxonname = @lumpedtaxon)
	      set @ecolgroupid = (select ecolgroupid from ndb.ecolgroups where (ndb.ecolgroups.taxonid = @taxonid) and (ndb.ecolgroups.ecolsetid = 1))
          insert into @pollensums (taxonname, pollensum, ecolgroupid) values (@lumpedtaxon, @lumpsum, @ecolgroupid)
        end

      delete from @lumptaxa where (id <= @maxid)
      set @currentid = @currentid + 1
    end
end

insert into @newpollensums (taxonname, pollensum, ecolgroupid)
select top (100) percent taxonname, pollensum, ecolgroupid
from @pollensums
order by pollensum desc

insert into @toptaxa (id, taxonname, ecolgroupid)
select     id, taxonname, ecolgroupid
from @newpollensums
where (id <= @topx)

insert into @therest (id, taxonname, ecolgroupid)
select     id, taxonname, ecolgroupid
from @newpollensums
where (id > @topx)

set @toptaxamaxid = (select max(id) from @toptaxa)

set @nalways = (select count(*) as count from @alwaysshow)
if (@nalways > 0)
  begin
    set @itr = (select min(id) from @alwaysshow)
    set @maxid = (select max(id) from @alwaysshow)
	while (@itr <= @maxid)
	  begin
	    set @taxonname = (select taxonname from @alwaysshow where (id = @itr))
        set @count = (select count(taxonname) from @taxalist where (taxonname = @taxonname))
		if (@count > 0)
		  begin
		    set @count1 = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
			if (@count1 = 0)
			  begin
			    set @toptaxamaxid = @toptaxamaxid + 1
				set @ecolgroupid = (select ecolgroupid from @taxalist where (taxonname = @taxonname))
	            insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, @taxonname, @ecolgroupid)
			  end
		  end
		set @itr = @itr + 1
	  end
  end

set @itr = (select min(id) from @therest)
set @maxid = (select max(id) from @therest)
while (@itr <= @maxid)
  begin
	set @ecolgroupid = (select ecolgroupid from @therest where (id = @itr))
    if (@ecolgroupid = n'trsh')
	  begin
	    set @taxonname = (select taxonname from @therest where (id = @itr))
		set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		if (@count = 0)
		  set @trsh = @trsh + (select pollensum from @pollensums where (taxonname = @taxonname))
	  end
	else if (@ecolgroupid = n'uphe')
	  begin
	    set @taxonname = (select taxonname from @therest where (id = @itr))
		set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		if (@count = 0)
		  set @uphe = @uphe + (select pollensum from @pollensums where (taxonname = @taxonname))
	  end
    else if (@ecolgroupid = n'vacr')
	  begin
	    set @taxonname = (select taxonname from @therest where (id = @itr))
		set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		if (@count = 0)
		  set @vacr = @vacr + (select pollensum from @pollensums where (taxonname = @taxonname))
	  end
	set @itr = @itr + 1
  end


if (@trsh > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other trees and shrubs', n'trsh')
  end
if (@uphe > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other upland herbs', n'uphe')
  end
if (@trsh > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other terrestrial vascular cryptogams', n'vacr')
  end

select id, taxonname, ecolgroupid
from @toptaxa
order by id

go

-- ----------------------------
-- procedure structure for getdatasettoptaxadata
-- ----------------------------


create procedure [getdatasettoptaxadata](@datasetid int, @topx int = 15, @grouptaxa nvarchar(max) = null, @alwaysshowtaxa nvarchar(max) = null
)
as

-- coded by eric c. grimm
-- last modification 15 april 2017
-- @grouptaxa: taxa to be lumped, for example: n'picea$pinus$fraxinus'
-- @alwaysshowtaxa: taxa to always show, for example: n'fagus$larix' (but will not be listed if taxon does not occur in dataset at all)

declare @datasettypeid int = (select datasettypeid from ndb.datasets where (datasetid = @datasetid))

if (@datasettypeid not in(2,3,9,11))  -- loi, pollen, ostracodes, diatoms
  begin
    declare @datasettype nvarchar(64) = (select ndb.datasettypes.datasettype
                                         from ndb.datasets inner join
                                           ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
                                         where (ndb.datasets.datasetid = @datasetid))
	-- declare @error table (error nvarchar(255))
	-- insert into @error (error) values (@datasettype + ' dataset type not supported')
	-- select error from @error
	declare @errmsg nvarchar(255) = @datasettype + ' dataset type not supported'
	raiserror(@errmsg, 16, 1);
    return
  end


declare @groupedtaxa table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80)
)

if @grouptaxa is not null
begin
  insert into @groupedtaxa (taxonname)
  select taxonname
  from ndb.taxa
  where (taxonname in (
		              select value
		              from ti.func_nvarcharlisttoin(@grouptaxa,'$')
                      ))
end

declare @alwaysshow table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80)
)

if @alwaysshowtaxa is not null
begin
  insert into @alwaysshow (taxonname)
  select taxonname
  from ndb.taxa
  where (taxonname in (
		              select value
		              from ti.func_nvarcharlisttoin(@alwaysshowtaxa,'$')
                      ))
end

declare @sums table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  pollensum float,
  ecolgroupid nvarchar(4),
  element nvarchar(255),
  units nvarchar(64)
)

declare @newsums table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  pollensum float,
  ecolgroupid nvarchar(4),
  element nvarchar(255),
  units nvarchar(64)
)

declare @taxalist table
(
  id int not null primary key identity(1,1),
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4),
  element nvarchar(255),
  units nvarchar(64)
)

declare @toptaxa table
(
  id int not null primary key,
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4),
  element nvarchar(255),
  units nvarchar(64)
)

declare @therest table
(
  id int not null primary key,
  taxonname nvarchar(80),
  ecolgroupid nvarchar(4)
)

declare @lumptaxa table
(
  id int not null primary key identity(1,1),
  taxonid int,
  taxonname nvarchar(80),
  author nvarchar(128),
  highertaxonid int,
  level int
)

declare @summedtaxa table
(
  id int not null primary key identity(1,1),
  sumname nvarchar(80),
  taxonname nvarchar(80)
)

declare @allsums table
(
  id int not null primary key identity(1,1),
  sumname nvarchar(80),
  sumstr nvarchar(max)
)

declare @sumvalues table
(
  id int not null primary key identity(1,1),
  sampleid int,
  sumname nvarchar(80),
  value float
)

declare @data table
(
  id int not null primary key identity(1,1),
  sampleid int,
  taxonname nvarchar(80),
  units nvarchar(64),
  ecolgroupid nvarchar(4),
  value float,
  depth float,
  chronologyid int,
  chronologyname nvarchar(80),
  age float
)

declare @tempdata table
(
  id int not null primary key identity(1,1),
  sampleid int,
  taxonname nvarchar(80),
  units nvarchar(64),
  ecolgroupid nvarchar(4),
  value float default 0,
  depth float,
  chronologyid int,
  chronologyname nvarchar(80),
  age float
)

declare @chrons table
(
  id int not null primary key identity(1,1),
  chronologyid int,
  nages int
)

declare @depths table
(
  id int not null primary key identity(1,1),
  sampleid int,
  depth float
)

declare @taxadepths table
(
  id int not null primary key identity(1,1),
  depth float
)

declare @currentid int
declare @maxgroupid int
declare @lumpsum float
declare @taxonname nvarchar(80)
declare @count int
declare @count1 int
declare @itr int
declare @itr1 int
declare @minid int
declare @maxid int
declare @maxid1 int
declare @taxonid int
declare @ecolgroupid nvarchar(4)
declare @lumpedtaxon nvarchar(80)
declare @ngrouped int
declare @nalways int
declare @toptaxamaxid int
declare @trsh float = 0
declare @palm float = 0
declare @mang float = 0
declare @succ float = 0
declare @uphe float = 0
declare @vacr float = 0
declare @diat float = 0 -- new
declare @bnth float = 0 -- new
declare @cosm float = 0 -- new
declare @intr float = 0 -- new
declare @mari float = 0 -- new
declare @nekt float = 0 -- new
declare @ocod float = 0 -- new
declare @nsamples int
declare @ndepths int
declare @dataminid int
declare @nages int
declare @chronid int
declare @chronname nvarchar(80)
declare @maxdepthid int
declare @sql nvarchar(max)
declare @sqltext nvarchar(max)

if (@datasettypeid = 3)  -- pollen
  begin
    insert into @sums (taxonname, pollensum, ecolgroupid)

	select top (100) percent ndb.taxa.taxonname, sum(ndb.data.value) as pollensum, ndb.ecolgroups.ecolgroupid
    from   ndb.samples inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid
    where    ((ndb.variables.variableelementid = 141) and (ndb.variables.variablecontextid is null) and (ndb.samples.datasetid = @datasetid)) or
             ((ndb.variables.variableelementid = 166) and (ndb.variables.variablecontextid is null) and (ndb.samples.datasetid = @datasetid))
    group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.taxa.taxonname, ndb.variables.variableunitsid
    having   (ndb.ecolgroups.ecolsetid = 1) and (ndb.ecolgroups.ecolgroupid in (n'trsh', n'uphe', n'palm', n'mang', n'succ')) and (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28) or
             (ndb.ecolgroups.ecolsetid = 1) and (ndb.ecolgroups.ecolgroupid = n'vacr') and (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28)
    order by pollensum desc
  end
else if (@datasettypeid = 9)  -- ostracodes
  begin
    insert into @sums (taxonname, pollensum, ecolgroupid)
	select top (100) percent ndb.taxa.taxonname, sum(ndb.data.value) as pollensum, ndb.ecolgroups.ecolgroupid
    from   ndb.samples inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid
    where    (ndb.samples.datasetid = @datasetid)
    group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.taxa.taxonname, ndb.variables.variableunitsid
    having   (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28) and (ndb.ecolgroups.ecolsetid = 4)
    order by pollensum desc
  end
else if (@datasettypeid = 11)  -- diatoms
  begin
    insert into @sums (taxonname, pollensum, ecolgroupid)
	select top (100) percent ndb.taxa.taxonname, sum(ndb.data.value) as pollensum, ndb.ecolgroups.ecolgroupid
    from   ndb.samples inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid
    where    (ndb.samples.datasetid = @datasetid)
    group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.taxa.taxonname, ndb.variables.variableunitsid
    having   (ndb.variables.variableunitsid = 19 or
             ndb.variables.variableunitsid = 28) and (ndb.ecolgroups.ecolsetid = 8)
    order by pollensum desc
  end
else if (@datasettypeid = 2)  -- loi
  begin
    insert into @sums (taxonname, pollensum, ecolgroupid, element, units)
	select top (100) percent ndb.taxa.taxonname, sum(ndb.data.value) as pollensum, ndb.ecolgroups.ecolgroupid,
	       ndb.variableelements.variableelement, ndb.variableunits.variableunits
    from   ndb.samples inner join
             ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
             ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
             ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
             ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid left outer join
             ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid left outer join
             ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid
    where    (ndb.samples.datasetid = @datasetid)
    group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.variables.variableunitsid,
                      ndb.variableelements.variableelement, ndb.taxa.taxonname, ndb.variableunits.variableunits
    order by pollensum desc
  end


insert into @taxalist (taxonname, ecolgroupid, element, units)
select top (100) percent taxonname, ecolgroupid, element, units
from @sums

set @ngrouped = (select count(*) as count from @groupedtaxa)

if (@ngrouped > 0)
begin
  set @currentid = (select min(id) from @groupedtaxa)
  set @maxgroupid = (select max(id) from @groupedtaxa)
  while(@currentid <= @maxgroupid)
    begin
	  set @lumpedtaxon = (select taxonname from @groupedtaxa where (id = @currentid))

	  insert into @lumptaxa (taxonid, taxonname, author, highertaxonid, level)
      exec ti.getchildtaxa @lumpedtaxon

	  set @lumpsum = 0
      set @itr = (select min(id) from @sums)
      set @maxid = (select max(id) from @sums)

	  while (@itr <= @maxid)
        begin
		  set @taxonname = (select taxonname from @sums where id = @itr)
          set @count = (select count(taxonname) from @lumptaxa where (taxonname = @taxonname))
          if (@count > 0)
            begin
			  set @lumpsum = @lumpsum + (select pollensum from @sums where id = @itr)
	          delete from @sums where (id = @itr)
			  insert into @summedtaxa (sumname, taxonname) values (@lumpedtaxon, @taxonname)
	        end
          set @itr = @itr + 1
        end

      if (@lumpsum > 0)
        begin
          set @taxonid = (select taxonid from @lumptaxa where taxonname = @lumpedtaxon)
	      set @ecolgroupid = (select ecolgroupid from ndb.ecolgroups where (ndb.ecolgroups.taxonid = @taxonid) and (ndb.ecolgroups.ecolsetid = 1))
          insert into @sums (taxonname, pollensum, ecolgroupid) values (@lumpedtaxon, @lumpsum, @ecolgroupid)
        end

      delete from @lumptaxa where (id <= @maxid)
      set @currentid = @currentid + 1
    end
end

insert into @newsums (taxonname, pollensum, ecolgroupid, element, units)
select top (100) percent taxonname, pollensum, ecolgroupid, element, units
from @sums
order by pollensum desc

insert into @toptaxa (id, taxonname, ecolgroupid, element, units)
select     id, taxonname, ecolgroupid, element, units
from @newsums
where (id <= @topx)

insert into @therest (id, taxonname, ecolgroupid)
select     id, taxonname, ecolgroupid
from @newsums
where (id > @topx)

set @toptaxamaxid = (select max(id) from @toptaxa)

set @nalways = (select count(*) as count from @alwaysshow)
if (@nalways > 0)
  begin
    set @itr = (select min(id) from @alwaysshow)
    set @maxid = (select max(id) from @alwaysshow)
	while (@itr <= @maxid)
	  begin
	    set @taxonname = (select taxonname from @alwaysshow where (id = @itr))
        set @count = (select count(taxonname) from @taxalist where (taxonname = @taxonname))
		if (@count > 0)
		  begin
		    set @count1 = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
			if (@count1 = 0)
			  begin
			    set @toptaxamaxid = @toptaxamaxid + 1
				set @ecolgroupid = (select ecolgroupid from @taxalist where (taxonname = @taxonname))
	            insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, @taxonname, @ecolgroupid)
			  end
		  end
		set @itr = @itr + 1
	  end
  end


-- sum up the 'other' types
set @itr = (select min(id) from @therest)
set @maxid = (select max(id) from @therest)
while (@itr <= @maxid)
  begin
	if (@datasettypeid = 3) -- pollen
	  begin
	    set @ecolgroupid = (select ecolgroupid from @therest where (id = @itr))
        if (@ecolgroupid = n'trsh')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @trsh = @trsh + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other trees and shrubs', @taxonname)
              end
	      end
        if (@ecolgroupid = n'palm')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @palm = @palm + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other palms', @taxonname)
              end
	      end
        if (@ecolgroupid = n'mang')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @mang = @mang + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other mangroves', @taxonname)
              end
	      end
        if (@ecolgroupid = n'succ')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @succ = @succ + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other succulents', @taxonname)
              end
	      end
	    else if (@ecolgroupid = n'uphe')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @uphe = @uphe + (select pollensum from @sums where (taxonname = @taxonname))
		        insert into @summedtaxa (sumname, taxonname) values (n'other upland herbs', @taxonname)
		      end
	      end
        else if (@ecolgroupid = n'vacr')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @vacr = @vacr + (select pollensum from @sums where (taxonname = @taxonname))
		        insert into @summedtaxa (sumname, taxonname) values (n'other terrestrial vascular cryptogams', @taxonname)
		      end
	      end
	  end
    else if (@datasettypeid = 9)  -- ostracodes
	  begin
	    set @ecolgroupid = (select ecolgroupid from @therest where (id = @itr))
        if (@ecolgroupid = n'bnth')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @bnth = @bnth + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other benthic', @taxonname)
              end
	      end
        if (@ecolgroupid = n'cosm')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @cosm = @cosm + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other cosmopolitan', @taxonname)
              end
	      end
        if (@ecolgroupid = n'intr')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @intr = @intr + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other interstitial', @taxonname)
              end
	      end
        if (@ecolgroupid = n'mari')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @mari = @mari + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other marine', @taxonname)
              end
	      end
        if (@ecolgroupid = n'nekt')
	      begin
	        set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @nekt = @nekt + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other nektonic', @taxonname)
              end
	      end
        begin
	      set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @ocod = @ocod + (select pollensum from @sums where (taxonname = @taxonname))
			    insert into @summedtaxa (sumname, taxonname) values (n'other undifferentiated', @taxonname)
              end
	      end
	  end
	else if (@datasettypeid = 11)  -- diatoms
	  begin
	    set @ecolgroupid = (select ecolgroupid from @therest where (id = @itr))
		if (@ecolgroupid = n'diat')
		  begin
		    set @taxonname = (select taxonname from @therest where (id = @itr))
		    set @count = (select count(taxonname) from @toptaxa where (taxonname = @taxonname))
		    if (@count = 0)
		      begin
		        set @diat = @diat + (select pollensum from @sums where (taxonname = @taxonname))
		        insert into @summedtaxa (sumname, taxonname) values (n'other diatoms', @taxonname)
		      end
		  end
	  end
	set @itr = @itr + 1
  end

-- select @diat as 'diat'

if (@trsh > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other trees and shrubs', n'trsh')
  end
if (@palm > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other palms', n'palm')
  end
if (@mang > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other mangroves', n'mang')
  end
if (@succ > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other succulents', n'succ')
  end
if (@uphe > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other upland herbs', n'uphe')
  end
if (@vacr > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other terrestrial vascular cryptogams', n'vacr')
  end
if (@diat > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other diatoms', n'diat')
  end
if (@bnth > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other benthic', n'bnth')
  end
if (@cosm > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other cosmopolitan', n'cosm')
  end
if (@intr > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other interstitial', n'intr')
  end
if (@mari > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other marine', n'mari')
  end
if (@nekt > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other nektonic', n'nekt')
  end
if (@ocod > 0)
  begin
    set @toptaxamaxid = @toptaxamaxid + 1
	insert into @toptaxa (id, taxonname, ecolgroupid) values (@toptaxamaxid, n'other undifferentiated', n'ocod')
  end


set @nsamples = (select count(ndb.analysisunits.depth)
                 from ndb.samples inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
                 where (ndb.samples.datasetid = @datasetid))

set @ndepths = (select count(ndb.analysisunits.depth)
                from ndb.samples inner join
                     ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
                where (ndb.samples.datasetid = @datasetid)
                having (count(ndb.analysisunits.depth) is not null))

insert into @depths (sampleid, depth)
select top (100) percent ndb.samples.sampleid, ndb.analysisunits.depth
from   ndb.samples inner join
         ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid and
         ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
where (ndb.samples.datasetid = @datasetid)
order by ndb.analysisunits.depth

set @maxdepthid = (select max(id) from @depths)

-- get data by depth

if (@ndepths = @nsamples)
  begin
    -- get all values for non-lumped and non-sum taxa
    if (@datasettypeid = 3) -- pollen
	  begin
	    insert into @data (sampleid, taxonname, ecolgroupid, value, depth)
	    select top (100) percent ndb.samples.sampleid, ndb.taxa.taxonname, ndb.ecolgroups.ecolgroupid, ndb.data.value, ndb.analysisunits.depth
        from ndb.samples inner join
           ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
           @toptaxa on ndb.taxa.taxonname = [@toptaxa].taxonname
        where (ndb.samples.datasetid = @datasetid) and (ndb.ecolgroups.ecolsetid = 1) and
	      ((ndb.variables.variableelementid = 141 and ndb.variables.variablecontextid is null) or
		  (ndb.variables.variableelementid = 166 and ndb.variables.variablecontextid is null)) and
		  ((ndb.variables.variableunitsid = 19 or ndb.variables.variableunitsid = 28))
        order by ndb.taxa.taxonname, ndb.analysisunits.depth
	  end
    else if (@datasettypeid = 9) -- ostracodes
	  begin
	    insert into @data (sampleid, taxonname, ecolgroupid, value, depth)
	    select top (100) percent ndb.samples.sampleid, ndb.taxa.taxonname, ndb.ecolgroups.ecolgroupid, ndb.data.value, ndb.analysisunits.depth
        from ndb.samples inner join
           ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
           @toptaxa on ndb.taxa.taxonname = [@toptaxa].taxonname
        where (ndb.samples.datasetid = @datasetid) and (ndb.ecolgroups.ecolsetid = 4) and
		      ((ndb.variables.variableunitsid = 19 or ndb.variables.variableunitsid = 28))
        order by ndb.taxa.taxonname, ndb.analysisunits.depth
	  end
	else if (@datasettypeid = 11) -- diatoms
	  begin
	    insert into @data (sampleid, taxonname, ecolgroupid, value, depth)
	    select top (100) percent ndb.samples.sampleid, ndb.taxa.taxonname, ndb.ecolgroups.ecolgroupid, ndb.data.value, ndb.analysisunits.depth
        from ndb.samples inner join
           ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
           ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
           ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
           ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
           ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
           @toptaxa on ndb.taxa.taxonname = [@toptaxa].taxonname
        where (ndb.samples.datasetid = @datasetid) and (ndb.ecolgroups.ecolsetid = 8) and
		      ((ndb.variables.variableunitsid = 19 or ndb.variables.variableunitsid = 28))
        order by ndb.taxa.taxonname, ndb.analysisunits.depth
	  end
	else if (@datasettypeid = 2) -- loi
	  begin
	    -- element is null
	    insert into @data (sampleid, taxonname, ecolgroupid, value, depth, units)
	    select top (100) percent ndb.samples.sampleid, [@toptaxa].taxonname, ndb.ecolgroups.ecolgroupid, ndb.data.value, ndb.analysisunits.depth, [@toptaxa].units
        from  @toptaxa inner join
                ndb.taxa on [@toptaxa].taxonname = ndb.taxa.taxonname inner join
                ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid and ndb.taxa.taxonid = ndb.variables.taxonid inner join
                ndb.data on ndb.variables.variableid = ndb.data.variableid and ndb.variables.variableid = ndb.data.variableid inner join
                ndb.samples on ndb.data.sampleid = ndb.samples.sampleid and ndb.data.sampleid = ndb.samples.sampleid inner join
                ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid and
                ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
                ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid and ndb.taxa.taxonid = ndb.ecolgroups.taxonid
        where (ndb.samples.datasetid = @datasetid) and ([@toptaxa].element is null)
        order by [@toptaxa].taxonname, ndb.analysisunits.depth
		-- element is not null
		insert into @data (sampleid, taxonname, ecolgroupid, value, depth, units)
		select top (100) percent ndb.samples.sampleid, case when [@toptaxa].element is not null
                      then [@toptaxa].taxonname + n' ' + [@toptaxa].element else [@toptaxa].taxonname end as taxonname, ndb.ecolgroups.ecolgroupid,
                      ndb.data.value, ndb.analysisunits.depth, [@toptaxa].units
        from  @toptaxa inner join
                ndb.taxa on [@toptaxa].taxonname = ndb.taxa.taxonname inner join
                ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid and ndb.taxa.taxonid = ndb.variables.taxonid inner join
                ndb.data on ndb.variables.variableid = ndb.data.variableid and ndb.variables.variableid = ndb.data.variableid inner join
                ndb.samples on ndb.data.sampleid = ndb.samples.sampleid and ndb.data.sampleid = ndb.samples.sampleid inner join
                ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid and
                ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
                ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid and
                ndb.variables.variableelementid = ndb.variableelements.variableelementid and
                [@toptaxa].element = ndb.variableelements.variableelement inner join
                ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid and ndb.taxa.taxonid = ndb.ecolgroups.taxonid
        where (ndb.samples.datasetid = @datasetid)
        order by taxonname, ndb.analysisunits.depth
	  end

    if (@datasettypeid in(3,9,11)) -- pollen, ostracodes, diatoms
	  begin
	    -- add zero values -- will also add zero place holder values for lumped and summed taxa
	    set @itr = (select min(id) from @toptaxa)
        set @maxid = (select max(id) from @toptaxa)
	    while (@itr <= @maxid)
          begin
	        set @taxonname = (select taxonname from @toptaxa where (id = @itr))
		    set @ecolgroupid = (select ecolgroupid from @toptaxa where (id = @itr))

		    insert into @taxadepths (depth)
		    select depth from @data where (taxonname = @taxonname)

		    insert into @tempdata (depth, taxonname, ecolgroupid)
		    select depth, @taxonname, @ecolgroupid
            from @depths
            where not exists (select depth from @taxadepths where [@depths].depth = [@taxadepths].depth)

		    update @tempdata
            set [@tempdata].sampleid = [@depths].sampleid
            from @depths
            where ([@depths].depth = [@tempdata].depth)

		    insert into @data(sampleid, taxonname, ecolgroupid, value, depth)
            select sampleid, taxonname, ecolgroupid, value, depth
            from   @tempdata

		    delete from @tempdata where (id <= (select max(id) from @tempdata))
		    delete from @taxadepths where (id <= (select max(id) from @taxadepths))
	        set @itr = @itr + 1
	      end

        -- add summed taxa

	    -- get list of all sums: grouped taxa + others
	    insert into @allsums (sumname)
        select sumname from @summedtaxa group by sumname

	    set @itr = (select min(id) from @allsums)
        set @maxid = (select max(id) from @allsums)
	    while (@itr <= @maxid)
          begin
	        set @lumpedtaxon = (select sumname from @allsums where (id = @itr))
	        delete from @taxalist where (id <= (select max(id) from @taxalist))
		    insert into @taxalist (taxonname) select taxonname from @summedtaxa where (sumname = @lumpedtaxon)
		    set @sqltext = n''
		    set @minid = (select min(id) from @taxalist)
		    set @itr1 = @minid
            set @maxid1 = (select max(id) from @taxalist)
		    while (@itr1 <= @maxid1)
              begin
		        if (@itr1 > @minid)
			      set @sqltext = @sqltext + n', '
                set @taxonname = (select taxonname from @taxalist where (id = @itr1))
			    set @sqltext = @sqltext + n'n''' + @taxonname + n''''
			    set @itr1 = @itr1 + 1
		      end
            update @allsums set sumstr = @sqltext where (id = @itr)
		    set @itr = @itr + 1
	      end

        set @itr = (select min(id) from @allsums)
        set @maxid = (select max(id) from @allsums)
        while (@itr <= @maxid)
          begin
	        set @lumpedtaxon = (select sumname from @allsums where (id = @itr))
		    set @sqltext = (select sumstr from @allsums where (id = @itr))

		    if (@datasettypeid = 3) -- pollen
		      begin
		        set @sql = n'select top (100) percent ndb.data.sampleid, sum(ndb.data.value)
                           from ndb.samples inner join
                              ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                              ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                              ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid
                           where (ndb.taxa.taxonname in (' + @sqltext + n')) and
		                      ((ndb.variables.variableelementid = 141 and ndb.variables.variablecontextid is null) or
							  (ndb.variables.variableelementid = 166 and ndb.variables.variablecontextid is null)) and
						      ((ndb.variables.variableunitsid = 19 or ndb.variables.variableunitsid = 28))
                           group by ndb.samples.datasetid, ndb.data.sampleid
                           having (ndb.samples.datasetid = @datasetid)'
		      end
            else if (@datasettypeid = 9 or @datasettypeid = 11) -- ostracodes, diatoms
		      begin
		        set @sql = n'select top (100) percent ndb.data.sampleid, sum(ndb.data.value)
                           from ndb.samples inner join
                              ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                              ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                              ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid
                           where (ndb.taxa.taxonname in (' + @sqltext + n')) and
						      ((ndb.variables.variableunitsid = 19 or ndb.variables.variableunitsid = 28))
                           group by ndb.samples.datasetid, ndb.data.sampleid
                           having (ndb.samples.datasetid = @datasetid)'
		      end

		    insert into @sumvalues (sampleid, value)
		    exec sp_executesql @sql, n'@datasetid int', @datasetid
		    update @sumvalues set sumname = @lumpedtaxon where (sumname is null)
		    set @itr = @itr + 1
	      end

	    update @data
        set [@data].value = [@sumvalues].value
        from @sumvalues
        where ([@data].sampleid = [@sumvalues].sampleid) and ([@data].taxonname = [@sumvalues].sumname)
	  end
  end

-- get data by age

insert into @chrons (chronologyid, nages)
select ndb.sampleages.chronologyid, count(ndb.sampleages.sampleid) as nages
from   ndb.samples inner join
         ndb.sampleages on ndb.samples.sampleid = ndb.sampleages.sampleid
where  (ndb.samples.datasetid = @datasetid)
group by ndb.sampleages.chronologyid

set @itr = (select min(id) from @chrons)
set @maxid = (select max(id) from @chrons)
while (@itr <= @maxid)
  begin
    set @nages = (select nages from @chrons where (id = @itr))
	if (@nages = @nsamples)
	  begin
        set @dataminid = (select max(id) from @data)
		if (@dataminid is null)
		  set @dataminid = 1
        else
		  set @dataminid = @dataminid + 1

		set @chronid = (select chronologyid from @chrons where (id = @itr))
		set @chronname = (select chronologyname from ndb.chronologies where (chronologyid = @chronid))

		if ((select count(*) from @data) > 0)  -- samples by depth or another chron already exist
		  begin
		    insert into @tempdata (sampleid, taxonname, units, ecolgroupid, value, depth, chronologyid, chronologyname)
			select sampleid, taxonname, units, ecolgroupid, value, depth, @chronid, @chronname
            from   @data
            group by sampleid, taxonname, units, ecolgroupid, value, depth
			order by taxonname, depth

			update @tempdata
            set [@tempdata].age = ndb.sampleages.age
            from ndb.sampleages
            where (([@tempdata].sampleid = ndb.sampleages.sampleid) and ([@tempdata].chronologyid = ndb.sampleages.chronologyid))

			insert into @data(sampleid, taxonname, units, ecolgroupid, value, depth, chronologyid, chronologyname, age)
            select sampleid, taxonname, units, ecolgroupid, value, depth, chronologyid, chronologyname, age
            from   @tempdata

			delete from @tempdata where (id <= (select max(id) from @tempdata))
		  end
	  end
	set @itr = @itr + 1
  end

if (@datasettypeid in(3,9,11))
  begin
    select sampleid, taxonname, ecolgroupid, value, depth, chronologyid, chronologyname, age
    from @data
    order by chronologyid, taxonname, age, depth
  end
else if (@datasettypeid = 2)
  begin
    select sampleid, taxonname, units, ecolgroupid, value, depth, chronologyid, chronologyname, age
    from @data
    order by chronologyid, taxonname, age, depth
  end
go

-- ----------------------------
-- procedure structure for getdatasettypes
-- ----------------------------

create procedure [getdatasettypes]
as select     datasettypeid, datasettype
from          ndb.datasettypes


go

-- ----------------------------
-- procedure structure for getdatasettypesbyname
-- ----------------------------




create procedure [getdatasettypesbyname](@datasettype nvarchar(64))
as
declare @dt nvarchar(80) = @datasettype + n'%'
select     datasettypeid, datasettype
from         ndb.datasettypes
where     (datasettype like @dt)







go

-- ----------------------------
-- procedure structure for getdatasettypesbytaxagroupid
-- ----------------------------



create procedure [getdatasettypesbytaxagroupid](@taxagroupid nvarchar(3))
as
select     ndb.datasettaxagrouptypes.datasettypeid, ndb.datasettypes.datasettype
from         ndb.datasettaxagrouptypes inner join
                      ndb.datasettypes on ndb.datasettaxagrouptypes.datasettypeid = ndb.datasettypes.datasettypeid
where     (ndb.datasettaxagrouptypes.taxagroupid = @taxagroupid)






go

-- ----------------------------
-- procedure structure for getdatasettypeshavingdata
-- ----------------------------


create procedure [getdatasettypeshavingdata]
as
select     ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype
from         ndb.datasettypes inner join
                      ndb.datasets on ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid
group by ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype



go

-- ----------------------------
-- procedure structure for getdatasetvariables
-- ----------------------------



create procedure [getdatasetvariables](@datasetid int)
as
select     ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement, ndb.variableunits.variableunits,
                      ndb.variablecontexts.variablecontext
from         ndb.variableelements right outer join
                      ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid left outer join
                      ndb.variablecontexts on ndb.variables.variablecontextid = ndb.variablecontexts.variablecontextid left outer join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid on
                      ndb.variableelements.variableelementid = ndb.variables.variableelementid
where     (ndb.samples.datasetid = @datasetid)
group by ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement, ndb.variableunits.variableunits,
                      ndb.variablecontexts.variablecontext




go

-- ----------------------------
-- procedure structure for getdatasetvariablesynonyms
-- ----------------------------



create procedure [getdatasetvariablesynonyms](@datasetid int, @variableid int)
as
select     top (100) percent ndb.synonymy.synonymyid, ndb.taxa.taxonname as reftaxonname, ndb.synonymy.fromcontributor, ndb.synonymy.publicationid,
                      ndb.synonymy.notes
from         ndb.synonymy inner join
                      ndb.taxa on ndb.synonymy.reftaxonid = ndb.taxa.taxonid inner join
                      ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid on ndb.synonymy.datasetid = ndb.samples.datasetid and
                      ndb.synonymy.taxonid = ndb.variables.taxonid
where     (ndb.samples.datasetid = @datasetid) and (ndb.data.variableid = @variableid)
group by ndb.synonymy.synonymyid, ndb.taxa.taxonname, ndb.synonymy.publicationid, ndb.synonymy.notes, ndb.synonymy.fromcontributor
order by ndb.synonymy.synonymyid




go

-- ----------------------------
-- procedure structure for getdatasetvariableunits
-- ----------------------------




create procedure [getdatasetvariableunits](@datasetid int)
as
select     top (100) percent ndb.variableunits.variableunitsid, ndb.variableunits.variableunits
from         ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid
group by ndb.datasets.datasetid, ndb.variableunits.variableunits, ndb.variableunits.variableunitsid
having      (ndb.datasets.datasetid = @datasetid)


go

-- ----------------------------
-- procedure structure for getdepagentbyname
-- ----------------------------


create procedure [getdepagentbyname](@depagent nvarchar(64))
as
select      depagentid, depagent
from          ndb.depagenttypes
where      (depagent = @depagent)



go

-- ----------------------------
-- procedure structure for getdepagentstypestable
-- ----------------------------



create procedure [getdepagentstypestable]
as select     depagentid, depagent
from          ndb.depagenttypes






go

-- ----------------------------
-- procedure structure for getdepenvtbyid
-- ----------------------------






create procedure [getdepenvtbyid](@depenvtid int)
as
select     depenvtid, depenvt, depenvthigherid
from         ndb.depenvttypes
where     (depenvtid = @depenvtid)







go

-- ----------------------------
-- procedure structure for getdepenvttypestable
-- ----------------------------

create procedure [getdepenvttypestable]
as select      depenvtid, depenvt, depenvthigherid
from          ndb.depenvttypes




go

-- ----------------------------
-- procedure structure for getecolgroupsbyecolsetid
-- ----------------------------





create procedure [getecolgroupsbyecolsetid](@ecolsetid int)
as
select     top (100) percent ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
from         ndb.ecolgrouptypes inner join
                      ndb.ecolgroups on ndb.ecolgrouptypes.ecolgroupid = ndb.ecolgroups.ecolgroupid
group by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
having      (ndb.ecolgroups.ecolsetid = @ecolsetid)
order by ndb.ecolgroups.ecolgroupid







go

-- ----------------------------
-- procedure structure for getecolgroupsbytaxagroupidlist
-- ----------------------------



create procedure [getecolgroupsbytaxagroupidlist](@taxagrouplist nvarchar(max))
as
select ndb.ecolgroups.*
from         ndb.ecolgroups inner join ndb.taxa on ndb.ecolgroups.taxonid = ndb.taxa.taxonid
where     (ndb.taxa.taxagroupid in (
		                           select value
		                           from ti.func_nvarcharlisttoin(@taxagrouplist,'$')
                                   ))





go

-- ----------------------------
-- procedure structure for getecolgroupsbyvariableidlist
-- ----------------------------




create procedure [getecolgroupsbyvariableidlist](@variableids nvarchar(max))
as
select     ndb.variables.variableid, ndb.taxa.taxagroupid, ndb.ecolsettypes.ecolsetname, ndb.ecolgrouptypes.ecolgroupid
from         ndb.variables inner join
                      ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
                      ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
                      ndb.ecolgrouptypes on ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid inner join
                      ndb.ecolsettypes on ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid
where     (ndb.variables.variableid in (
                                       select value
                                       from ti.func_intlisttoin(@variableids,'$')
                                       ))







go

-- ----------------------------
-- procedure structure for getecolgroupstable
-- ----------------------------

create procedure [getecolgroupstable]
as select      taxonid, ecolsetid, ecolgroupid
from          ndb.ecolgroups



go

-- ----------------------------
-- procedure structure for getecolgrouptypestable
-- ----------------------------



create procedure [getecolgrouptypestable]
as select      ecolgroupid, ecolgroup
from          ndb.ecolgrouptypes





go

-- ----------------------------
-- procedure structure for getecolsetcountsbytaxagroupid
-- ----------------------------





create procedure [getecolsetcountsbytaxagroupid](@taxagroupid nvarchar(3))
as
select     top (100) percent ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname, count(*) as count
from         ndb.ecolgroups inner join
                      ndb.taxa on ndb.ecolgroups.taxonid = ndb.taxa.taxonid inner join
                      ndb.ecolsettypes on ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid
group by ndb.taxa.taxagroupid, ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname
having      (ndb.taxa.taxagroupid = @taxagroupid)
order by ndb.ecolsettypes.ecolsetname






go

-- ----------------------------
-- procedure structure for getecolsetsgroupsbytaxonid
-- ----------------------------




create procedure [getecolsetsgroupsbytaxonid](@taxonid int)
as
select     top (100) percent ndb.ecolgroups.taxonid, ndb.ecolgroups.ecolsetid, ndb.ecolsettypes.ecolsetname, ndb.ecolgroups.ecolgroupid,
                      ndb.ecolgrouptypes.ecolgroup
from         ndb.ecolgroups inner join
                      ndb.ecolsettypes on ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid inner join
                      ndb.ecolgrouptypes on ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid
where     (ndb.ecolgroups.taxonid = @taxonid)
order by ndb.ecolgroups.ecolsetid, ndb.ecolgroups.ecolgroupid






go

-- ----------------------------
-- procedure structure for getecolsettypestable
-- ----------------------------


create procedure [getecolsettypestable]
as select     ecolsetid, ecolsetname
from          ndb.ecolsettypes




go

-- ----------------------------
-- procedure structure for getelementdatasettaxagroupcount
-- ----------------------------




create procedure [getelementdatasettaxagroupcount](@datasettypeid int, @taxagroupid nvarchar(3), @elementtypeid int)
as
select     count(elementtypeid) as count
from         ndb.elementdatasettaxagroups
where     (datasettypeid = @datasettypeid) and (taxagroupid = @taxagroupid) and (elementtypeid = @elementtypeid)



go

-- ----------------------------
-- procedure structure for getelementdatasettaxagroupstable
-- ----------------------------


create procedure [getelementdatasettaxagroupstable]
as
select     top (2147483647) datasettypeid, taxagroupid, elementtypeid
from         ndb.elementdatasettaxagroups
order by datasettypeid, taxagroupid, elementtypeid



go

-- ----------------------------
-- procedure structure for getelementmaturitiestable
-- ----------------------------





create procedure [getelementmaturitiestable]
as select     maturityid, maturity
from          ndb.elementmaturities







go

-- ----------------------------
-- procedure structure for getelementmaturitybyname
-- ----------------------------



create procedure [getelementmaturitybyname](@maturity nvarchar(36))
as
select      maturityid, maturity
from          ndb.elementmaturities
where      (maturity = @maturity)





go

-- ----------------------------
-- procedure structure for getelementpartid
-- ----------------------------




create procedure [getelementpartid](@partname nvarchar(36))
as
declare @elementparts table
(
  symmetryid int,
  portionid int,
  maturityid int
)

insert into @elementparts (symmetryid)
  select  ndb.elementsymmetries.symmetryid
  from    ndb.elementsymmetries
  where   ndb.elementsymmetries.symmetry = @partname
insert into @elementparts (portionid)
  select  ndb.elementportions.portionid
  from    ndb.elementportions
  where   ndb.elementportions.portion = @partname
insert into @elementparts (maturityid)
  select  ndb.elementmaturities.maturityid
  from    ndb.elementmaturities
  where   ndb.elementmaturities.maturity = @partname

select symmetryid, portionid, maturityid
from @elementparts


go

-- ----------------------------
-- procedure structure for getelementportionbyname
-- ----------------------------



create procedure [getelementportionbyname](@portion nvarchar(48))
as
select      portionid, portion
from          ndb.elementportions
where      (portion = @portion)





go

-- ----------------------------
-- procedure structure for getelementportionstable
-- ----------------------------





create procedure [getelementportionstable]
as
select      portionid, portion
from        ndb.elementportions







go

-- ----------------------------
-- procedure structure for getelementsbytaxonid
-- ----------------------------



create procedure [getelementsbytaxonid](@taxonid int)
as
select     top (100) percent ndb.variableelements.variableelementid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion,
                      ndb.elementmaturities.maturity
from         ndb.variables inner join
                      ndb.variableelements on ndb.variables.variableelementid = ndb.variableelements.variableelementid left outer join
                      ndb.elementmaturities on ndb.variableelements.maturityid = ndb.elementmaturities.maturityid left outer join
                      ndb.elementportions on ndb.variableelements.portionid = ndb.elementportions.portionid left outer join
                      ndb.elementsymmetries on ndb.variableelements.symmetryid = ndb.elementsymmetries.symmetryid left outer join
                      ndb.elementtypes on ndb.variableelements.elementtypeid = ndb.elementtypes.elementtypeid
group by ndb.variables.taxonid, ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity,
                      ndb.variableelements.variableelementid
having      (ndb.variables.taxonid = @taxonid)
order by ndb.elementtypes.elementtype, ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity




go

-- ----------------------------
-- procedure structure for getelementsymmetriestable
-- ----------------------------





create procedure [getelementsymmetriestable]
as select     symmetryid, symmetry
from          ndb.elementsymmetries







go

-- ----------------------------
-- procedure structure for getelementsymmetrybyname
-- ----------------------------



create procedure [getelementsymmetrybyname](@symmetry nvarchar(24))
as
select      symmetryid, symmetry
from          ndb.elementsymmetries
where      (symmetry = @symmetry)





go

-- ----------------------------
-- procedure structure for getelementtaxagroupid
-- ----------------------------






create procedure [getelementtaxagroupid](@taxagroupid nvarchar(3), @elementtypeid int)
as
select     elementtaxagroupid
from         ndb.elementtaxagroups
where     (taxagroupid = @taxagroupid) and (elementtypeid = @elementtypeid)








go

-- ----------------------------
-- procedure structure for getelementtaxagroupmaturitiestable
-- ----------------------------





create procedure [getelementtaxagroupmaturitiestable]
as select     elementtaxagroupid, maturityid
from          ndb.elementtaxagroupmaturities







go

-- ----------------------------
-- procedure structure for getelementtaxagroupportionstable
-- ----------------------------





create procedure [getelementtaxagroupportionstable]
as select     elementtaxagroupid, portionid
from          ndb.elementtaxagroupportions







go

-- ----------------------------
-- procedure structure for getelementtaxagroupstable
-- ----------------------------






create procedure [getelementtaxagroupstable]
as select     elementtaxagroupid, taxagroupid, elementtypeid
from          ndb.elementtaxagroups








go

-- ----------------------------
-- procedure structure for getelementtaxagroupsymmetriestable
-- ----------------------------





create procedure [getelementtaxagroupsymmetriestable]
as select     elementtaxagroupid, symmetryid
from          ndb.elementtaxagroupsymmetries







go

-- ----------------------------
-- procedure structure for getelementtypebydatasettypeid
-- ----------------------------





create procedure [getelementtypebydatasettypeid](@datasettypeid int)
as
select     top (100) percent ndb.elementtypes.elementtypeid, ndb.elementtypes.elementtype, ndb.elementdatasettaxagroups.taxagroupid
from         ndb.elementdatasettaxagroups inner join
                      ndb.elementtypes on ndb.elementdatasettaxagroups.elementtypeid = ndb.elementtypes.elementtypeid
where     (ndb.elementdatasettaxagroups.datasettypeid = 5)
order by ndb.elementdatasettaxagroups.taxagroupid, ndb.elementtypes.elementtype






go

-- ----------------------------
-- procedure structure for getelementtypebyname
-- ----------------------------


create procedure [getelementtypebyname](@elementtype nvarchar(64))
as
select      elementtypeid, elementtype
from          ndb.elementtypes
where      (elementtype = @elementtype)




go

-- ----------------------------
-- procedure structure for getelementtypefromvariableelement
-- ----------------------------



create procedure [getelementtypefromvariableelement](@variableelement nvarchar(64))
as
declare @semicolon nvarchar(1) = n';'
if charindex(n';',@variableelement) = 0
  begin
    select elementtypeid, elementtype
    from   ndb.elementtypes
	where  (elementtype = @variableelement)
  end
else
  begin
    select top(1) elementtypeid, elementtype
    from  ndb.elementtypes
    where (elementtype = left(@variableelement, len(elementtype)) and substring(@variableelement, len(elementtype)+1, 1) = @semicolon)
    order by len(elementtype) desc
  end

go

-- ----------------------------
-- procedure structure for getelementtypesbynamelist
-- ----------------------------



create procedure [getelementtypesbynamelist](@elementtypes nvarchar(max))
as
select elementtypeid, elementtype
from ndb.elementtypes
where (elementtype in (
		            select value
		            from ti.func_nvarcharlisttoin(@elementtypes,'$')
                    ))





go

-- ----------------------------
-- procedure structure for getelementtypesbytaxagroupid
-- ----------------------------




create procedure [getelementtypesbytaxagroupid](@taxagroupid nvarchar(3))
as
select     ndb.elementtaxagroups.elementtypeid, ndb.elementtypes.elementtype
from         ndb.elementtaxagroups inner join
                      ndb.elementtypes on ndb.elementtaxagroups.elementtypeid = ndb.elementtypes.elementtypeid
where     (ndb.elementtaxagroups.taxagroupid = @taxagroupid)




go

-- ----------------------------
-- procedure structure for getelementtypestable
-- ----------------------------




create procedure [getelementtypestable]
as select      elementtypeid, elementtype
from          ndb.elementtypes






go

-- ----------------------------
-- procedure structure for geteventbyname
-- ----------------------------





create procedure [geteventbyname](@eventname nvarchar(80))
as
select     eventid, eventtypeid, eventname, c14age, c14ageolder, c14ageyounger, calage, calageyounger, calageolder, notes
from         ndb.events
where     (eventname = @eventname)


go

-- ----------------------------
-- procedure structure for geteventchroncontroltypeid
-- ----------------------------



create procedure [geteventchroncontroltypeid](@eventname nvarchar(80))
as
select     ndb.events.eventid, ndb.eventtypes.chroncontroltypeid
from         ndb.eventtypes inner join
                      ndb.events on ndb.eventtypes.eventtypeid = ndb.events.eventtypeid
where     (ndb.events.eventname = @eventname)




go

-- ----------------------------
-- procedure structure for geteventpublications
-- ----------------------------





create procedure [geteventpublications](@eventid int)
as
select      ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle,
                      ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi,
                      ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle,
                      ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country,
                      ndb.publications.originallanguage, ndb.publications.notes
from         ndb.eventpublications inner join
                      ndb.publications on ndb.eventpublications.publicationid = ndb.publications.publicationid
where     (ndb.eventpublications.eventid = @eventid)


go

-- ----------------------------
-- procedure structure for geteventsbychronologyid
-- ----------------------------




create procedure [geteventsbychronologyid](@chronologyid int)
as
select     ndb.eventchronology.chroncontrolid, ndb.events.eventname
from         ndb.chroncontrols inner join
                      ndb.chronologies on ndb.chroncontrols.chronologyid = ndb.chronologies.chronologyid inner join
                      ndb.eventchronology on ndb.chroncontrols.chroncontrolid = ndb.eventchronology.chroncontrolid inner join
                      ndb.events on ndb.eventchronology.eventid = ndb.events.eventid
where     (ndb.chronologies.chronologyid = @chronologyid) and (ndb.eventchronology.chroncontrolid is not null)




go

-- ----------------------------
-- procedure structure for geteventstable
-- ----------------------------




create procedure [geteventstable]
as
select     eventid, eventtypeid, eventname, c14age, c14ageolder, c14ageyounger, calage, calageyounger, calageolder, notes
from          ndb.events

go

-- ----------------------------
-- procedure structure for geteventtypebyname
-- ----------------------------






create procedure [geteventtypebyname](@eventtype nvarchar(40))
as
select     eventtypeid, eventtype
from         ndb.eventtypes
where     (eventtype = @eventtype)



go

-- ----------------------------
-- procedure structure for geteventtypestable
-- ----------------------------



create procedure [geteventtypestable]
as select      eventtypeid, eventtype, chroncontroltypeid
from          ndb.eventtypes






go

-- ----------------------------
-- procedure structure for getfaciestypebyname
-- ----------------------------




create procedure [getfaciestypebyname](@facies nvarchar(64))
as
select      faciesid, facies
from          ndb.faciestypes
where      (facies = @facies)






go

-- ----------------------------
-- procedure structure for getfaciestypestable
-- ----------------------------


create procedure [getfaciestypestable]
as select      faciesid, facies
from          ndb.faciestypes





go

-- ----------------------------
-- procedure structure for getfaunmap1relativeagesbychroncontrolidlist
-- ----------------------------



create procedure [getfaunmap1relativeagesbychroncontrolidlist](@chroncontrolids nvarchar(max))
as
select     ndb.chroncontrols.chroncontrolid, ndb.relativeagescales.relativeagescale, ndb.relativeageunits.relativeageunit, ndb.relativeages.relativeage,
                      ndb.relativeages.c14ageolder, ndb.relativeages.c14ageyounger, ndb.relativeages.calageolder, ndb.relativeages.calageyounger
from         ndb.relativechronology inner join
                      ndb.relativeages on ndb.relativechronology.relativeageid = ndb.relativeages.relativeageid inner join
                      ndb.chroncontrols on ndb.relativechronology.analysisunitid = ndb.chroncontrols.analysisunitid inner join
                      ndb.relativeagescales on ndb.relativeages.relativeagescaleid = ndb.relativeagescales.relativeagescaleid inner join
                      ndb.relativeageunits on ndb.relativeages.relativeageunitid = ndb.relativeageunits.relativeageunitid
where (chroncontrolid in (
		                 select value
		                 from ti.func_nvarcharlisttoin(@chroncontrolids,'$')
                         ))





go

-- ----------------------------
-- procedure structure for getfractiondatedtable
-- ----------------------------



create procedure [getfractiondatedtable]
as select      ndb.fractiondated.*
from          ndb.fractiondated






go

-- ----------------------------
-- procedure structure for getfractionsdatedbylist
-- ----------------------------



create procedure [getfractionsdatedbylist](@fractions nvarchar(max))
as
select fractionid, fraction
from ndb.fractiondated
where (fraction in (
		            select value
		            from ti.func_nvarcharlisttoin(@fractions,'$')
                    ))





go

-- ----------------------------
-- procedure structure for getgeochronanalysisunit
-- ----------------------------




create procedure [getgeochronanalysisunit](@geochronid int)
as
select     ndb.samples.sampleid, ndb.analysisunits.collectionunitid, ndb.analysisunits.analysisunitid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth,
             ndb.analysisunits.thickness
from       ndb.geochronology inner join
                      ndb.samples on ndb.geochronology.sampleid = ndb.samples.sampleid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
where     (ndb.geochronology.geochronid = @geochronid)






go

-- ----------------------------
-- procedure structure for getgeochronbydatasetid
-- ----------------------------




create procedure [getgeochronbydatasetid](@datasetid int)
as
select     ndb.geochronology.geochronid, ndb.geochronology.geochrontypeid, ndb.geochrontypes.geochrontype, ndb.agetypes.agetype, ndb.analysisunits.depth,
                      ndb.analysisunits.thickness, ndb.analysisunits.analysisunitname, ndb.geochronology.age, ndb.geochronology.errorolder, ndb.geochronology.erroryounger,
                      ndb.geochronology.infinite, ndb.geochronology.labnumber, ndb.geochronology.materialdated, ndb.geochronology.notes
from         ndb.geochronology inner join
                      ndb.samples on ndb.geochronology.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid inner join
                      ndb.geochrontypes on ndb.geochronology.geochrontypeid = ndb.geochrontypes.geochrontypeid inner join
                      ndb.agetypes on ndb.geochronology.agetypeid = ndb.agetypes.agetypeid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
where     (ndb.datasets.datasetid = @datasetid)






go

-- ----------------------------
-- procedure structure for getgeochronbygeochronid
-- ----------------------------





create procedure [getgeochronbygeochronid](@geochronid int)
as
select     sampleid, geochrontypeid, agetypeid, age, errorolder, erroryounger, infinite, labnumber, materialdated, notes
from       ndb.geochronology
where     (geochronid = @geochronid)





go

-- ----------------------------
-- procedure structure for getgeochroncontrolcount
-- ----------------------------




-- gets number of chroncontrols assigned to geochronid
create procedure [getgeochroncontrolcount](@geochronid int)
as
select     count(chroncontrolid) as count
from       ndb.geochroncontrols
where     (geochronid = @geochronid)



go

-- ----------------------------
-- procedure structure for getgeochroncontrolsbychronologyid
-- ----------------------------




create procedure [getgeochroncontrolsbychronologyid](@chronologyid int)
as
select     ndb.geochroncontrols.chroncontrolid, ndb.geochroncontrols.geochronid
from         ndb.geochroncontrols inner join
                      ndb.chroncontrols on ndb.geochroncontrols.chroncontrolid = ndb.chroncontrols.chroncontrolid
where     (ndb.chroncontrols.chronologyid = @chronologyid)





go

-- ----------------------------
-- procedure structure for getgeochroncounts
-- ----------------------------





create procedure [getgeochroncounts]
as
select     top (100) percent ndb.geochrontypes.geochrontype, count(ndb.geochrontypes.geochrontype) as count
from         ndb.geochronology inner join
                      ndb.geochrontypes on ndb.geochronology.geochrontypeid = ndb.geochrontypes.geochrontypeid
group by ndb.geochrontypes.geochrontype
order by count desc






go

-- ----------------------------
-- procedure structure for getgeochronidcount
-- ----------------------------




-- gets number of samples assigned to analysis unit
create procedure [getgeochronidcount](@geochronid int)
as
select     count(geochronid) as count
from       ndb.radiocarbon
where     (geochronid = @geochronid)




go

-- ----------------------------
-- procedure structure for getgeochrontypeid
-- ----------------------------





create procedure [getgeochrontypeid](@geochrontype nvarchar(64))
as
select     geochrontypeid
from       ndb.geochrontypes
where     (geochrontype = @geochrontype)







go

-- ----------------------------
-- procedure structure for getgeochrontypestable
-- ----------------------------



create procedure [getgeochrontypestable]
as select     geochrontypeid, geochrontype
from          ndb.geochrontypes






go

-- ----------------------------
-- procedure structure for getgeopolbysitename
-- ----------------------------

create procedure [getgeopolbysitename](@sitename nvarchar(128), @east float, @north float, @west float, @south float)
as
declare @site1 geography
if ((@north > @south) and (@east > @west))
  begin
    set @site1 = geography::stgeomfromtext('polygon((' +
                 cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
                 cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
			     cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			     cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			     cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + '))', 4326)
    end
else
  begin
    set @site1 = geography::stgeomfromtext('point(' + cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ')', 4326)
  end

  select   ndb.sites.siteid, ndb.sites.sitename, @site1.envelopecenter().stdistance(geography::stgeomfromtext(geog.tostring(), 4326).envelopecenter())/1000 as distkm,
           ti.geopol1.geopolname1 +
           iif(ti.geopol2.geopolname2 is not null, n'|' + ti.geopol2.geopolname2 +
		       iif(ti.geopol3.geopolname3 is not null, n'|' + ti.geopol3.geopolname3, n'') +
			   iif(ti.geopol4.geopolname4 is not null, n'|' + ti.geopol4.geopolname4, n''),n'') as geopolitical
  from     ndb.sites left outer join
                    ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid left outer join
                    ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid left outer join
                    ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                    ti.geopol4 on ndb.sites.siteid = ti.geopol4.siteid
  where   (ndb.sites.sitename like @sitename)
  order by distkm
go

-- ----------------------------
-- procedure structure for getgeopoliticalunitstable
-- ----------------------------

create procedure [getgeopoliticalunitstable]
as select     ndb.geopoliticalunits.*
from          ndb.geopoliticalunits



go

-- ----------------------------
-- procedure structure for getgeopolnumberofsubdivs
-- ----------------------------


create procedure [getgeopolnumberofsubdivs](@highergeopolid int)
as select      count(geopoliticalid) as numberofsubdivs
from          ndb.geopoliticalunits
group by highergeopoliticalid
having       (highergeopoliticalid = @highergeopolid)




go

-- ----------------------------
-- procedure structure for getgeopolunitbyhigherid
-- ----------------------------



create procedure [getgeopolunitbyhigherid](@highergeopolid int)
as select      geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
from          ndb.geopoliticalunits
where      (highergeopoliticalid = @highergeopolid)





go

-- ----------------------------
-- procedure structure for getgeopolunitbyid
-- ----------------------------



create procedure [getgeopolunitbyid](@geopolid int)
as select      geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
from          ndb.geopoliticalunits
where      (geopoliticalid = @geopolid)





go

-- ----------------------------
-- procedure structure for getgeopolunitbynameandhigherid
-- ----------------------------


create procedure [getgeopolunitbynameandhigherid](@geopolname nvarchar(255),
@highergeopolid int)
as select      geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
from          ndb.geopoliticalunits
where      (geopoliticalname = @geopolname) and (highergeopoliticalid = @highergeopolid)




go

-- ----------------------------
-- procedure structure for getgeopolunitbynameandrank
-- ----------------------------


create procedure [getgeopolunitbynameandrank](@geopolname nvarchar(255),
@rank int)
as select      geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
from          ndb.geopoliticalunits
where      (geopoliticalname = @geopolname) and (rank = @rank)




go

-- ----------------------------
-- procedure structure for getgeopolunitbyrank
-- ----------------------------



create procedure [getgeopolunitbyrank](@rank int)
as
select     top (100) percent geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
from         ndb.geopoliticalunits
where     (rank = @rank)
order by geopoliticalname





go

-- ----------------------------
-- procedure structure for getgeopolunitsbysiteid
-- ----------------------------


create procedure [getgeopolunitsbysiteid](@siteid int)
as select      ndb.geopoliticalunits.geopoliticalid, ndb.geopoliticalunits.geopoliticalname, ndb.geopoliticalunits.geopoliticalunit,
                        ndb.geopoliticalunits.rank, ndb.geopoliticalunits.highergeopoliticalid
from          ndb.sitegeopolitical inner join
                        ndb.geopoliticalunits on ndb.sitegeopolitical.geopoliticalid = ndb.geopoliticalunits.geopoliticalid
where      (ndb.sitegeopolitical.siteid = @siteid)
order by ndb.geopoliticalunits.rank




go

-- ----------------------------
-- procedure structure for getinvalidtaxabytaxagroupid
-- ----------------------------




create procedure [getinvalidtaxabytaxagroupid](@taxagroupid nvarchar(3))
as select      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid,
               convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (valid = 0) and (taxagroupid = @taxagroupid)






go

-- ----------------------------
-- procedure structure for getinvalidtaxabytaxagroupidlist
-- ----------------------------



create procedure [getinvalidtaxabytaxagroupidlist](@taxagrouplist nvarchar(max))
as
select     taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid,
           validatorid, convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (valid = 0) and (taxagroupid in (
		                    select value
		                    from ti.func_nvarcharlisttoin(@taxagrouplist,'$')
                            ))





go

-- ----------------------------
-- procedure structure for getinvalidtaxonbyname
-- ----------------------------


create procedure [getinvalidtaxonbyname](@taxonname nvarchar(80))
as select      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid,
               validatorid, convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (valid = 0) and (ndb.taxa.taxonname like @taxonname)







go

-- ----------------------------
-- procedure structure for getinvalidtaxonsynonymycount
-- ----------------------------


create procedure [getinvalidtaxonsynonymycount](@reftaxonid int)
as
select     count(reftaxonid) as count
from         ndb.synonymy
where     (reftaxonid = @reftaxonid)





go

-- ----------------------------
-- procedure structure for getinvestigator
-- ----------------------------






create procedure [getinvestigator](@datasetid int)
as
select     ndb.contacts.contactid, ndb.contacts.aliasid, ndb.contacts.contactname, ndb.contacts.contactstatusid, ndb.contacts.familyname,
                      ndb.contacts.leadinginitials, ndb.contacts.givennames, ndb.contacts.suffix, ndb.contacts.title, ndb.contacts.phone, ndb.contacts.fax, ndb.contacts.email,
                      ndb.contacts.url, ndb.contacts.address, ndb.contacts.notes
from         ndb.datasetpis inner join
                      ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
where     (ndb.datasetpis.datasetid = @datasetid)








go

-- ----------------------------
-- procedure structure for getisobiomarkers
-- ----------------------------






create procedure [getisobiomarkers]
as
select     top (100) percent ndb.isobiomarkertypes.isobiomarkertype, ndb.isobiomarkerbandtypes.isobiomarkerbandtype
from         ndb.isobiomarkertypes inner join
                      ndb.isobiomarkerbandtypes on ndb.isobiomarkertypes.isobiomarkertypeid = ndb.isobiomarkerbandtypes.isobiomarkertypeid
order by ndb.isobiomarkertypes.isobiomarkertype, ndb.isobiomarkerbandtypes.isobiomarkerbandtype

go

-- ----------------------------
-- procedure structure for getisoinstrumentationtypes
-- ----------------------------


create procedure [getisoinstrumentationtypes]
as
select     isoinstrumentationtypeid, isoinstrumentationtype
from         ndb.isoinstrumentationtypes
go

-- ----------------------------
-- procedure structure for getisomaterialanalyzedandsubstrate
-- ----------------------------





create procedure [getisomaterialanalyzedandsubstrate]
as
select     top (100) percent ndb.isomaterialanalyzedtypes.isomaterialanalyzedtype, ndb.isosubstratetypes.isosubstratetype
from         ndb.isomaterialanalyzedtypes inner join
                      ndb.isomatanalsubstrate on ndb.isomaterialanalyzedtypes.isomatanaltypeid = ndb.isomatanalsubstrate.isomatanaltypeid inner join
                      ndb.isosubstratetypes on ndb.isomatanalsubstrate.isosubstratetypeid = ndb.isosubstratetypes.isosubstratetypeid
order by ndb.isomaterialanalyzedtypes.isomaterialanalyzedtype, ndb.isosubstratetypes.isosubstratetype



go

-- ----------------------------
-- procedure structure for getisomaterialanalyzedtypes
-- ----------------------------



create procedure [getisomaterialanalyzedtypes]
as
select     isomatanaltypeid, isomaterialanalyzedtype
from         ndb.isomaterialanalyzedtypes




go

-- ----------------------------
-- procedure structure for getisopretreatmenttypes
-- ----------------------------






create procedure [getisopretreatmenttypes]
as
select     isopretreatmenttypeid, isopretreatmenttype, isopretreatmentqualifier
from         ndb.isopretratmenttypes







go

-- ----------------------------
-- procedure structure for getisosampleintrosystemtypes
-- ----------------------------








create procedure [getisosampleintrosystemtypes]
as
select     isosampleintrosystemtypeid, isosampleintrosystemtype
from         ndb.isosampleintrosystemtypes









go

-- ----------------------------
-- procedure structure for getisosampleorigintypes
-- ----------------------------







create procedure [getisosampleorigintypes]
as
select     isosampleorigintypeid, isosampleorigintype
from         ndb.isosampleorigintypes








go

-- ----------------------------
-- procedure structure for getisostandardtypes
-- ----------------------------




create procedure [getisostandardtypes]
as
select     isostandardtypeid, isostandardtype, isostandardmaterial
from         ndb.isostandardtypes










go

-- ----------------------------
-- procedure structure for getisosubstrates
-- ----------------------------



create procedure [getisosubstrates]
as
select     top (100) percent ndb.isosubstratetypes.isosubstratetypeid, ndb.isomaterialanalyzedtypes.isomatanaltypeid, ndb.isosubstratetypes.isosubstratetype
from         ndb.isomaterialanalyzedtypes inner join
                      ndb.isomatanalsubstrate on ndb.isomaterialanalyzedtypes.isomatanaltypeid = ndb.isomatanalsubstrate.isomatanaltypeid inner join
                      ndb.isosubstratetypes on ndb.isomatanalsubstrate.isosubstratetypeid = ndb.isosubstratetypes.isosubstratetypeid
order by ndb.isosubstratetypes.isosubstratetypeid


go

-- ----------------------------
-- procedure structure for getisovariablescaleids
-- ----------------------------




create procedure [getisovariablescaleids]
as
select     ndb.taxa.taxonname as isovariable, ndb.isovariablescaletypes.isoscaletypeid, ndb.isoscaletypes.isoscaleacronym
from         ndb.isovariablescaletypes inner join
                      ndb.isoscaletypes on ndb.isovariablescaletypes.isoscaletypeid = ndb.isoscaletypes.isoscaletypeid inner join
                      ndb.taxa inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid on ndb.isovariablescaletypes.variableid = ndb.variables.variableid
order by isovariable

go

-- ----------------------------
-- procedure structure for getisovariablescaletypes
-- ----------------------------



create procedure [getisovariablescaletypes]
as
select     top (100) percent ndb.taxa.taxonname as isovariable, ndb.isoscaletypes.isoscaleacronym
from         ndb.isovariablescaletypes inner join
                      ndb.isoscaletypes on ndb.isovariablescaletypes.isoscaletypeid = ndb.isoscaletypes.isoscaletypeid inner join
                      ndb.taxa inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid on ndb.isovariablescaletypes.variableid = ndb.variables.variableid
order by ndb.taxa.taxonname, ndb.isoscaletypes.isoscaleacronym


go

-- ----------------------------
-- procedure structure for getkeywordstable
-- ----------------------------


create procedure [getkeywordstable]
as select     keywordid, keyword
from          ndb.keywords





go

-- ----------------------------
-- procedure structure for getlakeparametertypestable
-- ----------------------------


create procedure [getlakeparametertypestable]
as select      *
from          ndb.lakeparametertypes




go

-- ----------------------------
-- procedure structure for getlakeparamsbysiteid
-- ----------------------------



create procedure [getlakeparamsbysiteid](@siteid int)
as
select     ndb.lakeparametertypes.lakeparameter, ndb.lakeparameters.value
from         ndb.lakeparameters inner join
                      ndb.lakeparametertypes on ndb.lakeparameters.lakeparameterid = ndb.lakeparametertypes.lakeparameterid
where     (ndb.lakeparameters.siteid = @siteid)
order by ndb.lakeparametertypes.lakeparameter




go

-- ----------------------------
-- procedure structure for getlithologybycollunitid
-- ----------------------------



create procedure [getlithologybycollunitid](@collunitid int)
as
select    lithologyid, depthtop, depthbottom, lowerboundary, description
from      ndb.lithology
where     (collectionunitid = @collunitid)

go

-- ----------------------------
-- procedure structure for getmaxpubidbypubidtype
-- ----------------------------




create procedure [getmaxpubidbypubidtype](@pubtypeid int)
as
select     max(publicationid) as maxpubid
from         ndb.publications
group by pubtypeid
having      (pubtypeid = @pubtypeid)






go

-- ----------------------------
-- procedure structure for getminpubidbypubidtype
-- ----------------------------




create procedure [getminpubidbypubidtype](@pubtypeid int)
as
select     min(publicationid) as minpubid
from         ndb.publications
group by pubtypeid
having      (pubtypeid = @pubtypeid)






go

-- ----------------------------
-- procedure structure for getnearestsites
-- ----------------------------

create procedure [getnearestsites](@east float, @north float, @west float, @south float, @distkm float)
as
declare @distm int = 1000*@distkm
declare @site1 geography
if ((@north > @south) and (@east > @west))
  set @site1 = geography::stgeomfromtext('polygon((' +
               cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
               cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
			   cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			   cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			   cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + '))', 4326)
else
  set @site1 = geography::stgeomfromtext('point(' + cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ')', 4326)

select     ndb.sites.siteid, ndb.sites.sitename, @site1.envelopecenter().stdistance(geog.envelopecenter())/1000 as distkm,
           ti.geopol1.geopolname1 +
           iif(ti.geopol2.geopolname2 is not null, n'|' + ti.geopol2.geopolname2 +
		       iif(ti.geopol3.geopolname3 is not null, n'|' + ti.geopol3.geopolname3, n'') +
			   iif(ti.geopol4.geopolname4 is not null, n'|' + ti.geopol4.geopolname4, n''),n'') as geopolitical
from       ndb.sites left outer join
                      ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid left outer join
                      ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid left outer join
                      ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                      ti.geopol4 on ndb.sites.siteid = ti.geopol4.siteid
where  @site1.envelopecenter().stdistance(geog.envelopecenter()) <= @distm
order by distkm

go

-- ----------------------------
-- procedure structure for getnextlowergeopolcountbynames
-- ----------------------------




create procedure [getnextlowergeopolcountbynames](@name1 nvarchar(255), @rank1 int, @name2 nvarchar(255), @rank2 int)
as
select     count(geopoliticalunits_1.geopoliticalname) as count
from         ndb.geopoliticalunits inner join
                      ndb.geopoliticalunits as geopoliticalunits_1 on ndb.geopoliticalunits.geopoliticalid = geopoliticalunits_1.highergeopoliticalid
where     (ndb.geopoliticalunits.geopoliticalname = @name1) and (ndb.geopoliticalunits.rank = @rank1) and
                      (geopoliticalunits_1.geopoliticalname = @name2) and (geopoliticalunits_1.rank = @rank2)







go

-- ----------------------------
-- procedure structure for getnextpublicationbyid
-- ----------------------------



create procedure [getnextpublicationbyid](@publicationid int)
as

declare @nextpubid int;
select  @nextpubid = min(publicationid)
from         ndb.publications
where     (publicationid > @publicationid)

select      ndb.publications.*
from          ndb.publications
where      (publicationid = @nextpubid)





go

-- ----------------------------
-- procedure structure for getnextpublicationbyidandpubtypeid
-- ----------------------------




create procedure [getnextpublicationbyidandpubtypeid](@publicationid int, @pubtypeid int)
as

declare @nextpubid int;
select  @nextpubid = min(publicationid)
from         ndb.publications
where     (publicationid > @publicationid and pubtypeid = @pubtypeid)

select      ndb.publications.*
from          ndb.publications
where      (publicationid = @nextpubid)






go

-- ----------------------------
-- procedure structure for getpollensporehighertaxa
-- ----------------------------



create procedure [getpollensporehighertaxa](@taxaidlist nvarchar(max))
as
declare @planttaxa table (id int not null primary key identity(1,1), taxonid int, highertaxonid int)

insert into @planttaxa (taxonid) select value from ti.func_nvarcharlisttoin(@taxaidlist,'$')

declare @nrows int = @@rowcount
declare @taxonid int
declare @nexttaxonid int
declare @higherid int
declare @spermatophyta int = 5480
declare @tracheophyta int = 9534
declare @embryophyta int = 33038
declare @currentid int = 0
while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	set @taxonid = (select taxonid from @planttaxa where (id = @currentid))
	set @nexttaxonid = @taxonid
    set @higherid = (select highertaxonid from ndb.taxa where (taxonid = @taxonid))
    while @nexttaxonid <> @higherid and @nexttaxonid <> @spermatophyta and @nexttaxonid <> @tracheophyta and @nexttaxonid <> @embryophyta
      begin
        set @nexttaxonid = (select taxonid from ndb.taxa where (taxonid = @higherid))
        set @higherid = (select highertaxonid from ndb.taxa where (taxonid = @nexttaxonid))
      end
	update @planttaxa
    set    highertaxonid = @nexttaxonid
    where  taxonid = @taxonid
  end

select taxonid, highertaxonid from @planttaxa




go

-- ----------------------------
-- procedure structure for getpredefinedtaxaecolgroupsbydatasettypelist
-- ----------------------------




create procedure [getpredefinedtaxaecolgroupsbydatasettypelist](@datasettypeids nvarchar(max))
as
select     top (2147483647) ndb.datasettaxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgroups.ecolgroupid,
                      ndb.ecolgrouptypes.ecolgroup
from         ndb.datasettaxagrouptypes inner join
                      ndb.taxa on ndb.datasettaxagrouptypes.taxagroupid = ndb.taxa.taxagroupid inner join
                      ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
                      ndb.taxagrouptypes on ndb.datasettaxagrouptypes.taxagroupid = ndb.taxagrouptypes.taxagroupid inner join
                      ndb.ecolgrouptypes on ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid
where     (ndb.datasettaxagrouptypes.datasettypeid in (
                                                      select value
                                                      from ti.func_intlisttoin(@datasettypeids,',')
                                                      ))
group by ndb.datasettaxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
order by ndb.datasettaxagrouptypes.taxagroupid







go

-- ----------------------------
-- procedure structure for getpreviouspublicationbyid
-- ----------------------------




create procedure [getpreviouspublicationbyid](@publicationid int)
as

declare @previouspubid int;
select  @previouspubid = max(publicationid)
from         ndb.publications
where     (publicationid < @publicationid)

select      ndb.publications.*
from          ndb.publications
where      (publicationid = @previouspubid)






go

-- ----------------------------
-- procedure structure for getpreviouspublicationbyidandpubtypeid
-- ----------------------------





create procedure [getpreviouspublicationbyidandpubtypeid](@publicationid int, @pubtypeid int)
as

declare @previouspubid int;
select  @previouspubid = max(publicationid)
from         ndb.publications
where     (publicationid < @publicationid and pubtypeid = @pubtypeid)

select      ndb.publications.*
from          ndb.publications
where      (publicationid = @previouspubid)







go

-- ----------------------------
-- procedure structure for getpublicationauthors
-- ----------------------------


create procedure [getpublicationauthors](@publicationid int)
as select      authorid, publicationid, authororder, familyname, initials, suffix, contactid
from          ndb.publicationauthors
where      (publicationid = @publicationid)
order by authororder




go

-- ----------------------------
-- procedure structure for getpublicationbycitation
-- ----------------------------

create procedure [getpublicationbycitation](@citation nvarchar(max))
as select      publicationid, pubtypeid, year, citation, articletitle, journal, volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition,
volumetitle, seriestitle, seriesvolume, publisher, url, city, state, country,
originallanguage, notes
from          ndb.publications
where      (citation like @citation)



go

-- ----------------------------
-- procedure structure for getpublicationbydatasetid
-- ----------------------------


create procedure [getpublicationbydatasetid](@datasetid int)
as
select     ndb.datasets.datasetid, ndb.publications.publicationid, ndb.publications.citation
from         ndb.datasets inner join
                      ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                      ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid
where     (ndb.datasets.datasetid = @datasetid)





go

-- ----------------------------
-- procedure structure for getpublicationbyfamilyname
-- ----------------------------

create procedure [getpublicationbyfamilyname](@familyname nvarchar(80))
as select     ndb.publications.*
from         ndb.publicationauthors inner join
                      ndb.contacts on ndb.publicationauthors.contactid = ndb.contacts.contactid inner join
                      ndb.publications on ndb.publicationauthors.publicationid = ndb.publications.publicationid
where     (ndb.contacts.familyname like @familyname) or
                      (ndb.publicationauthors.familyname like @familyname)



go

-- ----------------------------
-- procedure structure for getpublicationbyid
-- ----------------------------


create procedure [getpublicationbyid](@publicationid int)
as
select     publicationid, pubtypeid, year, citation, articletitle, journal, volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition, volumetitle, seriestitle,
                      seriesvolume, publisher, url, city, state, country, originallanguage, notes
from         ndb.publications
where      (publicationid = @publicationid)




go

-- ----------------------------
-- procedure structure for getpublicationbyidlist
-- ----------------------------



create procedure [getpublicationbyidlist](@publicationidlist nvarchar(max))
as
select     publicationid, pubtypeid, year, citation, articletitle, journal, volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition, volumetitle, seriestitle,
                      seriesvolume, publisher, url, city, state, country, originallanguage, notes
from         ndb.publications
where (publicationid in (
		             select value
		             from ti.func_nvarcharlisttoin(@publicationidlist,'$')
                     ))





go

-- ----------------------------
-- procedure structure for getpublicationeditors
-- ----------------------------


create procedure [getpublicationeditors](@publicationid int)
as select      editorid, publicationid, editororder, familyname, initials, suffix
from          ndb.publicationeditors
where      (publicationid = @publicationid)
order by editororder




go

-- ----------------------------
-- procedure structure for getpublicationsbycontactid
-- ----------------------------


create procedure [getpublicationsbycontactid](@contactid int)
as select     ndb.publications.*
from         ndb.contacts inner join
                      ndb.publicationauthors on ndb.contacts.contactid = ndb.publicationauthors.contactid inner join
                      ndb.publications on ndb.publicationauthors.publicationid = ndb.publications.publicationid
where     (ndb.contacts.contactid = @contactid)




go

-- ----------------------------
-- procedure structure for getpublicationsbygeochronid
-- ----------------------------




create procedure [getpublicationsbygeochronid](@geochronidlist nvarchar(max))
as
select     geochronid, publicationid
from         ndb.geochronpublications
where (geochronid in (
		             select value
		             from ti.func_nvarcharlisttoin(@geochronidlist,'$')
                     ))




go

-- ----------------------------
-- procedure structure for getpublicationstable
-- ----------------------------

create procedure [getpublicationstable]
as select      *
from          ndb.publications



go

-- ----------------------------
-- procedure structure for getpublicationtranslators
-- ----------------------------



create procedure [getpublicationtranslators](@publicationid int)
as select      ndb.publicationtranslators.*
from          ndb.publicationtranslators
where      (publicationid = @publicationid)
order by translatororder





go

-- ----------------------------
-- procedure structure for getpublicationtypestable
-- ----------------------------

create procedure [getpublicationtypestable]
as select      *
from          ndb.publicationtypes



go

-- ----------------------------
-- procedure structure for getradiocarbonbygeochronid
-- ----------------------------




create procedure [getradiocarbonbygeochronid](@geochronidlist nvarchar(max))
as
select     ndb.radiocarbon.geochronid, ndb.radiocarbonmethods.radiocarbonmethod, ndb.radiocarbon.percentc, ndb.radiocarbon.percentn, ndb.radiocarbon.cnratio,
                      ndb.radiocarbon.delta13c, ndb.radiocarbon.delta15n, ndb.radiocarbon.percentcollagen, ndb.radiocarbon.reservoir
from         ndb.radiocarbon inner join
                      ndb.radiocarbonmethods on ndb.radiocarbon.radiocarbonmethodid = ndb.radiocarbonmethods.radiocarbonmethodid
where (geochronid in (
		             select value
		             from ti.func_nvarcharlisttoin(@geochronidlist,'$')
                     ))




go

-- ----------------------------
-- procedure structure for getradiocarbonmethodid
-- ----------------------------





create procedure [getradiocarbonmethodid](@radiocarbonmethod nvarchar(64))
as
select     radiocarbonmethodid
from       ndb.radiocarbonmethods
where     (radiocarbonmethod = @radiocarbonmethod)







go

-- ----------------------------
-- procedure structure for getradiocarbonmethodstable
-- ----------------------------



create procedure [getradiocarbonmethodstable]
as select     radiocarbonmethodid, radiocarbonmethod
from          ndb.radiocarbonmethods








go

-- ----------------------------
-- procedure structure for getrecentuploads
-- ----------------------------



create procedure [getrecentuploads](@months int, @databaseid int = null, @datasettypeid int = null)
as

declare @newdatasets table (id int not null primary key identity(1,1),
                            datasetid int,
                            datasettype nvarchar(64),
							sitename nvarchar(128),
							geopol1 nvarchar(255),
							geopol2 nvarchar(255),
							geopol3 nvarchar(255),
							databasename nvarchar(80),
							investigator nvarchar(max),
							recdatecreated nvarchar(10),
							steward nvarchar(80))

insert into @newdatasets (datasetid, datasettype, sitename, geopol1, geopol2, geopol3, databasename, recdatecreated, steward)
select top (100) percent ndb.datasets.datasetid, ndb.datasettypes.datasettype, ndb.sites.sitename, ti.geopol1.geopolname1, ti.geopol2.geopolname2,
                 ti.geopol3.geopolname3, ndb.constituentdatabases.databasename, convert(date,ndb.datasets.recdatecreated) as recdatecreated,
				 ndb.contacts.contactname as steward
from         ndb.datasets inner join
                      ndb.datasettypes on ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid inner join
                      ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid inner join
                      ndb.datasetsubmissions on ndb.datasets.datasetid = ndb.datasetsubmissions.datasetid inner join
                      ndb.constituentdatabases on ndb.datasetsubmissions.databaseid = ndb.constituentdatabases.databaseid inner join
                      ndb.contacts on ndb.datasetsubmissions.contactid = ndb.contacts.contactid left outer join
                      ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                      ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid
where (
      (@databaseid is not null and @datasettypeid is null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is not null and @datasettypeid is not null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
      (@databaseid is null and @datasettypeid is not null and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is null and @datasettypeid is null and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate()))
	  )
order by ndb.datasets.recdatecreated desc

declare @nrows int = @@rowcount

declare @newdatasetpis table (datasetid int)

insert into @newdatasetpis (datasetid)
select      [@newdatasets].[datasetid]
from        @newdatasets inner join
                      ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
                      ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid

declare @pis table (contactid int not null primary key identity(1,1), contactname nvarchar(96), piorder int, processed int not null default 0)
declare @currentid int = 0
declare @piid int
declare @contactname nvarchar(max)
declare @currentname nvarchar(96)
declare @ncontactrows int
while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	insert into @pis (contactname, piorder)
    select concat(ndb.contacts.leadinginitials,n' ',ndb.contacts.familyname), ndb.datasetpis.piorder
    from   @newdatasets inner join
              ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
              ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
	where  ([@newdatasets].[id] = @currentid)
	order by ndb.datasetpis.piorder
	set @ncontactrows = @@rowcount
	set @contactname = null
	while (select count(*) from @pis where processed = 0) > 0
	  begin
	    select top 1 @piid = contactid, @currentname = contactname
		from @pis
		where processed = 0
		if @contactname is null
		  set @contactname = @currentname
		else
		  set @contactname = @contactname + n', ' + @currentname
		update @pis
		set processed = 1 where contactid = @piid
	  end
    update @newdatasets
    set [@newdatasets].[investigator] = @contactname
	where ([@newdatasets].[id] = @currentid)
  end

select top 400 datasetid,
       datasettype,
	   sitename,
	   case when geopol2 is null then geopol1
	        when geopol3 is null then concat(geopol1,n' | ',geopol2)
	                             else concat(geopol1,n' | ',geopol2,n' | ',geopol3)
       end as geopolitical,
	   databasename,
	   investigator,
	   recdatecreated,
	   steward
from   @newdatasets






go

-- ----------------------------
-- procedure structure for getrecentuploadsv1
-- ----------------------------


create procedure [getrecentuploadsv1](@months int, @databaseid int = null, @datasettypeid int = null)
as

declare @newdatasets table (id int not null primary key identity(1,1),
                            datasetid int,
                            datasettype nvarchar(64),
							sitename nvarchar(128),
							geopol1 nvarchar(255),
							geopol2 nvarchar(255),
							geopol3 nvarchar(255),
							databasename nvarchar(80),
							investigator nvarchar(max),
							recdatecreated nvarchar(10),
							steward nvarchar(80))

insert into @newdatasets (datasetid, datasettype, sitename, geopol1, geopol2, geopol3, databasename, recdatecreated, steward)
select top (100) percent ndb.datasets.datasetid, ndb.datasettypes.datasettype, ndb.sites.sitename, ti.geopol1.geopolname1, ti.geopol2.geopolname2,
                 ti.geopol3.geopolname3, ndb.constituentdatabases.databasename, convert(date,ndb.datasets.recdatecreated) as recdatecreated,
				 ndb.contacts.contactname as steward
from         ndb.datasets inner join
                      ndb.datasettypes on ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid inner join
                      ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid inner join
                      ndb.datasetsubmissions on ndb.datasets.datasetid = ndb.datasetsubmissions.datasetid inner join
                      ndb.constituentdatabases on ndb.datasetsubmissions.databaseid = ndb.constituentdatabases.databaseid inner join
                      ndb.contacts on ndb.datasetsubmissions.contactid = ndb.contacts.contactid left outer join
                      ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                      ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid
where (
      (@databaseid is not null and @datasettypeid is null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is not null and @datasettypeid is not null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
      (@databaseid is null and @datasettypeid is not null and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is null and @datasettypeid is null and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate()))
	  )
order by ndb.datasets.recdatecreated desc

declare @nrows int = @@rowcount

declare @newdatasetpis table (datasetid int)

insert into @newdatasetpis (datasetid)
select      [@newdatasets].[datasetid]
from        @newdatasets inner join
                      ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
                      ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid

declare @pis table (contactid int not null primary key identity(1,1), contactname nvarchar(96), piorder int, processed int not null default 0)
declare @currentid int = 0
declare @piid int
declare @contactname nvarchar(max)
declare @currentname nvarchar(96)
declare @ncontactrows int
while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	insert into @pis (contactname, piorder)
    select concat(ndb.contacts.leadinginitials,n' ',ndb.contacts.familyname), ndb.datasetpis.piorder
    from   @newdatasets inner join
              ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
              ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
	where  ([@newdatasets].[id] = @currentid)
	order by ndb.datasetpis.piorder
	set @ncontactrows = @@rowcount
	set @contactname = null
	while (select count(*) from @pis where processed = 0) > 0
	  begin
	    select top 1 @piid = contactid, @currentname = contactname
		from @pis
		where processed = 0
		if @contactname is null
		  set @contactname = @currentname
		else
		  set @contactname = @contactname + n', ' + @currentname
		update @pis
		set processed = 1 where contactid = @piid
	  end
    update @newdatasets
    set [@newdatasets].[investigator] = @contactname
	where ([@newdatasets].[id] = @currentid)
  end

select datasetid,
       datasettype,
	   sitename,
	   case when geopol2 is null then geopol1
	        when geopol3 is null then concat(geopol1,n' | ',geopol2)
	                             else concat(geopol1,n' | ',geopol2,n' | ',geopol3)
       end as geopolitical,
	   databasename,
	   investigator,
	   recdatecreated,
	   steward
from   @newdatasets





go

-- ----------------------------
-- procedure structure for getrecentuploadsv2
-- ----------------------------


create procedure [getrecentuploadsv2](@months int, @databaseid int = null, @datasettypeid int = null)
as

declare @newdatasets table (id int not null primary key identity(1,1),
                            datasetid int,
                            datasettype nvarchar(64),
							sitename nvarchar(128),
							geopol1 nvarchar(255),
							geopol2 nvarchar(255),
							geopol3 nvarchar(255),
							databasename nvarchar(80),
							investigator nvarchar(max),
							recdatecreated nvarchar(10),
							steward nvarchar(80))

insert into @newdatasets (datasetid, datasettype, sitename, geopol1, geopol2, geopol3, databasename, recdatecreated, steward)
select top (100) percent ndb.datasets.datasetid, ndb.datasettypes.datasettype, ndb.sites.sitename, ti.geopol1.geopolname1, ti.geopol2.geopolname2,
                 ti.geopol3.geopolname3, ndb.constituentdatabases.databasename, convert(date,ndb.datasets.recdatecreated) as recdatecreated,
				 ndb.contacts.contactname as steward
from         ndb.datasets inner join
                      ndb.datasettypes on ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid inner join
                      ti.geopol1 on ndb.sites.siteid = ti.geopol1.siteid inner join
                      ndb.datasetsubmissions on ndb.datasets.datasetid = ndb.datasetsubmissions.datasetid inner join
                      ndb.constituentdatabases on ndb.datasetsubmissions.databaseid = ndb.constituentdatabases.databaseid inner join
                      ndb.contacts on ndb.datasetsubmissions.contactid = ndb.contacts.contactid left outer join
                      ti.geopol3 on ndb.sites.siteid = ti.geopol3.siteid left outer join
                      ti.geopol2 on ndb.sites.siteid = ti.geopol2.siteid
where (
      (@databaseid is not null and @datasettypeid is null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is not null and @datasettypeid is not null and ndb.datasetsubmissions.databaseid = @databaseid and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
      (@databaseid is null and @datasettypeid is not null and ndb.datasettypes.datasettypeid = @datasettypeid and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate())) or
	  (@databaseid is null and @datasettypeid is null and ndb.datasets.recdatecreated >= dateadd(month, -@months, getdate()))
	  )
order by ndb.datasets.recdatecreated desc

declare @nrows int = @@rowcount

declare @newdatasetpis table (datasetid int)

insert into @newdatasetpis (datasetid)
select      [@newdatasets].[datasetid]
from        @newdatasets inner join
                      ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
                      ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid

declare @pis table (contactid int not null primary key identity(1,1), contactname nvarchar(96), piorder int, processed int not null default 0)
declare @currentid int = 0
declare @piid int
declare @contactname nvarchar(max)
declare @currentname nvarchar(96)
declare @ncontactrows int
while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	insert into @pis (contactname, piorder)
    select concat(ndb.contacts.leadinginitials,n' ',ndb.contacts.familyname), ndb.datasetpis.piorder
    from   @newdatasets inner join
              ndb.datasetpis on [@newdatasets].[datasetid] = ndb.datasetpis.datasetid inner join
              ndb.contacts on ndb.datasetpis.contactid = ndb.contacts.contactid
	where  ([@newdatasets].[id] = @currentid)
	order by ndb.datasetpis.piorder
	set @ncontactrows = @@rowcount
	set @contactname = null
	while (select count(*) from @pis where processed = 0) > 0
	  begin
	    select top 1 @piid = contactid, @currentname = contactname
		from @pis
		where processed = 0
		if @contactname is null
		  set @contactname = @currentname
		else
		  set @contactname = @contactname + n', ' + @currentname
		update @pis
		set processed = 1 where contactid = @piid
	  end
    update @newdatasets
    set [@newdatasets].[investigator] = @contactname
	where ([@newdatasets].[id] = @currentid)
  end

select top 20 datasetid,
       datasettype,
	   sitename,
	   case when geopol2 is null then geopol1
	        when geopol3 is null then concat(geopol1,n' | ',geopol2)
	                             else concat(geopol1,n' | ',geopol2,n' | ',geopol3)
       end as geopolitical,
	   databasename,
	   investigator,
	   recdatecreated,
	   steward
from   @newdatasets





go

-- ----------------------------
-- procedure structure for getrelativeagebyname
-- ----------------------------


create procedure [getrelativeagebyname](@relativeage nvarchar(64))
as
select     relativeageid, relativeageunitid, relativeagescaleid, relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes
from         ndb.relativeages
where     (relativeage = @relativeage)



go

-- ----------------------------
-- procedure structure for getrelativeagechroncontroltype
-- ----------------------------



create procedure [getrelativeagechroncontroltype](@relativeage nvarchar(64))
as
select     ndb.chroncontroltypes.chroncontroltypeid, ndb.chroncontroltypes.chroncontroltype
from         ndb.relativeages inner join
                      ndb.relativeagescales on ndb.relativeages.relativeagescaleid = ndb.relativeagescales.relativeagescaleid inner join
                      ndb.chroncontroltypes on ndb.relativeagescales.relativeagescale = ndb.chroncontroltypes.chroncontroltype
where     (ndb.relativeages.relativeage = @relativeage)




go

-- ----------------------------
-- procedure structure for getrelativeagepublications
-- ----------------------------


create procedure [getrelativeagepublications](@relativeageid int)
as
select      ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation, ndb.publications.articletitle,
                      ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi,
                      ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle,
                      ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, ndb.publications.country,
                      ndb.publications.originallanguage, ndb.publications.notes
from         ndb.relativeagepublications inner join
                      ndb.publications on ndb.relativeagepublications.publicationid = ndb.publications.publicationid
where     (ndb.relativeagepublications.relativeageid = @relativeageid)



go

-- ----------------------------
-- procedure structure for getrelativeagesbychronologyid
-- ----------------------------



create procedure [getrelativeagesbychronologyid](@chronologyid int)
as
select     ndb.relativechronology.chroncontrolid, ndb.relativeages.relativeage
from         ndb.analysisunits inner join
                      ndb.relativechronology on ndb.analysisunits.analysisunitid = ndb.relativechronology.analysisunitid inner join
                      ndb.chronologies on ndb.analysisunits.collectionunitid = ndb.chronologies.collectionunitid inner join
                      ndb.relativeages on ndb.relativechronology.relativeageid = ndb.relativeages.relativeageid
where     (ndb.chronologies.chronologyid = @chronologyid) and (ndb.relativechronology.chroncontrolid is not null)





go

-- ----------------------------
-- procedure structure for getrelativeagescalebyname
-- ----------------------------


create procedure [getrelativeagescalebyname](@relativeagescale nvarchar(64))
as
select     relativeagescaleid, relativeagescale
from         ndb.relativeagescales
where     (relativeagescale = @relativeagescale)




go

-- ----------------------------
-- procedure structure for getrelativeagescalestable
-- ----------------------------


create procedure [getrelativeagescalestable]
as select      ndb.relativeagescales.*
from          ndb.relativeagescales





go

-- ----------------------------
-- procedure structure for getrelativeagestable
-- ----------------------------



create procedure [getrelativeagestable]
as select      relativeageid, relativeageunitid, relativeagescaleid, relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes
from          ndb.relativeages






go

-- ----------------------------
-- procedure structure for getrelativeageunitsbyagescale
-- ----------------------------



create procedure [getrelativeageunitsbyagescale](@relativeagescale nvarchar(64))
as
select     ndb.relativeageunits.relativeageunitid, ndb.relativeageunits.relativeageunit
from         ndb.relativeagescales inner join
                      ndb.relativeages on ndb.relativeagescales.relativeagescaleid = ndb.relativeages.relativeagescaleid inner join
                      ndb.relativeageunits on ndb.relativeages.relativeageunitid = ndb.relativeageunits.relativeageunitid
group by ndb.relativeagescales.relativeagescale, ndb.relativeageunits.relativeageunitid, ndb.relativeageunits.relativeageunit
having      (ndb.relativeagescales.relativeagescale = @relativeagescale)




go

-- ----------------------------
-- procedure structure for getrepositoryinstitution
-- ----------------------------


create procedure [getrepositoryinstitution](@acronym nvarchar(64) = null, @repository nvarchar(128) = null)
as
select     repositoryid, acronym, repository, notes
from       ndb.repositoryinstitutions
where      (acronym = @acronym) or (repository = @repository)






go

-- ----------------------------
-- procedure structure for getrepositoryinstitutionstable
-- ----------------------------


create procedure [getrepositoryinstitutionstable]
as select      repositoryid, acronym, repository, notes
from          ndb.repositoryinstitutions





go

-- ----------------------------
-- procedure structure for getrocktypebyid
-- ----------------------------



create procedure [getrocktypebyid](@rocktypeid int)
as
select     rocktypeid, rocktype, higherrocktypeid, description
from         ndb.rocktypes
where     (rocktypeid = @rocktypeid)






go

-- ----------------------------
-- procedure structure for getrocktypebyname
-- ----------------------------


create procedure [getrocktypebyname](@rocktype nvarchar(64))
as
select     rocktypeid, rocktype, higherrocktypeid, description
from         ndb.rocktypes
where     (rocktype = @rocktype)





go

-- ----------------------------
-- procedure structure for getrocktypestable
-- ----------------------------

create procedure [getrocktypestable]
as select      rocktypeid, rocktype, higherrocktypeid, description
from          ndb.rocktypes




go

-- ----------------------------
-- procedure structure for getsampleage
-- ----------------------------




create procedure [getsampleage](@chronologyid int, @sampleid int)
as
select    sampleageid, age, ageyounger, ageolder
from      ndb.sampleages
where     (chronologyid = @chronologyid) and (sampleid = @sampleid)


go

-- ----------------------------
-- procedure structure for getsampleagesbychronid
-- ----------------------------



create procedure [getsampleagesbychronid](@chronologyid int)
as
select     sampleid, age, ageyounger, ageolder
from         ndb.sampleages
where     (chronologyid = @chronologyid)





go

-- ----------------------------
-- procedure structure for getsitebyname
-- ----------------------------






create procedure [getsitebyname](@sitename nvarchar(128))
as
select     siteid, sitename, geog.tostring() as geog
from         ndb.sites
where     (sitename like @sitename)


go

-- ----------------------------
-- procedure structure for getsitemetadata
-- ----------------------------

create procedure [getsitemetadata](@siteid int)
as
select      siteid, sitename, geog.tostring() as geog, altitude, area, sitedescription, notes
from        ndb.sites
where       (siteid = @siteid)

go

-- ----------------------------
-- procedure structure for getsites
-- ----------------------------





create procedure [getsites](@datasettypeid int = null, @sitename nvarchar(128) = null, @geopoliticalid int = null, @contactid int = null, @authorid int = null)
as

declare @sites table
(
  siteid int,
  sitename nvarchar(128),
  geog nvarchar(max)
)

if @datasettypeid is not null
  begin
    if @sitename is not null
	  begin
	    if @geopoliticalid is not null
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.datasetpis.contactid = @contactid) and
				       (ndb.sites.sitename like @sitename)
              end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.publicationauthors.contactid = @authorid) and
                       (ndb.sites.sitename like @sitename)
			  end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and
                       (ndb.sites.sitename like @sitename)
			  end
		  end
		else
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.datasetpis.contactid = @contactid) and (ndb.sites.sitename like @sitename)
			  end
            else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.publicationauthors.contactid = @authorid) and (ndb.sites.sitename like @sitename)
			  end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sites.sitename like @sitename)
			  end
		  end
	  end
	else  /* @sitename is null */
	  begin
	    if @geopoliticalid is not null
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.datasetpis.contactid = @contactid)
              end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.publicationauthors.contactid = @authorid)
              end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.sitegeopolitical on ndb.sites.siteid = ndb.sitegeopolitical.siteid
                where (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid)
              end
		  end
		else
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.datasetpis.contactid = @contactid)
              end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.datasets.datasettypeid = @datasettypeid) and (ndb.publicationauthors.contactid = @authorid)
              end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid
                where  (ndb.datasets.datasettypeid = @datasettypeid)
              end
		  end
	  end
  end
else  /* @datasettypeid is null */
  begin
    if @sitename is not null
	  begin
	    if @geopoliticalid is not null
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sitegeopolitical inner join
                         ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.datasetpis.contactid = @contactid) and (ndb.sites.sitename like @sitename)
			  end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sitegeopolitical inner join
                         ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.publicationauthors.contactid = @authorid) and (ndb.sites.sitename like @sitename)
			  end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sitegeopolitical inner join
                         ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.sites.sitename like @sitename)
			  end
		  end
		else
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where (ndb.datasetpis.contactid = @contactid) and (ndb.sites.sitename like @sitename)
			  end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                         ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                         ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where     (ndb.publicationauthors.contactid = @authorid) and (ndb.sites.sitename like @sitename)
			  end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sites
                where  (sitename like @sitename)
			  end
		  end
	  end
	else /* @sitename is null */
	  begin
	    if @geopoliticalid is not null
		  begin
		    if @contactid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sitegeopolitical inner join
                         ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid inner join
                         ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                         ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                         ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.datasetpis.contactid = @contactid)
              end
			else if @authorid is not null
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from    ndb.sitegeopolitical inner join
                          ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid inner join
                          ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                          ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                          ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                          ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                          ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid) and (ndb.publicationauthors.contactid = @authorid)
              end
			else
			  begin
			    insert into @sites (siteid, sitename, geog)
				select sites.siteid, sites.sitename, sites.geog.tostring()
                from   ndb.sitegeopolitical inner join
                        ndb.sites on ndb.sitegeopolitical.siteid = ndb.sites.siteid
                where  (ndb.sitegeopolitical.geopoliticalid = @geopoliticalid)
			  end
		  end
		else if @contactid is not null
		  begin
		    insert into @sites (siteid, sitename, geog)
			select sites.siteid, sites.sitename, sites.geog.tostring()
            from   ndb.sites inner join
                     ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                     ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                     ndb.datasetpis on ndb.datasets.datasetid = ndb.datasetpis.datasetid
            where  (ndb.datasetpis.contactid = @contactid)
          end
		else if @authorid is not null
		  begin
		    insert into @sites (siteid, sitename, geog)
			select sites.siteid, sites.sitename, sites.geog.tostring()
            from   ndb.sites inner join
                     ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                     ndb.datasets on ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid inner join
                     ndb.datasetpublications on ndb.datasets.datasetid = ndb.datasetpublications.datasetid inner join
                     ndb.publications on ndb.datasetpublications.publicationid = ndb.publications.publicationid inner join
                     ndb.publicationauthors on ndb.publications.publicationid = ndb.publicationauthors.publicationid
            where (ndb.publicationauthors.contactid = @authorid)
          end
      end
  end

select siteid, sitename, geog
from @sites
group by siteid, sitename, geog

go

-- ----------------------------
-- procedure structure for getsitesbydatabaseanddatasettype
-- ----------------------------



create procedure [getsitesbydatabaseanddatasettype](@databaseid int, @datasettypeid int)
as
declare @sites table
(
  siteid int,
  sitename nvarchar(128),
  latitude float,
  longitude float,
  altitude float,
  area float
)
insert into @sites (siteid, sitename, latitude, longitude, altitude, area)
select      ndb.sites.siteid, ndb.sites.sitename, geog.envelopecenter().lat, geog.envelopecenter().long, ndb.sites.altitude, ndb.sites.area
from         ndb.datasets inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid inner join
                      ndb.datasetdatabases on ndb.datasets.datasetid = ndb.datasetdatabases.datasetid
where     (ndb.datasetdatabases.databaseid = @databaseid) and (ndb.datasets.datasettypeid = @datasettypeid)

select     siteid, sitename, latitude, longitude,altitude, area
from       @sites
group by siteid, sitename, latitude, longitude, altitude, area



go

-- ----------------------------
-- procedure structure for getsitesbydatasettype
-- ----------------------------



create procedure [getsitesbydatasettype](@datasettypeid int)
as
declare @sites table
(
  siteid int,
  sitename nvarchar(128),
  latitude float,
  longitude float,
  altitude float,
  area float
)
insert into @sites (siteid, sitename, latitude, longitude, altitude, area)
select      ndb.sites.siteid, ndb.sites.sitename, geog.envelopecenter().lat, geog.envelopecenter().long, ndb.sites.altitude, ndb.sites.area
from         ndb.datasets inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.sites on ndb.collectionunits.siteid = ndb.sites.siteid
where     (ndb.datasets.datasettypeid = @datasettypeid)

select     siteid, sitename, latitude, longitude,altitude, area
from       @sites
group by siteid, sitename, latitude, longitude, altitude, area



go

-- ----------------------------
-- procedure structure for getspecimendatesbytaxonid
-- ----------------------------





create procedure [getspecimendatesbytaxonid](@taxonid int)
as
select     specimendateid, geochronid, taxonid, fractionid, sampleid, notes, elementtypeid
from         ndb.specimendates
where     (taxonid = @taxonid)

go

-- ----------------------------
-- procedure structure for getspecimendomesticstatusbyname
-- ----------------------------




create procedure [getspecimendomesticstatusbyname](@domesticstatus nvarchar(24))
as
select      domesticstatusid, domesticstatus
from          ndb.specimendomesticstatustypes
where      (domesticstatus = @domesticstatus)






go

-- ----------------------------
-- procedure structure for getspecimendomesticstatustypes
-- ----------------------------




create procedure [getspecimendomesticstatustypes]
as select     domesticstatusid, domesticstatus
from          ndb.specimendomesticstatustypes





go

-- ----------------------------
-- procedure structure for getspecimenisotopedataset
-- ----------------------------





create procedure [getspecimenisotopedataset](@datasetid int)
as
declare @speciso table
(
  id int not null primary key identity(1,1),
  dataid int,
  specimenid int,
  analysisunit nvarchar(80),
  depth nvarchar(64),
  thickness nvarchar(64),
  taxon nvarchar(80),
  element nvarchar(255),
  variable nvarchar(80),
  units nvarchar(64),
  value nvarchar(64),
  sd nvarchar(64),
  materialanalyzed nvarchar(50),
  substrate nvarchar(50),
  pretreatments nvarchar(max),
  analyst nvarchar(80),
  lab nvarchar(255),
  labnumber nvarchar(64),
  mass_mg nvarchar(64),
  weightpercent nvarchar(64),
  atomicpercent nvarchar(64),
  reps nvarchar(64)
)

declare @pretreatments table
(
  dataid int,
  [order] int,
  isopretreatmenttype nvarchar(50),
  isopretreatmentqualifier nvarchar(50),
  value float,
  primary key (dataid)
)

insert into @speciso (dataid, specimenid, analysisunit, depth, thickness, taxon, element, variable, units, value, sd, materialanalyzed, substrate, analyst,
                      lab, labnumber, mass_mg, weightpercent, atomicpercent, reps)
select     top (100) percent ndb.data.dataid, ndb.specimens.specimenid, ndb.analysisunits.analysisunitname as n'analysis unit',
                      isnull(cast(ndb.analysisunits.depth as nvarchar), n'') as depth,
					  isnull(cast(ndb.analysisunits.thickness as nvarchar), n'') as thickness,
                      taxa_1.taxonname as taxon,concat(ndb.elementtypes.elementtype,
					  case when ndb.elementsymmetries.symmetry is null then n'' else concat(n';',ndb.elementsymmetries.symmetry) end,
                      case when ndb.elementportions.portion is null then n'' else concat(n';',ndb.elementportions.portion) end,
                      case when ndb.elementmaturities.maturity is null then n'' else concat(n';',ndb.elementmaturities.maturity) end) as element,
					  ndb.taxa.taxonname as variable, ndb.variableunits.variableunits as units, ndb.data.value,
					  isnull(cast(ndb.isospecimendata.sd as nvarchar), n'') as sd,
                      isnull(ndb.isomaterialanalyzedtypes.isomaterialanalyzedtype,n'') as n'material analyzed',
					  isnull(ndb.isosubstratetypes.isosubstratetype,n'') as substrate,
					  isnull(ndb.contacts.contactname,n'') as analyst,
					  isnull(ndb.isometadata.lab,n'') as lab,
					  isnull(ndb.isometadata.labnumber,n'') as n'lab number',
					  isnull(cast(ndb.isometadata.mass_mg as nvarchar),n'') as n'mass (mg)',
					  isnull(cast(ndb.isometadata.weightpercent as nvarchar),n'') as n'weight %',
					  isnull(cast(ndb.isometadata.atomicpercent as nvarchar),n'') as n'atomic %',
					  isnull(cast(ndb.isometadata.reps as nvarchar),n'') as reps
from         ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid inner join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid inner join
                      ndb.isospecimendata on ndb.data.dataid = ndb.isospecimendata.dataid inner join
                      ndb.specimens on ndb.isospecimendata.specimenid = ndb.specimens.specimenid inner join
                      ndb.data as data_1 on ndb.specimens.dataid = data_1.dataid inner join
                      ndb.variables as variables_1 on data_1.variableid = variables_1.variableid inner join
                      ndb.taxa as taxa_1 on variables_1.taxonid = taxa_1.taxonid inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid inner join
                      ndb.isometadata on ndb.data.dataid = ndb.isometadata.dataid left outer join
                      ndb.contacts on ndb.isometadata.analystid = ndb.contacts.contactid left outer join
                      ndb.isosubstratetypes on ndb.isometadata.isosubstratetypeid = ndb.isosubstratetypes.isosubstratetypeid left outer join
                      ndb.isomaterialanalyzedtypes on ndb.isometadata.isomatanaltypeid = ndb.isomaterialanalyzedtypes.isomatanaltypeid left outer join
                      ndb.elementportions on ndb.specimens.portionid = ndb.elementportions.portionid left outer join
                      ndb.elementtypes on ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid left outer join
                      ndb.elementsymmetries on ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid left outer join
                      ndb.elementmaturities on ndb.specimens.maturityid = ndb.elementmaturities.maturityid
where     (ndb.datasets.datasetid = 21006)
order by ndb.specimens.specimenid, ndb.taxa.taxonname

declare @nrows int = @@rowcount

insert into @pretreatments (dataid, [order], isopretreatmenttype, isopretreatmentqualifier, value)
select     top (100) percent ndb.data.dataid, ndb.isosamplepretreatments.[order], ndb.isopretratmenttypes.isopretreatmenttype,
                      ndb.isopretratmenttypes.isopretreatmentqualifier, ndb.isosamplepretreatments.value
from         ndb.isopretratmenttypes inner join
                      ndb.isosamplepretreatments on ndb.isopretratmenttypes.isopretreatmenttypeid = ndb.isosamplepretreatments.isopretreatmenttypeid right outer join
                      ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid on ndb.isosamplepretreatments.dataid = ndb.data.dataid
where     (ndb.datasets.datasetid = 21006)
order by ndb.data.dataid, ndb.isosamplepretreatments.[order]

declare @dataid int
declare @currentid int = 0

while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	set @dataid = (select dataid from @speciso where (id = @currentid))

	declare @samplepretreatments table (id int not null primary key identity(1,1), [order] int, pretreatment nvarchar(255), value float)

	insert into @samplepretreatments ([order], pretreatment, value)
	select [order], concat(isopretreatmenttype,case when isopretreatmentqualifier is null then n'' else concat(n', ',isopretreatmentqualifier) end), value
	from   @pretreatments
	where  dataid = @dataid

	declare @nr int = @@rowcount
    declare @pretreatmentid int = 0
    declare @pretreatment nvarchar(255)
	declare @allpretreatments nvarchar(max)

	while @pretreatmentid < @nr
      begin
	    set @pretreatmentid = @pretreatmentid+1
	    set @pretreatment = (select concat(pretreatment,case when value is null then n'' else concat(n', ',cast(value as nvarchar)) end)
		from @samplepretreatments where (id = @pretreatmentid))

		if @pretreatmentid = 1
		  set @allpretreatments = @pretreatment
		else
		  set @allpretreatments = concat(@allpretreatments,n'; ',@pretreatment)
	  end

	update @speciso
    set    pretreatments = @allpretreatments
	where  ([@speciso].[id] = @currentid)
  end

select specimenid, analysisunit, depth, thickness, taxon, element, variable, units, value, sd, materialanalyzed, substrate,
       pretreatments, analyst, lab, labnumber, mass_mg, weightpercent, atomicpercent, reps
from   @speciso
order by specimenid, variable







go

-- ----------------------------
-- procedure structure for getspecimensexbyname
-- ----------------------------




create procedure [getspecimensexbyname](@sex nvarchar(24))
as
select      sexid, sex
from          ndb.specimensextypes
where      (sex = @sex)






go

-- ----------------------------
-- procedure structure for getspecimensextypes
-- ----------------------------



create procedure [getspecimensextypes]
as select     sexid, sex
from          ndb.specimensextypes




go

-- ----------------------------
-- procedure structure for getstatscolltypedatasetcount
-- ----------------------------




create procedure [getstatscolltypedatasetcount]
as
select     top (100) percent ndb.collectiontypes.colltype, count(ndb.datasets.datasetid) as datasetcount
from         ndb.datasets inner join
                      ndb.collectionunits on ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid inner join
                      ndb.collectiontypes on ndb.collectionunits.colltypeid = ndb.collectiontypes.colltypeid
group by ndb.collectiontypes.colltype
order by ndb.collectiontypes.colltype


go

-- ----------------------------
-- procedure structure for getstatsdatasetcountsandrecords
-- ----------------------------



create procedure [getstatsdatasetcountsandrecords]
as
declare @stats table
(
  datasettype nvarchar(80),
  datasetcount int,
  datarecordcount int
)

insert into @stats(datasettype, datasetcount, datarecordcount)
select top (100) percent ndb.datasettypes.datasettype, count(distinct ndb.datasets.datasetid) as datasetcount, count(ndb.data.dataid) as datarecordcount
from ndb.datasets inner join
     ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
     ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
     ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
group by ndb.datasettypes.datasettype

insert into @stats(datasettype, datasetcount, datarecordcount)
select top (100) percent ndb.datasettypes.datasettype, count(distinct ndb.datasets.datasetid) as datasetcount, count(ndb.geochronology.geochronid) as datarecordcount
from ndb.datasets inner join
     ndb.datasettypes on ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid inner join
     ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
     ndb.geochronology on ndb.samples.sampleid = ndb.geochronology.sampleid
where (ndb.datasettypes.datasettypeid = 1)
group by ndb.datasettypes.datasettype

select top (100) percent datasettype, datasetcount, datarecordcount
from @stats
order by datasettype

go

-- ----------------------------
-- procedure structure for getsynonymsforinvalidtaxonid
-- ----------------------------





create procedure [getsynonymsforinvalidtaxonid](@invalidtaxonid int)
as
select     ndb.taxa.taxonid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.taxa.valid, ndb.taxa.highertaxonid, ndb.taxa.extinct,
                      ndb.taxa.taxagroupid, ndb.taxa.publicationid, ndb.taxa.validatorid, convert(nvarchar(10),validatedate,120) as validatedate, ndb.taxa.notes, ndb.synonyms.synonymtypeid
from        ndb.synonyms inner join
                      ndb.taxa on ndb.synonyms.validtaxonid = ndb.taxa.taxonid
where     (ndb.synonyms.invalidtaxonid = @invalidtaxonid)




go

-- ----------------------------
-- procedure structure for getsynonymsforvalidtaxonid
-- ----------------------------




create procedure [getsynonymsforvalidtaxonid](@validtaxonid int)
as
select     ndb.taxa.taxonid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.taxa.valid, ndb.taxa.highertaxonid, ndb.taxa.extinct,
                      ndb.taxa.taxagroupid, ndb.taxa.publicationid, ndb.taxa.validatorid, convert(nvarchar(10),validatedate,120) as validatedate,
					  ndb.taxa.notes, ndb.synonyms.synonymtypeid
from         ndb.synonyms inner join
                      ndb.taxa on ndb.synonyms.invalidtaxonid = ndb.taxa.taxonid
where     (ndb.synonyms.validtaxonid = @validtaxonid)
go

-- ----------------------------
-- procedure structure for getsynonymtype
-- ----------------------------




create procedure [getsynonymtype](@synonymtype nvarchar(255))
as
select      *
from          ndb.[synonymtypes]
where      (ndb.synonymtypes.synonymtype = @synonymtype)






go

-- ----------------------------
-- procedure structure for getsynonymtypestable
-- ----------------------------

create procedure [getsynonymtypestable]
as select      *
from          ndb.[synonymtypes]



go

-- ----------------------------
-- procedure structure for gettablecolumns
-- ----------------------------


create procedure [gettablecolumns](@tablename nvarchar(80))
as
select
    c.name 'column name',
    t.name 'data type',
    c.max_length 'max length'
from
    sys.columns c
inner join
    sys.types t on c.system_type_id = t.system_type_id
left outer join
    sys.index_columns ic on ic.object_id = c.object_id and ic.column_id = c.column_id
left outer join
    sys.indexes i on ic.object_id = i.object_id and ic.index_id = i.index_id
where
    c.object_id = object_id(@tablename)




go

-- ----------------------------
-- procedure structure for gettablemaxid
-- ----------------------------


create procedure [gettablemaxid](@tablename nvarchar(64), @columnname nvarchar(64))
as
declare @sql nvarchar(500)
set @sql = (n'select max('+@columnname+n') as maxid from '+@tablename)
execute sp_executesql @sql




go

-- ----------------------------
-- procedure structure for gettableminid
-- ----------------------------



create procedure [gettableminid](@tablename nvarchar(64), @columnname nvarchar(64))
as
declare @sql nvarchar(500)
set @sql = (n'select min('+@columnname+n') as minid from '+@tablename)
execute sp_executesql @sql





go

-- ----------------------------
-- procedure structure for gettablerecordcount
-- ----------------------------



create procedure [gettablerecordcount](@tablename nvarchar(64))
as
declare @sql nvarchar(500)
set @sql = (n'select count(*) as count from ndb.'+@tablename)
execute sp_executesql @sql





go

-- ----------------------------
-- procedure structure for gettablerecordcountsbymonth
-- ----------------------------




create procedure [gettablerecordcountsbymonth](@tablename nvarchar(64))
as
declare @sql nvarchar(2000)
set @sql = (n'declare @createdates table (year int, month int)' +
n' insert into @createdates(year, month) select year(recdatecreated), month(recdatecreated) from ndb.' + @tablename +
n' select distinct year, month, count(*) as count, sum(count(*)) over (order by year, month) as runningcount from @createdates' +
n' group by year, month order by year, month')
execute sp_executesql @sql



go

-- ----------------------------
-- procedure structure for gettaphonomicsystembyname
-- ----------------------------




create procedure [gettaphonomicsystembyname](@taphonomicsystem nvarchar(64))
as
select     taphonomicsystemid, taphonomicsystem, notes
from         ndb.taphonomicsystems
where     (taphonomicsystem = @taphonomicsystem)




go

-- ----------------------------
-- procedure structure for gettaphonomicsystemsbydatasettype
-- ----------------------------




create procedure [gettaphonomicsystemsbydatasettype](@datasettypeid int)
as
select     ndb.taphonomicsystems.taphonomicsystemid, ndb.taphonomicsystems.taphonomicsystem, ndb.taphonomicsystems.notes
from         ndb.taphonomicsystemsdatasettypes inner join
                      ndb.taphonomicsystems on ndb.taphonomicsystemsdatasettypes.taphonomicsystemid = ndb.taphonomicsystems.taphonomicsystemid
where     (ndb.taphonomicsystemsdatasettypes.datasettypeid = @datasettypeid)






go

-- ----------------------------
-- procedure structure for gettaphonomicsystemsdatasettypestable
-- ----------------------------





create procedure [gettaphonomicsystemsdatasettypestable]
as
select     ndb.taphonomicsystemsdatasettypes.datasettypeid, ndb.taphonomicsystemsdatasettypes.taphonomicsystemid
from       ndb.taphonomicsystemsdatasettypes







go

-- ----------------------------
-- procedure structure for gettaphonomicsystemstable
-- ----------------------------




create procedure [gettaphonomicsystemstable]
as
select   ndb.taphonomicsystems.taphonomicsystemid, ndb.taphonomicsystems.taphonomicsystem, ndb.taphonomicsystems.notes
from     ndb.taphonomicsystems






go

-- ----------------------------
-- procedure structure for gettaphonomictypeid
-- ----------------------------





create procedure [gettaphonomictypeid](@taphonomicsystemid int, @taphonomictype nvarchar(64))
as
select     ndb.taphonomictypes.taphonomictypeid
from         ndb.taphonomicsystems inner join
                      ndb.taphonomictypes on ndb.taphonomicsystems.taphonomicsystemid = ndb.taphonomictypes.taphonomicsystemid
where     (ndb.taphonomicsystems.taphonomicsystemid = @taphonomicsystemid) and (ndb.taphonomictypes.taphonomictype = @taphonomictype)





go

-- ----------------------------
-- procedure structure for gettaphonomictypesbyidlist
-- ----------------------------



create procedure [gettaphonomictypesbyidlist](@taphonomictypeids nvarchar(max))
as
select     ndb.taphonomictypes.taphonomictypeid, ndb.taphonomictypes.taphonomictype, ndb.taphonomicsystems.taphonomicsystem
from         ndb.taphonomictypes inner join
                      ndb.taphonomicsystems on ndb.taphonomictypes.taphonomicsystemid = ndb.taphonomicsystems.taphonomicsystemid
where     (ndb.taphonomictypes.taphonomictypeid in (
                                                   select value
                                                   from ti.func_intlisttoin(@taphonomictypeids,'$')
                                                   ))






go

-- ----------------------------
-- procedure structure for gettaphonomictypesbysystem
-- ----------------------------



create procedure [gettaphonomictypesbysystem](@taphonomicsystemid int)
as
select     ndb.taphonomictypes.taphonomicsystemid,  ndb.taphonomictypes.taphonomictypeid,  ndb.taphonomictypes.taphonomictype, ndb.taphonomictypes.notes
from         ndb.taphonomictypes
where     (taphonomicsystemid = @taphonomicsystemid)





go

-- ----------------------------
-- procedure structure for gettaphonomictypestable
-- ----------------------------





create procedure [gettaphonomictypestable]
as select     ndb.taphonomictypes.taphonomictypeid, ndb.taphonomictypes.taphonomicsystemid, ndb.taphonomictypes.taphonomictype, ndb.taphonomictypes.notes
from          ndb.taphonomictypes







go

-- ----------------------------
-- procedure structure for gettaxabycodeandtaxagroupid
-- ----------------------------



create procedure [gettaxabycodeandtaxagroupid](@taxoncode nvarchar(64), @taxagroupid nvarchar(3))
as select      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid,
               convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (taxoncode = @taxoncode and taxagroupid = @taxagroupid)





go

-- ----------------------------
-- procedure structure for gettaxabynamelist
-- ----------------------------


create procedure [gettaxabynamelist](@taxanames nvarchar(max))
as
select taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid,
       validatorid, convert(nvarchar(10),validatedate,120) as validatedate, notes
from ndb.taxa
where (taxonname in (
		            select value
		            from ti.func_nvarcharlisttoin(@taxanames,'$')
                    ))




go

-- ----------------------------
-- procedure structure for gettaxabynamescount
-- ----------------------------





-- gets number of samples assigned to analysis unit
create procedure [gettaxabynamescount](@taxanames nvarchar(max))
as
select     count(taxonid) as count
from         ndb.taxa
where     (taxonname in
                          (select value
                            from  ti.func_nvarcharlisttoin(@taxanames, '$') as func_nvarcharlisttoin_1))





go

-- ----------------------------
-- procedure structure for gettaxabytaxagroupid
-- ----------------------------


create procedure [gettaxabytaxagroupid](@taxagroupid nvarchar(3))
as select      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid,
               convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (taxagroupid = @taxagroupid)




go

-- ----------------------------
-- procedure structure for gettaxaecolgroupsbydatasettypelist
-- ----------------------------



create procedure [gettaxaecolgroupsbydatasettypelist](@datasettypeids nvarchar(max))
as
select     top (2147483647) ndb.taxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgrouptypes.ecolgroupid,
                      ndb.ecolgrouptypes.ecolgroup
from         ndb.taxa inner join
                      ndb.ecolgroups on ndb.taxa.taxonid = ndb.ecolgroups.taxonid inner join
                      ndb.ecolgrouptypes on ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid inner join
                      ndb.ecolsettypes on ndb.ecolgroups.ecolsetid = ndb.ecolsettypes.ecolsetid inner join
                      ndb.variables on ndb.taxa.taxonid = ndb.variables.taxonid inner join
                      ndb.data on ndb.variables.variableid = ndb.data.variableid inner join
                      ndb.samples on ndb.data.sampleid = ndb.samples.sampleid inner join
                      ndb.datasets on ndb.samples.datasetid = ndb.datasets.datasetid right outer join
                      ndb.taxagrouptypes on ndb.taxa.taxagroupid = ndb.taxagrouptypes.taxagroupid
where     (ndb.datasets.datasettypeid in (
                                         select value
                                         from ti.func_intlisttoin(@datasettypeids,',')
                                         ))
group by ndb.taxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgrouptypes.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
order by ndb.taxagrouptypes.taxagroup, ndb.ecolgrouptypes.ecolgroup






go

-- ----------------------------
-- procedure structure for gettaxagroupbyid
-- ----------------------------





create procedure [gettaxagroupbyid](@taxagroupid nvarchar(3))
as
select     taxagroupid, taxagroup
from         ndb.taxagrouptypes
where     (taxagroupid = @taxagroupid)







go


-- ----------------------------
-- procedure structure for gettaxagroupecolsetids
-- ----------------------------




create procedure [gettaxagroupecolsetids](@taxagroupid nvarchar(3))
as
select     ndb.taxa.taxagroupid, ndb.ecolgroups.ecolsetid
from         ndb.ecolgroups inner join
                      ndb.taxa on ndb.ecolgroups.taxonid = ndb.taxa.taxonid
group by ndb.taxa.taxagroupid, ndb.ecolgroups.ecolsetid
having      (ndb.taxa.taxagroupid = @taxagroupid)






go


-- ----------------------------
-- procedure structure for gettaxagroupid
-- ----------------------------




create procedure [gettaxagroupid](@taxagroup nvarchar(64))
as
select     taxagroupid, taxagroup
from         ndb.taxagrouptypes
where     (taxagroup like @taxagroup)






go

-- ----------------------------
-- procedure structure for gettaxagrouppublications
-- ----------------------------

create procedure [gettaxagrouppublications](@taxagroupid nvarchar(50))
as select      ndb.taxa.taxagroupid, ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation,
                        ndb.publications.articletitle, ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages,
                        ndb.publications.citationnumber, ndb.publications.doi, ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition,
                        ndb.publications.volumetitle, ndb.publications.seriestitle, ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url,
                        ndb.publications.city, ndb.publications.state, ndb.publications.country, ndb.publications.originallanguage, ndb.publications.notes
from          ndb.taxa inner join
                        ndb.publications on ndb.taxa.publicationid = ndb.publications.publicationid
group by ndb.taxa.taxagroupid, ndb.publications.publicationid, ndb.publications.pubtypeid, ndb.publications.year, ndb.publications.citation,
                        ndb.publications.articletitle, ndb.publications.journal, ndb.publications.volume, ndb.publications.issue, ndb.publications.pages,
                        ndb.publications.citationnumber, ndb.publications.doi, ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition,
                        ndb.publications.volumetitle, ndb.publications.seriestitle, ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url,
                        ndb.publications.city, ndb.publications.state, ndb.publications.country, ndb.publications.originallanguage, ndb.publications.notes
having       (ndb.taxa.taxagroupid = @taxagroupid)



go

-- ----------------------------
-- procedure structure for gettaxagroupsfordatasettype
-- ----------------------------

create procedure [gettaxagroupsfordatasettype](@datasettypeid int)
as
select      ndb.taxa.taxagroupid, ndb.taxagrouptypes.taxagroup
from          ndb.taxagrouptypes inner join
                        ndb.taxa inner join
                        ndb.variables inner join
                        ndb.datasets inner join
                        ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                        ndb.data on ndb.samples.sampleid = ndb.data.sampleid and ndb.samples.sampleid = ndb.data.sampleid on
                        ndb.variables.variableid = ndb.data.variableid and ndb.variables.variableid = ndb.data.variableid on
                        ndb.taxa.taxonid = ndb.variables.taxonid and ndb.taxa.taxonid = ndb.variables.taxonid on
                        ndb.taxagrouptypes.taxagroupid = ndb.taxa.taxagroupid and ndb.taxagrouptypes.taxagroupid = ndb.taxa.taxagroupid
group by ndb.datasets.datasettypeid, ndb.taxa.taxagroupid, ndb.taxagrouptypes.taxagroup
having       (ndb.datasets.datasettypeid = @datasettypeid)






go

-- ----------------------------
-- procedure structure for gettaxalookupsynonymybytaxagroupidlist
-- ----------------------------




create procedure [gettaxalookupsynonymybytaxagroupidlist](@taxagrouplist nvarchar(max))
as
select     ndb.taxa.taxonid, ndb.taxa.taxonname, ndb.synonyms.validtaxonid
from         ndb.taxa inner join
                      ndb.synonyms on ndb.taxa.taxonid = ndb.synonyms.invalidtaxonid
where      (ndb.taxa.valid = 0) and (ndb.taxa.taxagroupid in (
		                            select value
		                            from ti.func_nvarcharlisttoin(@taxagrouplist,'$')
                                    ))






go



-- ----------------------------
-- procedure structure for gettaxonhierarchy
-- ----------------------------


create procedure [gettaxonhierarchy](@taxonname nvarchar(80))
as
declare @hierarchy table
(
  taxonid int,
  taxonname nvarchar(80),
  valid bit,
  highertaxonid int
)
declare @taxonid int
declare @higherid int
insert into @hierarchy (taxonid, taxonname, valid, highertaxonid)
  select  taxonid, taxonname, valid, highertaxonid
  from    ndb.taxa
  where   (taxonname = @taxonname);
set @taxonid = (select taxonid from ndb.taxa where (taxonname = @taxonname))
set @higherid = (select highertaxonid from ndb.taxa where (taxonname = @taxonname))

while @taxonid <> @higherid
begin
  insert into @hierarchy (taxonid, taxonname, valid, highertaxonid)
    select  taxonid, taxonname, valid, highertaxonid
    from    ndb.taxa
    where   (taxonid = @higherid);
  set @taxonid = (select taxonid from ndb.taxa where (taxonid = @higherid))
  set @higherid = (select highertaxonid from ndb.taxa where (taxonid = @taxonid))
end

select  taxonid, taxonname, valid, highertaxonid
from    @hierarchy






go


-----------------------
-- procedure structure for getvalidtaxabytaxagroupidlist
-- ----------------------------


create procedure [getvalidtaxabytaxagroupidlist](@taxagrouplist nvarchar(max))
as
select     taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid,
           validatorid, convert(nvarchar(10),validatedate,120) as validatedate, notes
from          ndb.taxa
where      (valid = 1) and (taxagroupid in (
		                   select value
		                   from ti.func_nvarcharlisttoin(@taxagrouplist,'$')
                           ))




go


-- ----------------------------
-- procedure structure for getvariablesbytaxagroupidlist
-- ----------------------------


create procedure [getvariablesbytaxagroupidlist](@taxagrouplist nvarchar(max))
as select ndb.variables.*
from      ndb.variables inner join ndb.taxa on ndb.variables.taxonid = ndb.taxa.taxonid
where     (ndb.taxa.taxagroupid in (
		                           select value
		                           from ti.func_nvarcharlisttoin(@taxagrouplist,'$')
                                   ))




go
