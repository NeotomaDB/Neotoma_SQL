/*
navicat sql server data transfer

source server         : db5-emswin-neotomadev
source server version : 110000
source host           : db5.emswin.psu.edu:1433
source database       : neotoma
source schema         : ts

target server type    : sql server
target server version : 110000
file encoding         : 65001

date: 2018-06-27 14:34:49
*/


-- ----------------------------
-- procedure structure for checksteward
-- ----------------------------



create procedure [checksteward]

@username nvarchar(80),
@pwd nvarchar(80)

 as

set nocount on

select stewardid, authorized
from ts.stewardauthorization
where username = @username and pwd = @pwd

   return

set nocount off




go

-- ----------------------------
-- procedure structure for combinecontacts
-- ----------------------------



create procedure [combinecontacts](@keepcontactid int, @contactidlist nvarchar(max))
as
-- declare @keepcontactid int
-- set @keepcontactid = 1524
-- declare @contactidlist nvarchar(max)
-- set @contactidlist = n'1524$7393$9040'

declare @n int

declare @contactids table (id int not null primary key identity(1,1),
                           contactid int)

insert into @contactids (contactid)
select      contactid
from        ndb.contacts
where       (contactid in (
		             select value
		             from ti.func_nvarcharlisttoin(@contactidlist,'$')
                     ))

declare @nrows int = @@rowcount
declare @currentid int = 0
declare @contactid int
while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	set @contactid = (select contactid from @contactids where id = @currentid)
	if @contactid <> @keepcontactid
	  begin
	    if (select count(contactid) from ndb.publicationauthors where (contactid = @contactid)) > 0
		  begin
		    update ndb.publicationauthors
            set    ndb.publicationauthors.contactid = @keepcontactid
            where  (ndb.publicationauthors.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.chronologies where (contactid = @contactid)) > 0
		  begin
		    update ndb.chronologies
            set    ndb.chronologies.contactid = @keepcontactid
            where  (ndb.chronologies.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.collectors where (contactid = @contactid)) > 0
		  begin
		    update ndb.collectors
            set    ndb.collectors.contactid = @keepcontactid
            where  (ndb.collectors.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.constituentdatabases where (contactid = @contactid)) > 0
		  begin
		    update ndb.constituentdatabases
            set    ndb.constituentdatabases.contactid = @keepcontactid
            where  (ndb.constituentdatabases.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.dataprocessors where (contactid = @contactid)) > 0
		  begin
		    update ndb.dataprocessors
            set    ndb.dataprocessors.contactid = @keepcontactid
            where  (ndb.dataprocessors.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.datasetpis where (contactid = @contactid)) > 0
		  begin
		    update ndb.datasetpis
            set    ndb.datasetpis.contactid = @keepcontactid
            where  (ndb.datasetpis.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.datasetsubmissions where (contactid = @contactid)) > 0
		  begin
		    update ndb.datasetsubmissions
            set    ndb.datasetsubmissions.contactid = @keepcontactid
            where  (ndb.datasetsubmissions.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.datasettaxonnotes where (contactid = @contactid)) > 0
		  begin
		    update ndb.datasettaxonnotes
            set    ndb.datasettaxonnotes.contactid = @keepcontactid
            where  (ndb.datasettaxonnotes.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.datataxonnotes where (contactid = @contactid)) > 0
		  begin
		    update ndb.datataxonnotes
            set    ndb.datataxonnotes.contactid = @keepcontactid
            where  (ndb.datataxonnotes.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.sampleanalysts where (contactid = @contactid)) > 0
		  begin
		    update ndb.sampleanalysts
            set    ndb.sampleanalysts.contactid = @keepcontactid
            where  (ndb.sampleanalysts.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.siteimages where (contactid = @contactid)) > 0
		  begin
		    update ndb.siteimages
            set    ndb.siteimages.contactid = @keepcontactid
            where  (ndb.siteimages.contactid = @contactid)
		  end
        if (select count(contactid) from ti.stewardupdates where (contactid = @contactid)) > 0
		  begin
		    update ti.stewardupdates
            set    ti.stewardupdates.contactid = @keepcontactid
            where  (ti.stewardupdates.contactid = @contactid)
		  end
        if (select count(contactid) from ndb.synonymy where (contactid = @contactid)) > 0
		  begin
		    update ndb.synonymy
            set    ndb.synonymy.contactid = @keepcontactid
            where  (ndb.synonymy.contactid = @contactid)
		  end
        if (select count(validatorid) from ndb.taxa where (validatorid = @contactid)) > 0
		  begin
		    update ndb.taxa
            set    ndb.taxa.validatorid = @keepcontactid
            where  (ndb.taxa.validatorid = @contactid)
		  end
        if (select count(analystid) from ndb.isometadata where (analystid = @contactid)) > 0
		  begin
		    update ndb.isometadata
            set    ndb.isometadata.analystid = @keepcontactid
            where  (ndb.isometadata.analystid = @contactid)
		  end
        delete from ndb.contacts where (ndb.contacts.contactid = @contactid)
	  end
  end

go

-- ----------------------------
-- procedure structure for deleteanalysisunit
-- ----------------------------




create procedure [deleteanalysisunit](@analunitid int)
as
delete from ndb.analysisunits
where analysisunitid = @analunitid






go

-- ----------------------------
-- procedure structure for deletechronology
-- ----------------------------






create procedure [deletechronology](@chronologyid int)
as
/* nuke geochroncontrols */
declare @geochroncontrols table
(
  chroncontrolid int,
  geochronid int,
  primary key (chroncontrolid, geochronid)
)

insert into @geochroncontrols(chroncontrolid, geochronid)
select     ndb.geochroncontrols.chroncontrolid, ndb.geochroncontrols.geochronid
from       ndb.chronologies inner join
                      ndb.chroncontrols on ndb.chronologies.chronologyid = ndb.chroncontrols.chronologyid inner join
                      ndb.geochroncontrols on ndb.chroncontrols.chroncontrolid = ndb.geochroncontrols.chroncontrolid
where     (ndb.chronologies.chronologyid = @chronologyid)

declare @chroncontrolid int
declare @geochronid int
while (select count(*) from @geochroncontrols) > 0
  begin
    set @chroncontrolid = (select top (1) chroncontrolid from @geochroncontrols)
    set @geochronid = (select top (1) geochronid from @geochroncontrols)
	delete from ndb.geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
	delete from @geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
  end


/* nuke chronology */
delete from ndb.chronologies where chronologyid = @chronologyid



go

-- ----------------------------
-- procedure structure for deletecollectionunit
-- ----------------------------






create procedure [deletecollectionunit](@collectionunitid int)
as
/* nuke geochroncontrols */
declare @geochroncontrols table
(
  chroncontrolid int,
  geochronid int,
  primary key (chroncontrolid, geochronid)
)

insert into @geochroncontrols(chroncontrolid, geochronid)
select  ndb.geochroncontrols.chroncontrolid, ndb.geochroncontrols.geochronid
from    ndb.collectionunits inner join
                    ndb.chronologies on ndb.collectionunits.collectionunitid = ndb.chronologies.collectionunitid inner join
                    ndb.chroncontrols on ndb.chronologies.chronologyid = ndb.chroncontrols.chronologyid inner join
                    ndb.geochroncontrols on ndb.chroncontrols.chroncontrolid = ndb.geochroncontrols.chroncontrolid
where   (ndb.collectionunits.collectionunitid = @collectionunitid)


declare @chroncontrolid int
declare @geochronid int
while (select count(*) from @geochroncontrols) > 0
  begin
    set @chroncontrolid = (select top (1) chroncontrolid from @geochroncontrols)
    set @geochronid = (select top (1) geochronid from @geochroncontrols)
	delete from ndb.geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
	delete from @geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
  end


/* nuke chronologies */
declare @chronologyids table
(
  chronologyid int primary key
)

insert into @chronologyids(chronologyid)
select  ndb.chronologies.chronologyid
from    ndb.collectionunits inner join
                  ndb.chronologies on ndb.collectionunits.collectionunitid = ndb.chronologies.collectionunitid
where   (ndb.collectionunits.collectionunitid = @collectionunitid)


declare @chronid int
while (select count(*) from @chronologyids) > 0
  begin
    set @chronid = (select top 1 chronologyid from @chronologyids)
	delete from ndb.chronologies where chronologyid = @chronid
	delete from @chronologyids where chronologyid = @chronid
  end

/* nuke samples */
declare @sampleids table
(
  sampleid int primary key
)

insert into @sampleids(sampleid)
select     ndb.samples.sampleid
from       ndb.collectionunits inner join
                      ndb.analysisunits on ndb.collectionunits.collectionunitid = ndb.analysisunits.collectionunitid inner join
                      ndb.samples on ndb.analysisunits.analysisunitid = ndb.samples.analysisunitid
where      (ndb.collectionunits.collectionunitid = @collectionunitid)

declare @sampleid int
while (select count(*) from @sampleids) > 0
  begin
    set @sampleid = (select top 1 sampleid from @sampleids)
	delete from ndb.samples where sampleid = @sampleid
	delete from @sampleids where sampleid = @sampleid
  end

/* nuke analysisunits */
declare @analunitids table
(
  analunitid int primary key
)

insert into @analunitids(analunitid)
select     ndb.analysisunits.analysisunitid
from       ndb.collectionunits inner join
                      ndb.analysisunits on ndb.collectionunits.collectionunitid = ndb.analysisunits.collectionunitid
where      (ndb.collectionunits.collectionunitid = @collectionunitid)


declare @analunitid int
while (select count(*) from @analunitids) > 0
  begin
    set @analunitid = (select top 1 analunitid from @analunitids)
	delete from ndb.analysisunits where analysisunitid = @analunitid
	delete from @analunitids where analunitid = @analunitid
  end

delete from ndb.collectionunits
where collectionunitid = @collectionunitid


go

-- ----------------------------
-- procedure structure for deletecollectors
-- ----------------------------





create procedure [deletecollectors](@collunitid int)
as
delete from ndb.collectors
where collectionunitid = @collunitid









go

-- ----------------------------
-- procedure structure for deletedata
-- ----------------------------




create procedure [deletedata](@dataid int)
as
delete from ndb.data
where dataid = @dataid






go

-- ----------------------------
-- procedure structure for deletedataprocessor
-- ----------------------------






create procedure [deletedataprocessor](@datasetid int, @contactid int)
as
delete from ndb.dataprocessors
where (ndb.dataprocessors.datasetid = @datasetid) and (ndb.dataprocessors.contactid = @contactid)





go

-- ----------------------------
-- procedure structure for deletedataset
-- ----------------------------





create procedure [deletedataset](@datasetid int)
as
delete from ndb.samples
where datasetid = @datasetid
delete from ndb.datasets
where datasetid = @datasetid






go

-- ----------------------------
-- procedure structure for deletedatasetpi
-- ----------------------------





create procedure [deletedatasetpi](@datasetid int, @contactid int)
as
declare @datasetpis table
(
  id int not null primary key identity(1,1),
  contactid int,
  piorder int
)


delete from ndb.datasetpis
where (ndb.datasetpis.datasetid = @datasetid) and (ndb.datasetpis.contactid = @contactid)

declare @npis int
set @npis = (select count(*) from ndb.datasetpis where (datasetid = @datasetid))
if @npis > 0
  begin
    insert into @datasetpis (contactid, piorder)
    select      contactid, piorder from ndb.datasetpis where (datasetid = @datasetid)
	order by    ndb.datasetpis.piorder
	declare @tcontactid int
	declare @currentid int = 0
	while @currentid < @npis
      begin
	    set @currentid = @currentid+1
		set @tcontactid = (select contactid from @datasetpis where (id = @currentid))
		update ndb.datasetpis
        set    ndb.datasetpis.piorder = @currentid
        where  (ndb.datasetpis.datasetid = @datasetid) and (ndb.datasetpis.contactid = @tcontactid)
      end
  end





go

-- ----------------------------
-- procedure structure for deletedatasetpublication
-- ----------------------------



create procedure [deletedatasetpublication](@datasetid int, @publicationid int)
as
delete from ndb.datasetpublications
where (datasetid = @datasetid and publicationid = @publicationid)







go

-- ----------------------------
-- procedure structure for deletedatasettaxonnotes
-- ----------------------------





create procedure [deletedatasettaxonnotes](@datasetid int, @taxonid int, @contactid int)
as
delete from ndb.datasettaxonnotes
where datasetid = @datasetid and taxonid = @taxonid

insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
values      (@contactid, n'datasettaxonnotes', @datasetid, @taxonid, n'delete')





go

-- ----------------------------
-- procedure structure for deletedatasetvariable
-- ----------------------------






create procedure [deletedatasetvariable](@datasetid int, @variableid int)
as

delete from ndb.data
where dataid in (select ndb.data.dataid
                 from ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid
                 where     (ndb.samples.datasetid = @datasetid) and (ndb.data.variableid = @variableid))

go

-- ----------------------------
-- procedure structure for deletedepenvttype
-- ----------------------------


create procedure [deletedepenvttype](@depenvtid int)
as delete from ndb.depenvttypes
where depenvtid = @depenvtid






go

-- ----------------------------
-- procedure structure for deleteecolgroup
-- ----------------------------



create procedure [deleteecolgroup](@taxonid int, @ecolsetid int)
as
delete from ndb.ecolgroups
where taxonid = @taxonid and ecolsetid = @ecolsetid





go

-- ----------------------------
-- procedure structure for deleteeventpublication
-- ----------------------------




create procedure [deleteeventpublication](@eventid int, @publicationid int)
as
delete from ndb.eventpublications
where eventid = @eventid and publicationid = @publicationid






go

-- ----------------------------
-- procedure structure for deletegeochron
-- ----------------------------




create procedure [deletegeochron](@geochronid int)
as

if (select count(geochronid) from ndb.geochroncontrols where (geochronid = @geochronid)) > 0
  begin
    delete from ndb.geochroncontrols
	where (geochronid = @geochronid)
  end
delete from ndb.geochronology
where geochronid = @geochronid






go

-- ----------------------------
-- procedure structure for deletegeochroncontrol
-- ----------------------------




create procedure [deletegeochroncontrol](@chroncontrolid int)
as
if (select  count(chroncontrolid) from ndb.geochroncontrols where (chroncontrolid = @chroncontrolid)) > 0
  begin
    delete from ndb.geochroncontrols
	where (chroncontrolid = @chroncontrolid)
  end
delete from ndb.chroncontrols
where (chroncontrolid = @chroncontrolid)





go

-- ----------------------------
-- procedure structure for deletegeochronpublication
-- ----------------------------





create procedure [deletegeochronpublication](@geochronid int, @publicationid int)
as
delete from ndb.geochronpublications
where (geochronid = @geochronid and publicationid = @publicationid)






go

-- ----------------------------
-- procedure structure for deletepublicationauthor
-- ----------------------------



create procedure [deletepublicationauthor](@authorid int)
as delete from ndb.publicationauthors
where authorid = @authorid







go

-- ----------------------------
-- procedure structure for deletepublicationeditor
-- ----------------------------




create procedure [deletepublicationeditor](@editorid int)
as delete from ndb.publicationeditors
where editorid = @editorid








go

-- ----------------------------
-- procedure structure for deletepublicationtranslator
-- ----------------------------




create procedure [deletepublicationtranslator](@translatorid int)
as delete from ndb.publicationtranslators
where translatorid = @translatorid








go

-- ----------------------------
-- procedure structure for deleterelativeagepublication
-- ----------------------------


create procedure [deleterelativeagepublication](@relativeageid int, @publicationid int)
as
delete from ndb.relativeagepublications
where relativeageid = @relativeageid and publicationid = @publicationid







go

-- ----------------------------
-- procedure structure for deleterepositoryspecimen
-- ----------------------------





create procedure [deleterepositoryspecimen](@datasetid int, @repositoryid int)
as
delete from ndb.repositoryspecimens
where       (datasetid = @datasetid) and (repositoryid = @repositoryid)

-- insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
-- values      (@contactid, n'repositoryspecimens', @datasetid, @repositoryid, n'delete')





go

-- ----------------------------
-- procedure structure for deletesample
-- ----------------------------



create procedure [deletesample](@sampleid int)
as
delete from ndb.samples
where sampleid = @sampleid





go

-- ----------------------------
-- procedure structure for deletesampleanalysts
-- ----------------------------




create procedure [deletesampleanalysts](@sampleid int)
as
delete from ndb.sampleanalysts
where sampleid = @sampleid






go

-- ----------------------------
-- procedure structure for deletesite
-- ----------------------------





create procedure [deletesite](@siteid int)
as
/* nuke geochroncontrols */
declare @geochroncontrols table
(
  chroncontrolid int,
  geochronid int,
  primary key (chroncontrolid, geochronid)
)

insert into @geochroncontrols(chroncontrolid, geochronid)
select  ndb.geochroncontrols.chroncontrolid, ndb.geochroncontrols.geochronid
from    ndb.sites inner join
                    ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                    ndb.chronologies on ndb.collectionunits.collectionunitid = ndb.chronologies.collectionunitid inner join
                    ndb.chroncontrols on ndb.chronologies.chronologyid = ndb.chroncontrols.chronologyid inner join
                    ndb.geochroncontrols on ndb.chroncontrols.chroncontrolid = ndb.geochroncontrols.chroncontrolid
where   (ndb.sites.siteid = @siteid)

declare @chroncontrolid int
declare @geochronid int
while (select count(*) from @geochroncontrols) > 0
  begin
    set @chroncontrolid = (select top (1) chroncontrolid from @geochroncontrols)
    set @geochronid = (select top (1) geochronid from @geochroncontrols)
	delete from ndb.geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
	delete from @geochroncontrols where (chroncontrolid = @chroncontrolid and geochronid = @geochronid)
  end


/* nuke chronologies */
declare @chronologyids table
(
  chronologyid int primary key
)

insert into @chronologyids(chronologyid)
select  ndb.chronologies.chronologyid
from    ndb.sites inner join
                  ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                  ndb.chronologies on ndb.collectionunits.collectionunitid = ndb.chronologies.collectionunitid
where   (ndb.sites.siteid = @siteid)

declare @chronid int
while (select count(*) from @chronologyids) > 0
  begin
    set @chronid = (select top 1 chronologyid from @chronologyids)
	delete from ndb.chronologies where chronologyid = @chronid
	delete from @chronologyids where chronologyid = @chronid
  end

/* nuke samples */
declare @sampleids table
(
  sampleid int primary key
)

insert into @sampleids(sampleid)
select     ndb.samples.sampleid
from       ndb.sites inner join
                      ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                      ndb.analysisunits on ndb.collectionunits.collectionunitid = ndb.analysisunits.collectionunitid inner join
                      ndb.samples on ndb.analysisunits.analysisunitid = ndb.samples.analysisunitid
where      (ndb.sites.siteid = @siteid)

declare @sampleid int
while (select count(*) from @sampleids) > 0
  begin
    set @sampleid = (select top 1 sampleid from @sampleids)
	delete from ndb.samples where sampleid = @sampleid
	delete from @sampleids where sampleid = @sampleid
  end

/* nuke analysisunits */
declare @analunitids table
(
  analunitid int primary key
)

insert into @analunitids(analunitid)
select     ndb.analysisunits.analysisunitid
from       ndb.sites inner join
                      ndb.collectionunits on ndb.sites.siteid = ndb.collectionunits.siteid inner join
                      ndb.analysisunits on ndb.collectionunits.collectionunitid = ndb.analysisunits.collectionunitid
where      (ndb.sites.siteid = @siteid)

declare @analunitid int
while (select count(*) from @analunitids) > 0
  begin
    set @analunitid = (select top 1 analunitid from @analunitids)
	delete from ndb.analysisunits where analysisunitid = @analunitid
	delete from @analunitids where analunitid = @analunitid
  end

delete from ndb.sites
where siteid = @siteid

go

-- ----------------------------
-- procedure structure for deletesynonymy
-- ----------------------------




create procedure [deletesynonymy](@synonymyid int, @contactid int)
as
delete from ndb.synonymy
where synonymyid = @synonymyid

insert into ti.stewardupdates(contactid, tablename, pk1, operation)
values      (@contactid, n'synonymy', @synonymyid, n'delete')




go

-- ----------------------------
-- procedure structure for deletetaxon
-- ----------------------------




create procedure [deletetaxon](@taxonid int)
as
if (select count(highertaxonid) from ndb.taxaalthierarchy where (highertaxonid = @taxonid)) > 0
  begin
    delete from ndb.taxaalthierarchy
	where (highertaxonid = @taxonid)
  end
delete from ndb.taxa
where taxonid = @taxonid

go

-- ----------------------------
-- procedure structure for deletevariablebyvariableid
-- ----------------------------



create procedure [deletevariablebyvariableid](@variableid int)
as
delete from ndb.variables
where variableid = @variableid





go

-- ----------------------------
-- procedure structure for deletevariablecontext
-- ----------------------------




create procedure [deletevariablecontext](@variablecontextid int)
as
delete from ndb.variablecontexts
where variablecontextid = @variablecontextid




go

-- ----------------------------
-- procedure structure for deletevariablesbytaxonid
-- ----------------------------


create procedure [deletevariablesbytaxonid](@taxonid int)
as
delete from ndb.variables
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for insertaccumulationrate
-- ----------------------------



create procedure [insertaccumulationrate](@analysisunitid int, @chronologyid int, @accrate float, @variableunitsid int)

as insert into ndb.accumulationrates(analysisunitid, chronologyid, accumulationrate, variableunitsid)
values      (@analysisunitid, @chronologyid, @accrate, @variableunitsid)

go

-- ----------------------------
-- procedure structure for insertaggregatechronology
-- ----------------------------


create procedure [insertaggregatechronology](@aggregatedatasetid int,
@agetypeid int,
@isdefault bit,
@chronologyname nvarchar(80),
@ageboundyounger int,
@ageboundolder int,
@notes nvarchar(max) = null)
as
insert into ndb.aggregatechronologies(aggregatedatasetid, agetypeid, isdefault, chronologyname, ageboundyounger, ageboundolder, notes)
values      (@aggregatedatasetid, @agetypeid, @isdefault, @chronologyname, @ageboundyounger, @ageboundolder, @notes)

---return id
select scope_identity()

go

-- ----------------------------
-- procedure structure for insertaggregatedataset
-- ----------------------------


create procedure [insertaggregatedataset](@name nvarchar(80), @ordertypeid int, @notes nvarchar(max) = null)
as
insert into ndb.aggregatedatasets(aggregatedatasetname, aggregateordertypeid, notes)
values      (@name, @ordertypeid, @notes)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertaggregatesample
-- ----------------------------


create procedure [insertaggregatesample](@aggregatedatasetid int, @sampleid int)
as
insert into ndb.aggregatesamples(aggregatedatasetid, sampleid)
values      (@aggregatedatasetid, @sampleid)

go

-- ----------------------------
-- procedure structure for insertaggregatesampleages
-- ----------------------------




create procedure [insertaggregatesampleages](@aggregatedatasetid int, @aggregatechronid int)
as
declare @sampleageids table
(
  id int not null primary key identity(1,1),
  sampleageid int
)

insert into @sampleageids (sampleageid)
select   ndb.sampleages.sampleageid
from     ndb.aggregatesamples inner join
            ndb.sampleages on ndb.aggregatesamples.sampleid = ndb.sampleages.sampleid
where   (ndb.aggregatesamples.aggregatedatasetid = @aggregatedatasetid)

declare @nrows int = @@rowcount
declare @currentid int = 0
declare @sampleageid int
declare @count int

while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	set @sampleageid = (select sampleageid from @sampleageids where id = @currentid)
	set @count = (select count(*) from ndb.aggregatesampleages
                  where (sampleageid = @sampleageid) and (aggregatedatasetid = @aggregatedatasetid) and (aggregatechronid = @aggregatechronid))
	if @count = 0
	  begin
	    insert into ndb.aggregatesampleages (aggregatedatasetid, aggregatechronid, sampleageid)
        values      (@aggregatedatasetid, @aggregatechronid, @sampleageid)
	  end
  end


go

-- ----------------------------
-- procedure structure for insertanalysisunit
-- ----------------------------




create procedure [insertanalysisunit](@collectionunitid int,
@analysisunitname nvarchar(80) = null,
@depth float = null,
@thickness float = null,
@faciesid int = null,
@mixed bit = null,
@igsn nvarchar(40) = null,
@notes nvarchar(max) = null)

as insert into ndb.analysisunits(collectionunitid, analysisunitname, depth, thickness, faciesid, mixed, igsn, notes)
values      (@collectionunitid, @analysisunitname, @depth, @thickness, @faciesid, @mixed, @igsn, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertanalysisunitaltdepth
-- ----------------------------




create procedure [insertanalysisunitaltdepth](@analysisunitid int, @altdepthscaleid int, @altdepth float)

as
insert into ndb.analysisunitaltdepths(analysisunitid, altdepthscaleid, altdepth)
values      (@analysisunitid, @altdepthscaleid, @altdepth)




go

-- ----------------------------
-- procedure structure for insertanalysisunitaltdepthscale
-- ----------------------------





create procedure [insertanalysisunitaltdepthscale](@altdepthid int,
@altdepthname nvarchar(80),
@variableunitsid int,
@notes nvarchar(max) = null)

as insert into ndb.analysisunitaltdepthscales(altdepthid, altdepthname, variableunitsid, notes)
values      (@altdepthid, @altdepthname, @variableunitsid, @notes)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertcalibrationprogram
-- ----------------------------




create procedure [insertcalibrationprogram](@calibrationprogram nvarchar(24), @version nvarchar(24))

as
insert into ndb.calibrationprograms(calibrationprogram, version)
values      (@calibrationprogram, @version)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertchroncontrol
-- ----------------------------



create procedure [insertchroncontrol](@chronologyid int,
@chroncontroltypeid int,
@analysisunitid int = null,
@depth float = null,
@thickness float = null,
@agetypeid int = null,
@age float = null,
@agelimityounger float = null,
@agelimitolder float = null,
@notes nvarchar(max) = null)

as insert into ndb.chroncontrols(chronologyid, chroncontroltypeid, analysisunitid, depth, thickness, agetypeid, age, agelimityounger, agelimitolder, notes)
values      (@chronologyid, @chroncontroltypeid, @analysisunitid, @depth, @thickness, @agetypeid, @age, @agelimityounger, @agelimitolder, @notes)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertchroncontrolcal14c
-- ----------------------------




create procedure [insertchroncontrolcal14c](@chroncontrolid int, @calibrationcurveid int, @calibrationprogramid int)

as insert into ndb.chroncontrolscal14c(chroncontrolid, calibrationcurveid, calibrationprogramid)
values      (@chroncontrolid, @calibrationcurveid, @calibrationprogramid)


go

-- ----------------------------
-- procedure structure for insertchroncontroltype
-- ----------------------------



create procedure [insertchroncontroltype](@chroncontroltype nvarchar(64), @higherchroncontroltypeid int)
as
insert into ndb.chroncontroltypes(chroncontroltype, higherchroncontroltypeid)
values      (@chroncontroltype, @higherchroncontroltypeid)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertchronology
-- ----------------------------



create procedure [insertchronology](@collectionunitid int,
@agetypeid int,
@contactid int = null,
@isdefault bit,
@chronologyname nvarchar(80) = null,
@dateprepared date = null,
@agemodel nvarchar(80) = null,
@ageboundyounger int = null,
@ageboundolder int = null,
@notes nvarchar(max) = null)

as insert into ndb.chronologies(collectionunitid, agetypeid, contactid, isdefault, chronologyname, dateprepared, agemodel, ageboundyounger, ageboundolder, notes)
values      (@collectionunitid, @agetypeid, @contactid, @isdefault, @chronologyname, convert(datetime, @dateprepared, 105), @agemodel, @ageboundyounger, @ageboundolder, @notes)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertcollectionunit
-- ----------------------------



create procedure [insertcollectionunit](@handle nvarchar(10),
@siteid int,
@colltypeid int = null,
@depenvtid int = null,
@collunitname nvarchar(255) = null,
@colldate date = null,
@colldevice nvarchar(255) = null,
@gpslatitude float = null,
@gpslongitude float = null,
@gpsaltitude float = null,
@gpserror float = null,
@waterdepth float = null,
@watertabledepth float = null,
@substrateid int = null,
@slopeaspect int = null,
@slopeangle int = null,
@location nvarchar(255) = null,
@notes nvarchar(max) = null)

as insert into ndb.collectionunits
                        (handle, siteid, colltypeid, depenvtid, collunitname, colldate, colldevice, gpslatitude, gpslongitude, gpsaltitude, gpserror,
						 waterdepth, substrateid, slopeaspect, slopeangle, location, notes)
values      (@handle, @siteid, @colltypeid, @depenvtid, @collunitname, convert(datetime, @colldate, 105), @colldevice, @gpslatitude, @gpslongitude,
             @gpsaltitude, @gpserror, @waterdepth, @substrateid, @slopeaspect, @slopeangle, @location, @notes)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertcollector
-- ----------------------------




create procedure [insertcollector](@collunitid int, @contactid int, @collectororder int)

as insert into ndb.collectors(collectionunitid, contactid, collectororder)
values      (@collunitid, @contactid, @collectororder)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertcontact
-- ----------------------------


create procedure [insertcontact](@aliasid int = null,
@contactname nvarchar(80),
@statusid int = null,
@familyname nvarchar(80) = null,
@initials nvarchar(16) = null,
@givennames nvarchar(80) = null,
@suffix nvarchar(16) = null,
@title nvarchar(16) = null,
@phone nvarchar(64) = null,
@fax nvarchar(64) = null,
@email nvarchar(64) = null,
@url nvarchar(255) = null,
@address nvarchar(max) = null,
@notes nvarchar(max) = null)

as insert into ndb.contacts
                           (aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes)
values      (@aliasid, @contactname, @statusid, @familyname, @initials, @givennames, @suffix, @title, @phone, @fax, @email, @url, @address, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertcontextdatasettypes
-- ----------------------------



create procedure [insertcontextdatasettypes](@datasettypeid int, @variablecontextid int)

as
insert into ndb.contextsdatasettypes(datasettypeid, variablecontextid)
values      (@datasettypeid, @variablecontextid)


go

-- ----------------------------
-- procedure structure for insertdata
-- ----------------------------


create procedure [insertdata](@sampleid int, @variableid int, @value float)

as insert into ndb.data(sampleid, variableid, value)
values      (@sampleid, @variableid, @value)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertdataprocessor
-- ----------------------------




create procedure [insertdataprocessor](@datasetid int, @contactid int)

as
insert into ndb.dataprocessors(datasetid, contactid)
values      (@datasetid, @contactid)






go

-- ----------------------------
-- procedure structure for insertdataset
-- ----------------------------

create procedure [insertdataset](@collectionunitid int,
@datasettypeid int,
@datasetname nvarchar(80) = null,
@notes nvarchar(max) = null)

as insert into ndb.datasets(collectionunitid, datasettypeid, datasetname, notes)
values      (@collectionunitid, @datasettypeid, @datasetname, @notes)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertdatasetdatabase
-- ----------------------------



create procedure [insertdatasetdatabase](@datasetid int, @databaseid int)

as
insert into ndb.datasetdatabases(datasetid, databaseid)
values      (@datasetid, @databaseid)





go

-- ----------------------------
-- procedure structure for insertdatasetpi
-- ----------------------------



create procedure [insertdatasetpi](@datasetid int, @contactid int, @piorder int)

as
insert into ndb.datasetpis(datasetid, contactid, piorder)
values      (@datasetid, @contactid, @piorder)





go

-- ----------------------------
-- procedure structure for insertdatasetpublication
-- ----------------------------



create procedure [insertdatasetpublication](@datasetid int, @publicationid int, @primarypub bit)

as
declare @nrecs int
set @nrecs = (select count(*) from ndb.datasetpublications group by datasetid, publicationid having (datasetid = @datasetid) and (publicationid = @publicationid))
if (@nrecs is null)
begin
  insert into ndb.datasetpublications(datasetid, publicationid, primarypub)
  values      (@datasetid, @publicationid, @primarypub)
end





go

-- ----------------------------
-- procedure structure for insertdatasetrepository
-- ----------------------------



create procedure [insertdatasetrepository](@datasetid int, @repositoryid int, @notes nvarchar(max) = null)

as
insert into ndb.repositoryspecimens(datasetid, repositoryid, notes)
values      (@datasetid, @repositoryid, @notes)





go

-- ----------------------------
-- procedure structure for insertdatasetsubmission
-- ----------------------------



create procedure [insertdatasetsubmission](@datasetid int,
@databaseid int,
@contactid int,
@submissiontypeid int,
@submissiondate date,
@notes nvarchar(max) = null)

as
insert into ndb.datasetsubmissions(datasetid, databaseid, contactid, submissiontypeid, submissiondate, notes)
values      (@datasetid, @databaseid, @contactid, @submissiontypeid, convert(datetime, @submissiondate, 105), @notes)


---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertdatasettaxonnotes
-- ----------------------------




create procedure [insertdatasettaxonnotes](@datasetid int, @taxonid int, @contactid int, @date date, @notes nvarchar(max), @update bit = 0)

as
insert into ndb.datasettaxonnotes(datasetid, taxonid, contactid, date, notes)
values      (@datasetid, @taxonid, @contactid, convert(datetime, @date, 105), @notes)
if @update = 1
  begin
    insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
    values      (@contactid, n'datasettaxonnotes', @datasetid, @taxonid, n'insert')
  end

go

-- ----------------------------
-- procedure structure for insertdepagent
-- ----------------------------





create procedure [insertdepagent](@analysisunitid int, @depagentid int)

as
insert into ndb.depagents(analysisunitid, depagentid)
values      (@analysisunitid, @depagentid)





go

-- ----------------------------
-- procedure structure for insertdepagenttypes
-- ----------------------------



create procedure [insertdepagenttypes](@depagent nvarchar(64))
as
insert into ndb.depagenttypes(depagent)
values      (@depagent)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertdepenvttype
-- ----------------------------


create procedure [insertdepenvttype](@depenvt nvarchar(255),
@depenvthigherid int = null)
as insert into ndb.depenvttypes
                        (depenvt, depenvthigherid)
values      (@depenvt, @depenvthigherid)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertecolgroup
-- ----------------------------



create procedure [insertecolgroup](@taxonid int, @ecolsetid int, @ecolgroupid nvarchar(4))

as
insert into ndb.ecolgroups (taxonid, ecolsetid, ecolgroupid)
values      (@taxonid, @ecolsetid, @ecolgroupid)



go

-- ----------------------------
-- procedure structure for insertecolgrouptype
-- ----------------------------


create procedure [insertecolgrouptype](@ecolgroupid nvarchar(4), @ecolgroup nvarchar(64))

as
insert into ndb.ecolgrouptypes (ecolgroupid, ecolgroup)
values      (@ecolgroupid, @ecolgroup)


go

-- ----------------------------
-- procedure structure for insertelementdatasettaxagroups
-- ----------------------------





create procedure [insertelementdatasettaxagroups](@datasettypeid int, @taxagroupid nvarchar(3), @elementtypeid int)

as
insert into ndb.elementdatasettaxagroups (datasettypeid, taxagroupid, elementtypeid)
values      (@datasettypeid, @taxagroupid, @elementtypeid)


go

-- ----------------------------
-- procedure structure for insertelementmaturity
-- ----------------------------







create procedure [insertelementmaturity](@maturity nvarchar(36))

as
insert into ndb.elementmaturities(maturity)
values      (@maturity)

---return id
select scope_identity()











go

-- ----------------------------
-- procedure structure for insertelementportion
-- ----------------------------






create procedure [insertelementportion](@portion nvarchar(48))

as
insert into ndb.elementportions(portion)
values      (@portion)

---return id
select scope_identity()










go

-- ----------------------------
-- procedure structure for insertelementsymmetry
-- ----------------------------





create procedure [insertelementsymmetry](@symmetry nvarchar(24))

as
insert into ndb.elementsymmetries (symmetry)
values      (@symmetry)

---return id
select scope_identity()









go

-- ----------------------------
-- procedure structure for insertelementtaxagroupmaturity
-- ----------------------------








create procedure [insertelementtaxagroupmaturity](@elementtaxagroupid int, @maturityid int)

as
insert into ndb.elementtaxagroupmaturities(elementtaxagroupid, maturityid)
values      (@elementtaxagroupid, @maturityid)





go

-- ----------------------------
-- procedure structure for insertelementtaxagroupportion
-- ----------------------------







create procedure [insertelementtaxagroupportion](@elementtaxagroupid int, @portionid int)

as
insert into ndb.elementtaxagroupportions(elementtaxagroupid, portionid)
values      (@elementtaxagroupid, @portionid)




go

-- ----------------------------
-- procedure structure for insertelementtaxagroups
-- ----------------------------






create procedure [insertelementtaxagroups](@taxagroupid nvarchar(3), @elementtypeid int)

as
insert into ndb.elementtaxagroups (taxagroupid, elementtypeid)
values      (@taxagroupid, @elementtypeid)

---return id
select scope_identity()


go

-- ----------------------------
-- procedure structure for insertelementtaxagroupsymmetry
-- ----------------------------






create procedure [insertelementtaxagroupsymmetry](@elementtaxagroupid int, @symmetryid int)

as
insert into ndb.elementtaxagroupsymmetries(elementtaxagroupid, symmetryid)
values      (@elementtaxagroupid, @symmetryid)



go

-- ----------------------------
-- procedure structure for insertelementtype
-- ----------------------------




create procedure [insertelementtype](@elementtype nvarchar(64))

as
insert into ndb.elementtypes (elementtype)
values      (@elementtype)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertepdentitydatasetid
-- ----------------------------




create procedure [insertepdentitydatasetid](@enr int, @datasetid int)

as
insert into epd.dbo.entitydatasetid(e#, datasetid)
values      (@enr, @datasetid)
---return id
select scope_identity()


go

-- ----------------------------
-- procedure structure for insertevent
-- ----------------------------




create procedure [insertevent](@eventtypeid int,
@eventname nvarchar(80),
@c14age float = null,
@c14ageyounger float = null,
@c14ageolder float = null,
@calage float = null,
@calageyounger float = null,
@calageolder float = null,
@notes nvarchar(max) = null)
as
insert into ndb.events
                        (eventtypeid, eventname, c14age, c14ageyounger, c14ageolder, calage, calageyounger, calageolder, notes)
values      (@eventtypeid, @eventname, @c14age, @c14ageyounger, @c14ageolder, @calage, @calageyounger, @calageolder, @notes)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for inserteventchronology
-- ----------------------------


create procedure [inserteventchronology](@analysisunitid int, @eventid int, @chroncontrolid int, @notes nvarchar(max) = null)
as
insert into ndb.eventchronology (analysisunitid, eventid, chroncontrolid, notes)
values      (@analysisunitid, @eventid, @chroncontrolid, @notes)

---return id
select scope_identity()



go

-- ----------------------------
-- procedure structure for inserteventpublication
-- ----------------------------




create procedure [inserteventpublication](@eventid int, @publicationid int)

as
insert into ndb.eventpublications(eventid, publicationid)
values      (@eventid, @publicationid)




go

-- ----------------------------
-- procedure structure for insertfaciestypes
-- ----------------------------


create procedure [insertfaciestypes](@facies nvarchar(64))
as
insert into ndb.faciestypes(facies)
values      (@facies)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertformtaxon
-- ----------------------------





create procedure [insertformtaxon](@taxonid int,
@affinityid int,
@publicationid int,
@systematicdescription bit)

as insert into ndb.formtaxa(taxonid, affinityid, publicationid, systematicdescription)
values      (@taxonid, @affinityid, @publicationid, @systematicdescription)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertfractiondated
-- ----------------------------



create procedure [insertfractiondated](@fraction nvarchar(80))
as
insert into ndb.fractiondated(fraction)
values      (@fraction)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertgeochron
-- ----------------------------


create procedure [insertgeochron](@sampleid int,
@geochrontypeid int,
@agetypeid int,
@age float = null,
@errorolder float = null,
@erroryounger float = null,
@infinite bit = 0,
@delta13c float = null,
@labnumber nvarchar(40) = null,
@materialdated nvarchar(255) = null,
@notes nvarchar(max) = null)

as insert into ndb.geochronology(sampleid, geochrontypeid, agetypeid, age, errorolder, erroryounger, infinite, delta13c, labnumber, materialdated, notes)
values      (@sampleid, @geochrontypeid, @agetypeid, @age, @errorolder, @erroryounger, @infinite, @delta13c, @labnumber, @materialdated, @notes)

---return id
select scope_identity()









go

-- ----------------------------
-- procedure structure for insertgeochroncontrol
-- ----------------------------




create procedure [insertgeochroncontrol](@chroncontrolid int, @geochronid int)

as
insert into ndb.geochroncontrols(chroncontrolid, geochronid)
values      (@chroncontrolid, @geochronid)






go

-- ----------------------------
-- procedure structure for insertgeochronparametervalue
-- ----------------------------



create procedure [insertgeochronparametervalue](@geochronparameterid int, @floatvalue float = null, @charvalue nvarchar(1024) = null)

as
if @floatvalue is not null
  begin
    insert into ndb.geochronparametervalues(geochronparameterid, parametervalue)
    values      (@geochronparameterid, cast(@floatvalue as nvarchar(128)))
  end
else if @charvalue is not null
  begin
    insert into ndb.geochronparametervalues(geochronparameterid, parametervalue)
    values      (@geochronparameterid, @charvalue)
  end

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertgeochronpublication
-- ----------------------------


create procedure [insertgeochronpublication](@geochronid int, @publicationid int)

as
insert into ndb.geochronpublications(geochronid, publicationid)
values      (@geochronid, @publicationid)



go

-- ----------------------------
-- procedure structure for insertgeopoliticalunit
-- ----------------------------




create procedure [insertgeopoliticalunit](@geopolname nvarchar(255),
@geopolunit nvarchar(255),
@rank int,
@higherid int)

as insert into ndb.geopoliticalunits
                        (geopoliticalname, geopoliticalunit, rank, highergeopoliticalid)
values      (@geopolname, @geopolunit, @rank, @higherid)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertisoinstrumention
-- ----------------------------




create procedure [insertisoinstrumention](@datasetid int,
@variableid int,
@isoinstrumentationtypeid int = null,
@isosampleintrosystemtypeid int = null,
@insterrorpercent float = null,
@insterrorrunsd float = null,
@insterrorlongtermpercent float = null,
@notes nvarchar(max) = null
)
as
insert into ndb.isoinstrumentation (datasetid, variableid, isoinstrumentationtypeid, isosampleintrosystemtypeid,
                                    insterrorpercent, insterrorrunsd, insterrorlongtermpercent, notes)
values      (@datasetid, @variableid, @isoinstrumentationtypeid, @isosampleintrosystemtypeid, @insterrorpercent, @insterrorrunsd, @insterrorlongtermpercent, @notes)







go

-- ----------------------------
-- procedure structure for insertisometadata
-- ----------------------------



create procedure [insertisometadata](@dataid int,
@isomatanaltypeid int = null,
@isosubstratetypeid int = null,
@analystid int = null,
@lab nvarchar(255) = null,
@labnumber nvarchar(64) = null,
@massmg float = null,
@weightpercent float = null,
@atomicpercent float = null,
@reps int = null)

as
insert into ndb.isometadata(dataid, isomatanaltypeid, isosubstratetypeid, analystid, lab, labnumber, mass_mg, weightpercent, atomicpercent, reps)
values      (@dataid, @isomatanaltypeid, @isosubstratetypeid, @analystid, @lab, @labnumber, @massmg, @weightpercent, @atomicpercent, @reps)



go

-- ----------------------------
-- procedure structure for insertisosamplepretreatments
-- ----------------------------



create procedure [insertisosamplepretreatments](@dataid int, @isopretreatmenttypeid int, @order int, @value float = null)

as
insert into ndb.isosamplepretreatments(dataid, isopretreatmenttypeid, [order], value)
values      (@dataid, @isopretreatmenttypeid, @order, @value)



go

-- ----------------------------
-- procedure structure for insertisospecimendata
-- ----------------------------





create procedure [insertisospecimendata](@dataid int, @specimenid int, @sd float = null)

as
insert into ndb.isospecimendata(dataid, specimenid, sd)
values      (@dataid, @specimenid, @sd)


go

-- ----------------------------
-- procedure structure for insertisosrmetadata
-- ----------------------------





create procedure [insertisosrmetadata](@datasetid int,
@variableid int,
@srlocalvalue nvarchar(max) = null,
@srlocalgeolcontext nvarchar(max) = null
)
as
insert into ndb.isosrmetadata(datasetid, variableid, srlocalvalue, srlocalgeolcontext)
values      (@datasetid, @variableid, @srlocalvalue, @srlocalgeolcontext)








go

-- ----------------------------
-- procedure structure for insertisostandards
-- ----------------------------



create procedure [insertisostandards](@datasetid int, @variableid int, @isostandardid int, @value float)
as
insert into ndb.isostandards(datasetid, variableid, isostandardid, value)
values      (@datasetid, @variableid, @isostandardid, @value)





go

-- ----------------------------
-- procedure structure for insertisostratdata
-- ----------------------------






create procedure [insertisostratdata](@dataid int, @sd float = null, @taxonid int = null, @elementtypeid int = null)

as
insert into ndb.isostratdata(dataid, sd, taxonid, elementtypeid)
values      (@dataid, @sd, @taxonid, @elementtypeid)






go

-- ----------------------------
-- procedure structure for insertlakeparameter
-- ----------------------------



create procedure [insertlakeparameter](@siteid int,
@lakeparameterid int, @value float)
as insert into ndb.lakeparameters
                        (siteid, lakeparameterid, value)
values      (@siteid, @lakeparameterid, @value)






go

-- ----------------------------
-- procedure structure for insertlithology
-- ----------------------------





create procedure [insertlithology](@collectionunitid int,
@depthtop float = null,
@depthbottom float = null,
@lowerboundary nvarchar(255) = null,
@description nvarchar(max) = null)

as insert into ndb.lithology(collectionunitid, depthtop, depthbottom, lowerboundary, description)
values      (@collectionunitid, @depthtop, @depthbottom, @lowerboundary, @description)

---return id
select scope_identity()








go

-- ----------------------------
-- procedure structure for insertnewdatasetpi
-- ----------------------------




create procedure [insertnewdatasetpi](@datasetid int, @contactid int)
as
declare @npis int
set @npis = (select count(*) from ndb.datasetpis where (datasetid = @datasetid))
declare @piorder int = @npis + 1
insert into ndb.datasetpis(datasetid, contactid, piorder)
values      (@datasetid, @contactid, @piorder)






go

-- ----------------------------
-- procedure structure for insertpublication
-- ----------------------------




create procedure [insertpublication](@pubtypeid int,
@year nvarchar(64) = null,
@citation nvarchar(max),
@title nvarchar(max) = null,
@journal nvarchar(max) = null,
@vol nvarchar(16) = null,
@issue nvarchar(8) = null,
@pages nvarchar(24) = null,
@citnumber nvarchar(24) = null,
@doi nvarchar(128) = null,
@booktitle nvarchar(max) = null,
@numvol nvarchar(8) = null,
@edition nvarchar(24) = null,
@voltitle nvarchar(max) = null,
@sertitle nvarchar(max) = null,
@servol nvarchar(16) = null,
@publisher nvarchar(255) = null,
@url nvarchar(max) = null,
@city nvarchar(64) = null,
@state nvarchar(64) = null,
@country nvarchar(64) = null,
@origlang nvarchar(64) = null,
@notes nvarchar(max) = null)

as insert into ndb.publications
                        (pubtypeid, year, citation, articletitle, journal, volume, issue, pages, citationnumber, doi, booktitle,
                        numvolumes, edition, volumetitle, seriestitle, seriesvolume, publisher, url, city, state, country,
                        originallanguage, notes)
values      (@pubtypeid, @year, @citation, @title, @journal, @vol, @issue, @pages, @citnumber, @doi, @booktitle, @numvol, @edition,
             @voltitle, @sertitle, @servol, @publisher, @url, @city, @state, @country, @origlang, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertpublicationauthors
-- ----------------------------




create procedure [insertpublicationauthors](@publicationid int,
@authororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null,
@contactid int)

as insert into ndb.publicationauthors (publicationid, authororder, familyname, initials, suffix, contactid)
values      (@publicationid, @authororder, @familyname, @initials, @suffix, @contactid)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertpublicationeditors
-- ----------------------------




create procedure [insertpublicationeditors](@publicationid int,
@editororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null)

as insert into ndb.publicationeditors (publicationid, editororder, familyname, initials, suffix)
values      (@publicationid, @editororder, @familyname, @initials, @suffix)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertpublicationtranslators
-- ----------------------------




create procedure [insertpublicationtranslators](@publicationid int,
@translatororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null)

as insert into ndb.publicationtranslators (publicationid, translatororder, familyname, initials, suffix)
values      (@publicationid, @translatororder, @familyname, @initials, @suffix)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertradiocarbon
-- ----------------------------



create procedure [insertradiocarbon](@geochronid int,
@radiocarbonmethodid int = null,
@percentc float = null,
@percentn float = null,
@delta13c float = null,
@delta15n float = null,
@percentcollagen float = null,
@reservoir float = null)

as
insert into ndb.radiocarbon(geochronid, radiocarbonmethodid, percentc, percentn, delta13c, delta15n, percentcollagen, reservoir)
values      (@geochronid, @radiocarbonmethodid, @percentc, @percentn, @delta13c, @delta15n, @percentcollagen, @reservoir)



go

-- ----------------------------
-- procedure structure for insertrelativeage
-- ----------------------------



create procedure [insertrelativeage](@relativeageunitid int,
@relativeagescaleid int,
@relativeage nvarchar(64),
@c14ageyounger float = null,
@c14ageolder float = null,
@calageyounger float = null,
@calageolder float = null,
@notes nvarchar(max) = null)
as
insert into ndb.relativeages
                        (relativeageunitid, relativeagescaleid, relativeage, c14ageyounger, c14ageolder, calageyounger, calageolder, notes)
values      (@relativeageunitid, @relativeagescaleid, @relativeage, @c14ageyounger, @c14ageolder, @calageyounger, @calageolder, @notes)

---return id
select scope_identity()



go

-- ----------------------------
-- procedure structure for insertrelativeagepublication
-- ----------------------------


create procedure [insertrelativeagepublication](@relativeageid int, @publicationid int)

as
insert into ndb.relativeagepublications(relativeageid, publicationid)
values      (@relativeageid, @publicationid)





go

-- ----------------------------
-- procedure structure for insertrelativechronology
-- ----------------------------


create procedure [insertrelativechronology](@analysisunitid int, @relativeageid int, @chroncontrolid int, @notes nvarchar(max) = null)
as
insert into ndb.relativechronology(analysisunitid, relativeageid, chroncontrolid, notes)
values      (@analysisunitid, @relativeageid, @chroncontrolid, @notes)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertrepositoryinstitution
-- ----------------------------


create procedure [insertrepositoryinstitution](@acronym nvarchar(64), @repository nvarchar(128), @notes nvarchar(max) = null)

as insert into ndb.repositoryinstitutions(acronym, repository, notes)
values      (@acronym, @repository, @notes)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertsample
-- ----------------------------

create procedure [insertsample](@analysisunitid int,
@datasetid int,
@samplename nvarchar(80) = null,
@sampledate date = null,
@analysisdate date = null,
@taxonid int = null,
@labnumber nvarchar(40) = null,
@prepmethod nvarchar(max) = null,
@notes nvarchar(max) = null)

as insert into ndb.samples(analysisunitid, datasetid, samplename, sampledate, analysisdate, taxonid, labnumber, preparationmethod, notes)
values      (@analysisunitid, @datasetid, @samplename, convert(datetime, @sampledate, 105), convert(datetime, @analysisdate, 105),
             @taxonid, @labnumber, @prepmethod, @notes)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertsampleage
-- ----------------------------


create procedure [insertsampleage](@sampleid int,
@chronologyid int,
@age float = null,
@ageyounger float = null,
@ageolder float = null)

as insert into ndb.sampleages(sampleid, chronologyid, age, ageyounger, ageolder)
values      (@sampleid, @chronologyid, @age, @ageyounger, @ageolder)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertsampleanalyst
-- ----------------------------


create procedure [insertsampleanalyst](@sampleid int, @contactid int, @analystorder int)

as insert into ndb.sampleanalysts(sampleid, contactid, analystorder)
values      (@sampleid, @contactid, @analystorder)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertsamplekeyword
-- ----------------------------




create procedure [insertsamplekeyword](@sampleid int, @keywordid int)

as
insert into ndb.samplekeywords(sampleid, keywordid)
values      (@sampleid, @keywordid)




go

-- ----------------------------
-- procedure structure for insertsite
-- ----------------------------


create procedure [insertsite](@sitename nvarchar(128),
@east float,
@north float,
@west float,
@south float,
@altitude int = null,
@area float = null,
@descript nvarchar(max) = null,
@notes nvarchar(max) = null)

as
declare @geog geography
if ((@north > @south) and (@east > @west))
  set @geog = geography::stgeomfromtext('polygon((' +
              cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
              cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + '))', 4326).makevalid()
else
  set @geog = geography::stgeomfromtext('point(' + cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ')', 4326).makevalid()

insert into ndb.sites (sitename, altitude, area, sitedescription, notes, geog)
values      (@sitename, @altitude, @area, @descript, @notes, @geog)


---return id
select scope_identity()


go

-- ----------------------------
-- procedure structure for insertsitegeopol
-- ----------------------------



create procedure [insertsitegeopol](@siteid int, @geopoliticalid int)

as insert into ndb.sitegeopolitical(siteid, geopoliticalid)
values      (@siteid, @geopoliticalid)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertspecimen
-- ----------------------------


create procedure [insertspecimen](@dataid int,
@elementtypeid int = null,
@symmetryid int = null,
@portionid int = null,
@maturityid int = null,
@sexid int = null,
@domesticstatusid int = null,
@preservative nvarchar(256) = null,
@nisp float = null,
@repositoryid int = null,
@specimennr nvarchar(50) = null,
@fieldnr nvarchar(50) = null,
@arctosnr nvarchar(50) = null,
@notes nvarchar(max) = null)

as
insert into ndb.specimens (dataid, elementtypeid, symmetryid, portionid, maturityid, sexid, domesticstatusid, preservative,
            nisp, repositoryid, specimennr, fieldnr, arctosnr, notes)
values (@dataid, @elementtypeid, @symmetryid, @portionid, @maturityid, @sexid, @domesticstatusid, @preservative,
  @nisp, @repositoryid, @specimennr, @fieldnr, @arctosnr, @notes)



---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertspecimendate
-- ----------------------------




create procedure [insertspecimendate](@geochronid int,
@specimenid int = null,
@taxonid int,
@elementtypeid int = null,
@fractionid int = null,
@sampleid int,
@notes nvarchar(max) = null)

as
insert into ndb.specimendates
                        (geochronid, specimenid, taxonid, elementtypeid, fractionid, sampleid, notes)
values      (@geochronid, @specimenid, @taxonid, @elementtypeid, @fractionid, @sampleid, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertspecimendatecal
-- ----------------------------




create procedure [insertspecimendatecal](@specimendateid int,
@calage float = null,
@calageolder float = null,
@calageyounger float = null,
@calibrationcurveid int = null,
@calibrationprogramid int = null,
@datecalibrated date = null)

as
insert into ndb.specimendatescal
                        (specimendateid, calage, calageolder, calageyounger, calibrationcurveid, calibrationprogramid, datecalibrated)
values      (@specimendateid, @calage, @calageolder, @calageyounger, @calibrationcurveid, @calibrationprogramid, convert(datetime, @datecalibrated, 105))

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertspecimengenbanknr
-- ----------------------------



create procedure [insertspecimengenbanknr](@specimenid int, @genbanknr nvarchar(50))

as
insert into ndb.specimengenbank(specimenid, genbanknr)
values      (@specimenid, @genbanknr)



go

-- ----------------------------
-- procedure structure for insertspecimentaphonomy
-- ----------------------------




create procedure [insertspecimentaphonomy](@specimenid int, @taphonomictypeid int)

as
insert into ndb.specimentaphonomy(specimenid, taphonomictypeid)
values      (@specimenid, @taphonomictypeid)




go

-- ----------------------------
-- procedure structure for insertsteward
-- ----------------------------




create procedure [insertsteward](@contactid int,
@username nvarchar(15),
@password nvarchar(15),
@taxonomyexpert bit,
@databaseid int)

as
insert into ti.stewards(contactid, username, pwd, taxonomyexpert)
values      (@contactid, @username, @password, @taxonomyexpert)

declare @stewardid int
set @stewardid = (select stewardid from ti.stewards where (contactid = @contactid))

insert into ti.stewarddatabases(stewardid, databaseid)
values      (@stewardid, @databaseid)




go

-- ----------------------------
-- procedure structure for insertsummarydatataphonomy
-- ----------------------------





create procedure [insertsummarydatataphonomy](@dataid int, @taphonomictypeid int)

as
insert into ndb.summarydatataphonomy(dataid, taphonomictypeid)
values      (@dataid, @taphonomictypeid)





go

-- ----------------------------
-- procedure structure for insertsynonym
-- ----------------------------




create procedure [insertsynonym](@invalidtaxonid int, @validtaxonid int, @synonymtypeid int = null)
as
insert into ndb.synonyms(invalidtaxonid, validtaxonid, synonymtypeid)
values      (@invalidtaxonid, @validtaxonid, @synonymtypeid)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertsynonymtype
-- ----------------------------



create procedure [insertsynonymtype](@synonymtype nvarchar(255))
as insert into ndb.synonymtypes(synonymtype)
values      (@synonymtype)

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for insertsynonymy
-- ----------------------------




create procedure [insertsynonymy](@datasetid int,
@taxonid int,
@reftaxonid int,
@fromcontributor bit = 0,
@publicationid int = null,
@notes nvarchar(max) = null,
@contactid int = null,
@datesynonymized date = null)

as
insert into ndb.synonymy(datasetid, taxonid, reftaxonid, fromcontributor, publicationid, notes, contactid, datesynonymized)
values  (@datasetid, @taxonid, @reftaxonid, @fromcontributor, @publicationid, @notes, @contactid, convert(datetime, @datesynonymized, 105))


---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for inserttaphonomicsystem
-- ----------------------------



create procedure [inserttaphonomicsystem](@taphonomicsystem nvarchar(64),
@notes nvarchar(max) = null)

as insert into ndb.taphonomicsystems
                        (taphonomicsystem, notes)
values      (@taphonomicsystem, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for inserttaphonomicsystemdatasettype
-- ----------------------------




create procedure [inserttaphonomicsystemdatasettype](@datasettypeid int,
@taphonomicsystemid int)

as insert into ndb.taphonomicsystemsdatasettypes
                        (datasettypeid, taphonomicsystemid)
values      (@datasettypeid, @taphonomicsystemid)




go

-- ----------------------------
-- procedure structure for inserttaphonomictype
-- ----------------------------



create procedure [inserttaphonomictype](@taphonomicsystemid int,
@taphonomictype nvarchar(64),
@notes nvarchar(max) = null)

as insert into ndb.taphonomictypes
                        (taphonomicsystemid, taphonomictype, notes)
values      (@taphonomicsystemid, @taphonomictype, @notes)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for inserttaxagroup
-- ----------------------------




create procedure [inserttaxagroup](@taxagroupid nvarchar(3), @taxagroup nvarchar(64))

as
insert into ndb.taxagrouptypes (taxagroupid, taxagroup)
values      (@taxagroupid, @taxagroup)

go

-- ----------------------------
-- procedure structure for inserttaxon
-- ----------------------------



create procedure [inserttaxon](@code nvarchar(64),
@name nvarchar(80),
@author nvarchar(128) = null,
@valid bit = 1,
@higherid int = null,
@extinct bit = 0,
@groupid nvarchar(3),
@pubid int = null,
@validatorid int = null,
@validatedate date = null,
@notes nvarchar(max) = null)

as insert into ndb.taxa
                        (taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid, validatedate, notes)
values      (@code, @name, @author, @valid, @higherid, @extinct, @groupid, @pubid, @validatorid, convert(datetime, @validatedate, 105), @notes)

if @higherid = -1
begin
  declare @id int
  set @id = scope_identity()
  update ndb.taxa
  set    ndb.taxa.highertaxonid = @id
  where  (ndb.taxa.taxonid = @id)
end

---return id
select scope_identity()






go

-- ----------------------------
-- procedure structure for inserttephra
-- ----------------------------


create procedure [inserttephra](@eventid int, @analysisunitid int, @notes nvarchar(max) = null)
as
insert into ndb.tephras(eventid, analysisunitid, notes)
values      (@eventid, @analysisunitid, @notes)

---return id
select scope_identity()



go

-- ----------------------------
-- procedure structure for insertunitsdatasettypes
-- ----------------------------


create procedure [insertunitsdatasettypes](@datasettypeid int, @variableunitsid int)

as
insert into ndb.unitsdatasettypes(datasettypeid, variableunitsid)
values      (@datasettypeid, @variableunitsid)

go

-- ----------------------------
-- procedure structure for insertvariable
-- ----------------------------




create procedure [insertvariable](@taxonid int,
@variableelementid int = null,
@variableunitsid int = null,
@variablecontextid int = null)

as insert into ndb.variables (taxonid, variableelementid, variableunitsid, variablecontextid )
values      (@taxonid, @variableelementid, @variableunitsid, @variablecontextid)

---return id
select scope_identity()







go

-- ----------------------------
-- procedure structure for insertvariablecontext
-- ----------------------------


create procedure [insertvariablecontext](@context nvarchar(64))

as
insert into ndb.variablecontexts(variablecontext)
values      (@context)

---return id
select scope_identity()




go

-- ----------------------------
-- procedure structure for insertvariableelement
-- ----------------------------


create procedure [insertvariableelement](@variableelement nvarchar(64),
@elementtypeid int,
@symmetryid int = null,
@portionid int = null,
@maturityid int = null)

as
insert into ndb.variableelements(variableelement, elementtypeid, symmetryid, portionid, maturityid)
values      (@variableelement, @elementtypeid, @symmetryid, @portionid, @maturityid)

---return id
select scope_identity()





go

-- ----------------------------
-- procedure structure for insertvariableunits
-- ----------------------------





create procedure [insertvariableunits](@units nvarchar(64))

as
insert into ndb.variableunits(variableunits)
values      (@units)

---return id
select scope_identity()









go

-- ----------------------------
-- procedure structure for updateaggregatechronagebounds
-- ----------------------------




create procedure [updateaggregatechronagebounds](@aggregatechronid int, @ageboundyounger int, @ageboundolder int)
as
update ndb.aggregatechronologies
set   ageboundyounger = @ageboundyounger, ageboundolder = @ageboundolder
where aggregatechronid = @aggregatechronid





go

-- ----------------------------
-- procedure structure for updateanalysisunitdepth
-- ----------------------------





create procedure [updateanalysisunitdepth](@analysisunitid int, @depth float)
as
update     ndb.analysisunits
set        ndb.analysisunits.depth = @depth
where      (ndb.analysisunits.analysisunitid = @analysisunitid)





go

-- ----------------------------
-- procedure structure for updateanalysisunitname
-- ----------------------------




create procedure [updateanalysisunitname](@analysisunitid int, @analysisunitname nvarchar(80))
as
update     ndb.analysisunits
set        ndb.analysisunits.analysisunitname = @analysisunitname
where     (ndb.analysisunits.analysisunitid = @analysisunitid)




go

-- ----------------------------
-- procedure structure for updateanalysisunitthickness
-- ----------------------------





create procedure [updateanalysisunitthickness](@analysisunitid int, @thickness float)
as
update     ndb.analysisunits
set        ndb.analysisunits.thickness = @thickness
where      (ndb.analysisunits.analysisunitid = @analysisunitid)





go

-- ----------------------------
-- procedure structure for updatecapitalizetaxonname
-- ----------------------------





create procedure [updatecapitalizetaxonname](@highertaxonid int)
as
update     ndb.taxa
set        ndb.taxa.taxonname = upper(left(ndb.taxa.taxonname,1))+lower(substring(ndb.taxa.taxonname,2,len(ndb.taxa.taxonname)))
where     (highertaxonid = @highertaxonid)







go

-- ----------------------------
-- procedure structure for updatechroncontrolanalysisunit
-- ----------------------------




create procedure [updatechroncontrolanalysisunit](@chroncontrolid int, @analunitid int)
as
update ndb.chroncontrols
set analysisunitid = @analunitid
where chroncontrolid = @chroncontrolid






go

-- ----------------------------
-- procedure structure for updatechroncontroltype
-- ----------------------------



create procedure [updatechroncontroltype](@chroncontroltypeid int, @chroncontroltype nvarchar(64))
as
update ndb.chroncontroltypes
set chroncontroltype = @chroncontroltype
where chroncontroltypeid = @chroncontroltypeid





go

-- ----------------------------
-- procedure structure for updatechronology
-- ----------------------------



create procedure [updatechronology](@chronologyid int,
@agetype nvarchar(64),
@contactid int = null,
@isdefault bit,
@chronologyname nvarchar(80) = null,
@dateprepared date = null,
@agemodel nvarchar(80) = null,
@ageboundyounger int = null,
@ageboundolder int = null,
@notes nvarchar(max) = null)


as

declare @agetypeid int
set @agetypeid = (select agetypeid from ndb.agetypes where (agetype = @agetype))

update ndb.chronologies

set agetypeid = @agetypeid, contactid = @contactid, isdefault = @isdefault, chronologyname = @chronologyname, dateprepared = convert(datetime, @dateprepared, 105),
    agemodel = @agemodel, ageboundyounger = @ageboundyounger, ageboundolder = @ageboundolder, notes = @notes
where chronologyid = @chronologyid






go

-- ----------------------------
-- procedure structure for updatecollectionunit
-- ----------------------------


create procedure [updatecollectionunit](@collunitid int,
@stewardcontactid int,
@handle nvarchar(10),
@colltypeid int = null,
@depenvtid int = null,
@collunitname nvarchar(255) = null,
@colldate date = null,
@colldevice nvarchar(255) = null,
@gpslatitude float = null,
@gpslongitude float = null,
@gpsaltitude float = null,
@gpserror float = null,
@waterdepth float = null,
@substrateid int = null,
@slopeaspect int = null,
@slopeangle int = null,
@location nvarchar(255) = null,
@notes nvarchar(max) = null)

as
declare @oldhandle nvarchar(10) = (select handle from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldcolltypeid int = (select colltypeid from ndb.collectionunits where collectionunitid = @collunitid)
declare @olddepenvtid int = (select depenvtid from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldcollunitname nvarchar(255) = (select collunitname from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldcolldate date = (select colldate from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldcolldevice nvarchar(255) = (select colldevice from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldgpslatitude float = (select gpslatitude from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldgpslongitude float = (select gpslongitude from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldgpsaltitude float = (select gpsaltitude from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldgpserror float = (select gpserror from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldwaterdepth float = (select waterdepth from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldsubstrateid int = (select substrateid from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldslopeaspect int = (select slopeaspect from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldslopeangle int = (select slopeangle from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldlocation nvarchar(255) = (select location from ndb.collectionunits where collectionunitid = @collunitid)
declare @oldnotes nvarchar(max) = (select notes from ndb.collectionunits where collectionunitid = @collunitid)

if @oldhandle <> @handle
  begin
    update ndb.collectionunits
    set handle = @handle where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'handle')
  end

if (@colltypeid <> @oldcolltypeid)
  begin
    update ndb.collectionunits
    set colltypeid = @colltypeid where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'colltypeid')
  end

if @depenvtid is null
  begin
    if @olddepenvtid is not null
      begin
        update ndb.collectionunits
        set depenvtid = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'depenvtid')
      end
  end
else if (@olddepenvtid is null) or (@depenvtid <> @olddepenvtid)
  begin
    update ndb.collectionunits
    set depenvtid = @depenvtid where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'depenvtid')
  end

if @collunitname is null
  begin
    if @oldcollunitname is not null
      begin
        update ndb.collectionunits
        set collunitname = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'collunitname')
      end
  end
else if (@oldcollunitname is null) or (@collunitname <> @oldcollunitname)
  begin
    update ndb.collectionunits
    set collunitname = @collunitname where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'collunitname')
  end

/* convert(datetime, @colldate, 105) */
if @colldate is null
  begin
    if @oldcolldate is not null
      begin
        update ndb.collectionunits
        set colldate = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'colldate')
      end
  end
else if (@oldcolldate is null) or (@colldate <> @oldcolldate)
  begin
    update ndb.collectionunits
    set colldate = convert(datetime, @colldate, 105) where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'colldate')
  end

if @colldevice is null
  begin
    if @oldcolldevice is not null
      begin
        update ndb.collectionunits
        set colldevice = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'colldevice')
      end
  end
else if (@oldcolldevice is null) or (@colldevice <> @oldcolldevice)
  begin
    update ndb.collectionunits
    set colldevice = @colldevice where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'colldevice')
  end

if @gpslatitude is null
  begin
    if @oldgpslatitude is not null
      begin
        update ndb.collectionunits
        set gpslatitude = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpslatitude')
      end
  end
else if (@oldgpslatitude is null) or (@gpslatitude <> @oldgpslatitude)
  begin
    update ndb.collectionunits
    set gpslatitude = @gpslatitude where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpslatitude')
  end

if @gpslongitude is null
  begin
    if @oldgpslongitude is not null
      begin
        update ndb.collectionunits
        set gpslongitude = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpslongitude')
      end
  end
else if (@oldgpslongitude is null) or (@gpslongitude <> @oldgpslongitude)
  begin
    update ndb.collectionunits
    set gpslongitude = @gpslongitude where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpslongitude')
  end

if @gpsaltitude is null
  begin
    if @oldgpsaltitude is not null
      begin
        update ndb.collectionunits
        set gpsaltitude = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpsaltitude')
      end
  end
else if (@oldgpsaltitude is null) or (@gpsaltitude <> @oldgpsaltitude)
  begin
    update ndb.collectionunits
    set gpsaltitude = @gpsaltitude where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpsaltitude')
  end

if @gpserror is null
  begin
    if @oldgpserror is not null
      begin
        update ndb.collectionunits
        set gpserror = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpserror')
      end
  end
else if (@oldgpserror is null) or (@gpserror <> @oldgpserror)
  begin
    update ndb.collectionunits
    set gpserror = @gpserror where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'gpserror')
  end

if @waterdepth is null
  begin
    if @oldwaterdepth is not null
      begin
        update ndb.collectionunits
        set waterdepth = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'waterdepth')
      end
  end
else if (@oldwaterdepth is null) or (@waterdepth <> @oldwaterdepth)
  begin
    update ndb.collectionunits
    set waterdepth = @waterdepth where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'waterdepth')
  end

if @substrateid is null
  begin
    if @oldsubstrateid is not null
      begin
        update ndb.collectionunits
        set substrateid = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'substrateid')
      end
  end
else if (@oldsubstrateid is null) or (@substrateid <> @oldsubstrateid)
  begin
    update ndb.collectionunits
    set substrateid = @substrateid where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'substrateid')
  end

if @slopeaspect is null
  begin
    if @oldslopeaspect is not null
      begin
        update ndb.collectionunits
        set slopeaspect = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'slopeaspect')
      end
  end
else if (@oldslopeaspect is null) or (@slopeaspect <> @oldslopeaspect)
  begin
    update ndb.collectionunits
    set slopeaspect = @slopeaspect where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'slopeaspect')
  end

if @slopeangle is null
  begin
    if @oldslopeangle is not null
      begin
        update ndb.collectionunits
        set slopeangle = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'slopeangle')
      end
  end
else if (@oldslopeangle is null) or (@slopeangle <> @oldslopeangle)
  begin
    update ndb.collectionunits
    set slopeangle = @slopeangle where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'slopeangle')
  end

if @location is null
  begin
    if @oldlocation is not null
      begin
        update ndb.collectionunits
        set location = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'location')
      end
  end
else if (@oldlocation is null) or (@location <> @oldlocation)
  begin
    update ndb.collectionunits
    set location = @location where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'location')
  end

if @notes is null
  begin
    if @oldnotes is not null
      begin
        update ndb.collectionunits
        set notes = null where collectionunitid = @collunitid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'notes')
      end
  end
else if (@oldnotes is null) or (@notes <> @oldnotes)
  begin
    update ndb.collectionunits
    set notes = @notes where collectionunitid = @collunitid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'collectionunits', @collunitid, n'update', n'notes')
  end
go

-- ----------------------------
-- procedure structure for updatecontact
-- ----------------------------


create procedure [updatecontact](@contactid int,
@aliasid int = null,
@contactname nvarchar(80),
@statusid int = null,
@familyname nvarchar(80) = null,
@initials nvarchar(16) = null,
@givennames nvarchar(80) = null,
@suffix nvarchar(16) = null,
@title nvarchar(16) = null,
@phone nvarchar(64) = null,
@fax nvarchar(64) = null,
@email nvarchar(64) = null,
@url nvarchar(255) = null,
@address nvarchar(max) = null,
@notes nvarchar(max)= null)

as update ndb.contacts

set aliasid = @aliasid, contactname = @contactname, contactstatusid = @statusid, familyname = @familyname, leadinginitials = @initials,
    givennames = @givennames, suffix = @suffix, title = @title, phone = @phone, fax = @fax, email = @email, url = @url, address = @address,
    notes = @notes
where contactid = @contactid





go

-- ----------------------------
-- procedure structure for updatecontactaliasid
-- ----------------------------



create procedure [updatecontactaliasid](@contactid int, @aliasid int)

as update ndb.contacts

set aliasid = @aliasid
where contactid = @contactid






go

-- ----------------------------
-- procedure structure for updatedata
-- ----------------------------



create procedure [updatedata](@dataid int, @value float)
as
update     ndb.data
set        ndb.data.value = @value
where     (ndb.data.dataid = @dataid)



go

-- ----------------------------
-- procedure structure for updatedatasetname
-- ----------------------------




create procedure [updatedatasetname](@datasetid int, @datasetname nvarchar(80))
as
update     ndb.datasets
set        ndb.datasets.datasetname = @datasetname
where     (ndb.datasets.datasetid = @datasetid)






go

-- ----------------------------
-- procedure structure for updatedatasetnotes
-- ----------------------------





create procedure [updatedatasetnotes](@datasetid int, @datasetnotes nvarchar(max) = null)
as
if @datasetnotes is not null
  begin
    update     ndb.datasets
    set        ndb.datasets.notes = @datasetnotes
    where     (ndb.datasets.datasetid = @datasetid)
  end
else
  begin
    update     ndb.datasets
    set        ndb.datasets.notes = null
    where     (ndb.datasets.datasetid = @datasetid)
  end

go

-- ----------------------------
-- procedure structure for updatedatasetpubprimary
-- ----------------------------





create procedure [updatedatasetpubprimary](@datasetid int, @publicationid int, @primary bit)
as
update     ndb.datasetpublications
set        ndb.datasetpublications.primarypub = @primary
where      (ndb.datasetpublications.datasetid = @datasetid) and (ndb.datasetpublications.publicationid = @publicationid)







go

-- ----------------------------
-- procedure structure for updatedatasetrepositorynotes
-- ----------------------------





create procedure [updatedatasetrepositorynotes](@datasetid int, @repositoryid int, @notes nvarchar(max) = null)

as
if @notes is null
  begin
    update ndb.repositoryspecimens
    set    notes = null
    where  (datasetid = @datasetid) and (repositoryid = @repositoryid)
  end
else
  begin
    update ndb.repositoryspecimens
    set    notes = @notes
    where  (datasetid = @datasetid) and (repositoryid = @repositoryid)
  end


--insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation, columnname)
--values      (@contactid, n'repositoryspecimens', @datasetid, @repositoryid, n'update', n'notes')





go

-- ----------------------------
-- procedure structure for updatedatasettaxonnotes
-- ----------------------------




create procedure [updatedatasettaxonnotes](@datasetid int, @taxonid int, @contactid int, @date date, @notes nvarchar(max))

as
update ndb.datasettaxonnotes
set datasetid = @datasetid,
    taxonid = @taxonid,
	contactid = @contactid,
	date = convert(datetime, @date, 105),
	notes = @notes
where datasetid = @datasetid and taxonid = @taxonid

insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation, columnname)
values      (@contactid, n'datasettaxonnotes', @datasetid, @taxonid, n'update', n'notes')






go

-- ----------------------------
-- procedure structure for updatedatasetvariable
-- ----------------------------



create procedure [updatedatasetvariable](@oldvariableid int, @newvariableid int, @sampleid1 int, @sampleid2 int)
as
update     ndb.data
set        ndb.data.variableid = @newvariableid
where     (ndb.data.variableid = @oldvariableid and ndb.data.sampleid >= @sampleid1 and ndb.data.sampleid <= @sampleid2)





go

-- ----------------------------
-- procedure structure for updatedatavariable
-- ----------------------------



create procedure [updatedatavariable](@datasetid int, @oldvariableid int, @newvariableid int, @contactid int)
as
declare @dataids table
(
  id int not null primary key identity(1,1),
  dataid int
)

insert into @dataids (dataid)
select    ndb.data.dataid
from      ndb.samples inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid
where     (ndb.samples.datasetid = @datasetid) and (ndb.data.variableid = @oldvariableid)

declare @nrows int = @@rowcount
declare @currentid int = 0
declare @dataid int

while @currentid < @nrows
  begin
    set @currentid = @currentid+1
	set @dataid = (select dataid from @dataids where id = @currentid)
	update ndb.data
	set    ndb.data.variableid = @newvariableid
	where  (ndb.data.dataid = @dataid)
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@contactid, n'data', @dataid, n'update', n'variableid')
  end

go

-- ----------------------------
-- procedure structure for updatedatavariableid
-- ----------------------------


create procedure [updatedatavariableid](@oldvariableid int, @newvariableid int)
as
update ndb.data
set    variableid = @newvariableid
where  (variableid = @oldvariableid)



go

-- ----------------------------
-- procedure structure for updatedatavariableid_deletevariable
-- ----------------------------



create procedure [updatedatavariableid_deletevariable](@savevarid int, @delvarid int)
/* merges @delvarid with @savevarid and deletes @delvarid */
as
update ndb.data
set    variableid = @savevarid
where  (variableid = @delvarid)

delete from ndb.variables
where variableid = @delvarid



go

-- ----------------------------
-- procedure structure for updatedepenvthigherid
-- ----------------------------



create procedure [updatedepenvthigherid](@depenvtid int, @depenvthigherid int)
as update ndb.depenvttypes
set depenvthigherid = @depenvthigherid
where depenvtid = @depenvtid







go

-- ----------------------------
-- procedure structure for updatedepenvttype
-- ----------------------------


create procedure [updatedepenvttype](@depenvtid int, @depenvt nvarchar(255),
@depenvthigherid int)
as update ndb.depenvttypes
set depenvt = @depenvt, depenvthigherid = @depenvthigherid
where depenvtid = @depenvtid






go

-- ----------------------------
-- procedure structure for updateelementpollentospore
-- ----------------------------




create procedure [updateelementpollentospore](@taxonid int)
as
declare @npollenvars int
set @npollenvars = (select count(*) from ndb.variables where (taxonid = @taxonid) and (variableelementid = 141))
if (@npollenvars > 1)
  begin
    select n'pollen variables >1. cannot process.'
	return
  end

declare @sporevariableid int
declare @pollenvariableid int
declare @unitsid int
declare @contextid int
set @pollenvariableid = (select variableid from ndb.variables where ((taxonid = @taxonid) and (variableelementid = 141)))
set @unitsid = (select variableunitsid from ndb.variables where (variableid = @pollenvariableid))
set @contextid = (select variablecontextid from ndb.variables where (variableid = @pollenvariableid))
if (@contextid is null)
  begin
    set @sporevariableid = (select variableid from ndb.variables
    where ((taxonid = @taxonid) and (variableelementid = 166) and (variableunitsid = @unitsid) and (variablecontextid is null)))
  end
else
  begin
    set @sporevariableid = (select variableid from ndb.variables
    where ((taxonid = @taxonid) and (variableelementid = 166) and (variableunitsid = @unitsid) and (variablecontextid = @contextid)))
  end

if (@sporevariableid is null)
  begin
    select n'no equivalent spore variable.'
	return
  end

update ndb.data
set    ndb.data.variableid = @sporevariableid   -- correct variableid
where  (ndb.data.variableid = @pollenvariableid)  -- incorrect variableid

select concat (n'data table updated: pollen variable ', cast (@pollenvariableid as nvarchar), n' updated to spore variable ', cast (@sporevariableid as nvarchar), n'.') as result

delete from ndb.variables
where variableid = @pollenvariableid

select concat (n'variable ', cast (@pollenvariableid as nvarchar), n' deleted.') as result






go

-- ----------------------------
-- procedure structure for updateelementsporetopollen
-- ----------------------------



create procedure [updateelementsporetopollen](@taxonid int)
as
declare @nsporevars int
set @nsporevars = (select count(*) from ndb.variables where (taxonid = @taxonid) and (variableelementid = 166))
if (@nsporevars > 1)
  begin
    select n'spore variables >1. cannot process.'
	return
  end

declare @sporevariableid int
declare @pollenvariableid int
declare @unitsid int
declare @contextid int
set @sporevariableid = (select variableid from ndb.variables where ((taxonid = @taxonid) and (variableelementid = 166)))
set @unitsid = (select variableunitsid from ndb.variables where (variableid = @sporevariableid))
set @contextid = (select variablecontextid from ndb.variables where (variableid = @sporevariableid))
if (@contextid is null)
  begin
    set @pollenvariableid = (select variableid from ndb.variables
    where ((taxonid = @taxonid) and (variableelementid = 141) and (variableunitsid = @unitsid) and (variablecontextid is null)))
  end
else
  begin
    set @pollenvariableid = (select variableid from ndb.variables
    where ((taxonid = @taxonid) and (variableelementid = 141) and (variableunitsid = @unitsid) and (variablecontextid = @contextid)))
  end

if (@pollenvariableid is null)
  begin
    select n'no equivalent pollen variable.'
	return
  end

update ndb.data
set    ndb.data.variableid = @pollenvariableid   -- correct variableid
where  (ndb.data.variableid = @sporevariableid)  -- incorrect variableid

select concat (n'data table updated: spore variable ', cast (@sporevariableid as nvarchar), n' updated to pollen variable ', cast (@pollenvariableid as nvarchar), n'.') as result

delete from ndb.variables
where variableid = @sporevariableid

select concat (n'variable ', cast (@sporevariableid as nvarchar), n' deleted.') as result





go

-- ----------------------------
-- procedure structure for updateevent
-- ----------------------------



create procedure [updateevent](@eventid int,
@eventtypeid int,
@eventname nvarchar(80),
@c14age float = null,
@c14ageyounger float = null,
@c14ageolder float = null,
@calage float = null,
@calageyounger float = null,
@calageolder float = null,
@notes nvarchar(max) = null)

as update ndb.events

set eventtypeid = @eventtypeid, eventname = @eventname, c14age = @c14age, c14ageyounger = @c14ageyounger, c14ageolder = @c14ageolder,
    calage = @calage, calageyounger = @calageyounger, calageolder = @calageolder, notes = @notes
where eventid = @eventid







go

-- ----------------------------
-- procedure structure for updategeochron
-- ----------------------------

create procedure [updategeochron](@geochronid int,
@geochrontypeid int,
@agetypeid int,
@age float = null,
@errorolder float = null,
@erroryounger float = null,
@infinite bit = 0,
@labnumber nvarchar(40) = null,
@materialdated nvarchar(255) = null,
@notes nvarchar(max) = null)

as
update ndb.geochronology
set geochrontypeid = @geochrontypeid, agetypeid = @agetypeid, age = @age, errorolder = @errorolder, erroryounger = @erroryounger,
    infinite = @infinite, labnumber = @labnumber, materialdated = @materialdated, notes = @notes
where geochronid = @geochronid




go

-- ----------------------------
-- procedure structure for updategeochronanalysisunit
-- ----------------------------


create procedure [updategeochronanalysisunit](@geochronid int, @analysisunitid int, @depth float = null, @thickness float = null, @analysisunitname nvarchar(80) = null)
as
/*
this procedure updates the depth, thickness, and name of the analysis unit for a geochronologic measurement.
if no other samples are assigned to the analysis unit, then the analysis unit is simply updated. however, if
other samples are assigned to the analysis unit then either (1) the geochron sample is reassigned to another
analysis unit with the same depth, thickness, and name from the same collection unit, or (2) the sample is
reassigned to a new analysis unit. the return value is the analysisunitid to which the sample is assigned
after the update.
*/

declare @geochronsampleid int
declare @sampleid int
declare @nsamples int
declare @collunitid int
declare @nanalunits int
declare @newanalysisunitid int = null

set @geochronsampleid = (select sampleid from ndb.geochronology where (geochronid = @geochronid))
set @nsamples = (select count(*) from ndb.samples group by analysisunitid having (analysisunitid = @analysisunitid))
-- if analysis unit has no other sample, simply update

if (@nsamples = 1)
  begin
    set @sampleid = (select sampleid from ndb.samples where (analysisunitid = @analysisunitid))
	if (@geochronsampleid = @sampleid)  -- this should always be the case, but...
	  begin
	    update ndb.analysisunits set ndb.analysisunits.depth = @depth where (ndb.analysisunits.analysisunitid = @analysisunitid)
		update ndb.analysisunits set ndb.analysisunits.thickness = @thickness where (ndb.analysisunits.analysisunitid = @analysisunitid)
		update ndb.analysisunits set ndb.analysisunits.analysisunitname = @analysisunitname where (ndb.analysisunits.analysisunitid = @analysisunitid)
	  end
    else
	  begin
	    raiserror('geochron sampleid does not match sampleid for geochron analysis unit',10,1)
	  end
  end
else
  begin
    -- see if another analysis unit exists with the same parameters from same collection unit
	set @collunitid = (select collectionunitid from ndb.analysisunits where (analysisunitid = @analysisunitid))
	-- see if analysis unit exists with same non-null name
	if (@analysisunitname is not null)
	  begin
	    if ((@depth is not null) and (@thickness is not null))
		  begin
	        set @nanalunits = (select count(*) from ndb.analysisunits
                               group by collectionunitid, analysisunitid, analysisunitname, depth, thickness
                               having (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                  (analysisunitname = @analysisunitname) and (depth = @depth) and (thickness = @thickness))
            if (@nanalunits = 1)
			  set @newanalysisunitid = (select analysisunitid from ndb.analysisunits
                                        where (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                    (analysisunitname = @analysisunitname) and (depth = @depth) and (thickness = @thickness))
          end
        else if ((@depth is not null) and (@thickness is null))
	      begin
		    set @nanalunits = (select count(*) from ndb.analysisunits
                               group by collectionunitid, analysisunitid, analysisunitname, depth, thickness
                               having (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                  (analysisunitname = @analysisunitname) and (depth = @depth) and (thickness is null))
            if (@nanalunits = 1)
			  set @newanalysisunitid = (select analysisunitid from ndb.analysisunits
                                        where (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                    (analysisunitname = @analysisunitname) and (depth = @depth) and (thickness is null))
          end
		else if ((@depth is null) and (@thickness is not null))
	      begin
		    set @nanalunits = (select count(*) from ndb.analysisunits
                               group by collectionunitid, analysisunitid, analysisunitname, depth, thickness
                               having (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                  (analysisunitname = @analysisunitname) and (depth is null) and (thickness = @thickness))
            if (@nanalunits = 1)
			  set @newanalysisunitid = (select analysisunitid from ndb.analysisunits
                                        where (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                    (analysisunitname = @analysisunitname) and (depth is null) and (thickness = @thickness))
	      end
		else if ((@depth is null) and (@thickness is null))
		  begin
	        set @nanalunits = (select count(*) from ndb.analysisunits
                               group by collectionunitid, analysisunitid, analysisunitname, depth, thickness
                               having (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                  (analysisunitname = @analysisunitname) and (depth is null) and (thickness is null))
            if (@nanalunits = 1)
			  set @newanalysisunitid = (select analysisunitid from ndb.analysisunits
                                        where (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                    (analysisunitname = @analysisunitname) and (depth is null) and (thickness is null))
		  end
	  end
    else if (@analysisunitname is null)
	  -- note: analysis units can be the same only if thicknesses are not null
	  begin
	    if ((@depth is not null) and (@thickness is not null))
		  begin
		    set @nanalunits = (select count(*) from ndb.analysisunits
                               group by collectionunitid, analysisunitid, analysisunitname, depth, thickness
                               having (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                  (analysisunitname is null) and (depth = @depth) and (thickness = @thickness))
            if (@nanalunits = 1)
			  set @newanalysisunitid = (select analysisunitid from ndb.analysisunits
                                        where (collectionunitid = @collunitid) and (analysisunitid <> @analysisunitid) and
					                    (analysisunitname is null) and (depth = @depth) and (thickness = @thickness))
	      end
	  end
    if (@newanalysisunitid is not null)  -- assign geochron sample to new existing analysis unit
	  begin
	    update ndb.samples set ndb.samples.analysisunitid = @newanalysisunitid where (ndb.samples.sampleid = @geochronsampleid)
		set @analysisunitid = @newanalysisunitid
	  end
    else  -- create new analysis unit and add geochron sample to it
	  begin
	    insert into ndb.analysisunits(collectionunitid, analysisunitname, depth, thickness, mixed)
        values (@collunitid, @analysisunitname, @depth, @thickness, 0)
		set @analysisunitid = scope_identity()
        update ndb.samples set ndb.samples.analysisunitid = @analysisunitid where (ndb.samples.sampleid = @geochronsampleid)
	  end
  end

select @analysisunitid






go

-- ----------------------------
-- procedure structure for updateissurfacesample
-- ----------------------------



create procedure [updateissurfacesample](@datasetid int, @issamp bit)
as
declare @nulldepths int
declare @mindepth float
declare @sampleid int
declare @modern int

if @issamp = 1
  begin
    -- ensure that all analysis units have depths, otherwise top sample not determinable
    set @nulldepths = (select count(*) from ndb.samples inner join
                      ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
                      where (ndb.analysisunits.depth is null) and (ndb.samples.datasetid = @datasetid))
    if @nulldepths = 0
	  begin
	    set @mindepth = (select min(ndb.analysisunits.depth) from ndb.samples inner join
                        ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
                        where (ndb.samples.datasetid = @datasetid))
        set @sampleid = (select ndb.samples.sampleid from ndb.samples inner join
                        ndb.analysisunits on ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
                        where (ndb.analysisunits.depth = @mindepth) and (ndb.samples.datasetid = @datasetid))
		set @modern = (select count(*) from ndb.samplekeywords where (ndb.samplekeywords.sampleid = @sampleid) and (ndb.samplekeywords.keywordid = 1))
		-- ensure modern keyword not already assigned
		if @modern = 0
		  begin
		    insert into ndb.samplekeywords(sampleid, keywordid)
            values      (@sampleid, 1)
		  end
	  end
  end
else if @issamp = 0
  begin
    delete k
    from   ndb.samplekeywords k
      inner join ndb.samples s on s.sampleid = k.sampleid
    where (s.datasetid = @datasetid) and (k.keywordid = 1)
  end




go

-- ----------------------------
-- procedure structure for updatelakeparam
-- ----------------------------

/*
1. in neotoma, need to change
2. not in neotoma, need to add
3. in neotoma, need to delete
*/

create procedure [updatelakeparam](@siteid int, @stewardcontactid int, @lakeparameter nvarchar(80), @value float = null)
as
declare @lakeparameterid int = (select lakeparameterid from ndb.lakeparametertypes where (lakeparameter = @lakeparameter))
declare @nparam int = (select count(*) as count from ndb.lakeparameters where (siteid = @siteid) group by lakeparameterid having (lakeparameterid = @lakeparameterid))
/* if @nparam is not null, then the lakeparameter is already in neotoma */

if @lakeparameterid is not null
  begin
    if @value is not null
	  begin
        if @nparam is not null  /* parameter in neotoma, need to change */
	      begin
            update ndb.lakeparameters
	        set value = @value where ((siteid = @siteid) and (lakeparameterid = @lakeparameterid))
		    insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation, columnname)
            values      (@stewardcontactid, n'lakeparameters', @siteid, @lakeparameterid, n'update', n'value')
	      end
		else     /* parameter not in neotoma, need to add */
		  begin
		    insert into ndb.lakeparameters (siteid, lakeparameterid, value)
            values      (@siteid, @lakeparameterid, @value)
			insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
            values      (@stewardcontactid, n'lakeparameters', @siteid, @lakeparameterid, n'insert')
		  end
	  end
	else   /* @value is null */
	  begin
	    if @nparam is not null  /* parameter in neotoma, need to delete */
		  begin
		    delete from ndb.lakeparameters
			where ((siteid = @siteid) and (lakeparameterid = @lakeparameterid))
			insert into ti.stewardupdates(contactid, tablename, pk1, pk2, operation)
            values      (@stewardcontactid, n'lakeparameters', @siteid, @lakeparameterid, n'delete')
		  end
	  end
  end





go

-- ----------------------------
-- procedure structure for updatepublication
-- ----------------------------


create procedure [updatepublication](@publicationid int,
@pubtypeid int,
@year nvarchar(64) = null,
@citation nvarchar(max),
@title nvarchar(max) = null,
@journal nvarchar(max) = null,
@vol nvarchar(16) = null,
@issue nvarchar(8) = null,
@pages nvarchar(24) = null,
@citnumber nvarchar(24) = null,
@doi nvarchar(128) = null,
@booktitle nvarchar(max) = null,
@numvol nvarchar(8) = null,
@edition nvarchar(24) = null,
@voltitle nvarchar(max) = null,
@sertitle nvarchar(max) = null,
@servol nvarchar(16) = null,
@publisher nvarchar(255) = null,
@url nvarchar(max) = null,
@city nvarchar(64) = null,
@state nvarchar(64) = null,
@country nvarchar(64) = null,
@origlang nvarchar(64) = null,
@notes nvarchar(max) = null)

as update ndb.publications

set pubtypeid = @pubtypeid, year = @year, citation = @citation, articletitle = @title, journal = @journal, volume = @vol,
    issue = @issue, pages = @pages, citationnumber = @citnumber, doi = @doi, booktitle = @booktitle, numvolumes = @numvol,
    edition = @edition, volumetitle = @voltitle, seriestitle = @sertitle, seriesvolume = @servol, publisher = @publisher,
    url = @url, city = @city, state = @state, country = @country, originallanguage = @origlang, notes = @notes
where publicationid = @publicationid






go

-- ----------------------------
-- procedure structure for updatepublicationauthor
-- ----------------------------



create procedure [updatepublicationauthor](@authorid int,
@publicationid int,
@authororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null,
@contactid int)

as update ndb.publicationauthors

set publicationid = @publicationid, authororder = @authororder, familyname = @familyname, initials = @initials,
    suffix = @suffix, contactid = @contactid
where authorid = @authorid







go

-- ----------------------------
-- procedure structure for updatepublicationeditor
-- ----------------------------




create procedure [updatepublicationeditor](@editorid int,
@publicationid int,
@editororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null)

as update ndb.publicationeditors

set publicationid = @publicationid, editororder = @editororder, familyname = @familyname, initials = @initials, suffix = @suffix
where editorid = @editorid








go

-- ----------------------------
-- procedure structure for updatepublicationtranslator
-- ----------------------------





create procedure [updatepublicationtranslator](@translatorid int,
@publicationid int,
@translatororder int,
@familyname nvarchar(64),
@initials nvarchar(8) = null,
@suffix nvarchar(8) = null)

as update ndb.publicationtranslators

set publicationid = @publicationid, translatororder = @translatororder, familyname = @familyname, initials = @initials, suffix = @suffix
where translatorid = @translatorid









go

-- ----------------------------
-- procedure structure for updateradiocarbon
-- ----------------------------


create procedure [updateradiocarbon](@geochronid int,
@radiocarbonmethodid int = null,
@percentc float = null,
@percentn float = null,
@delta13c float = null,
@delta15n float = null,
@percentcollagen float = null,
@reservoir float = null)

as
update ndb.radiocarbon
set    radiocarbonmethodid = @radiocarbonmethodid, percentc = @percentc, percentn = @percentn, delta13c = @delta13c,
       delta15n = @delta15n, percentcollagen = @percentcollagen, reservoir = @reservoir
where  geochronid = @geochronid

go

-- ----------------------------
-- procedure structure for updaterelativeage
-- ----------------------------




create procedure [updaterelativeage](@relativeageid int,
@relativeageunitid int,
@relativeagescaleid int,
@relativeage nvarchar(64),
@c14ageyounger float = null,
@c14ageolder float = null,
@calageyounger float = null,
@calageolder float = null,
@notes nvarchar(max) = null)

as update ndb.relativeages

set relativeageunitid = @relativeageunitid, relativeagescaleid = @relativeagescaleid, relativeage = @relativeage, c14ageyounger = @c14ageyounger, c14ageolder = @c14ageolder,
    calageyounger = @calageyounger, calageolder = @calageolder, notes = @notes
where relativeageid = @relativeageid





go

-- ----------------------------
-- procedure structure for updatereplacepublicationid
-- ----------------------------




create procedure [updatereplacepublicationid](@keeppubid int, @deposepubid int)
as
/* replace @deposepubid with @keeppubid and delete @deposepubid */

declare @n int
declare @results table
(
  id int not null primary key identity(1,1),
  result nvarchar(255)
)

set @n = (select count(*) from ndb.publications where (publicationid = @keeppubid))
if (@n = 0)
  begin
    insert into @results select (concat(n'keeppubid ' ,cast(@keeppubid as nvarchar), n' does not exist. procedure aborted.'))
	select result from @results
	return
  end
set @n = (select count(*) from ndb.publications where (publicationid = @deposepubid))
if (@n = 0)
  begin
    insert into @results select (concat(n'deposepubid ' ,cast(@deposepubid as nvarchar), n' does not exist. procedure aborted.'))
	select result from @results
	return
  end


set @n = (select count(*) from ndb.publications where (publicationid = @deposepubid))

set @n = (select count(*) from ndb.calibrationcurves where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.calibrationcurves
    set    ndb.calibrationcurves.publicationid = @keeppubid
    where  (ndb.calibrationcurves.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from calibrationcurves = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.datasetpublications where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.datasetpublications
    set    ndb.datasetpublications.publicationid = @keeppubid
    where  (ndb.datasetpublications.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from datasetpublications = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.eventpublications where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.eventpublications
    set    ndb.eventpublications.publicationid = @keeppubid
    where  (ndb.eventpublications.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from eventpublications = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.externalpublications where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.externalpublications
    set    ndb.externalpublications.publicationid = @keeppubid
    where  (ndb.externalpublications.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from externalpublications = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.formtaxa where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.formtaxa
    set    ndb.formtaxa.publicationid = @keeppubid
    where  (ndb.formtaxa.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from formtaxa = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.geochronpublications where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.geochronpublications
    set    ndb.geochronpublications.publicationid = @keeppubid
    where  (ndb.geochronpublications.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from geochronpublications = .' ,cast(@n as nvarchar)))

set @n = (select count(*) from ndb.relativeagepublications where (publicationid = @deposepubid))
if (@n > 0)
  begin
    update ndb.relativeagepublications
    set    ndb.relativeagepublications.publicationid = @keeppubid
    where  (ndb.relativeagepublications.publicationid = @deposepubid)
  end
insert into @results select (concat(n'records updated from relativeagepublications = .' ,cast(@n as nvarchar)))

delete from ndb.publications
where publicationid = @deposepubid
insert into @results select (concat(n'publicationdid ', cast(@deposepubid as nvarchar), n' deleted from publications table.'))

select result from @results







go

-- ----------------------------
-- procedure structure for updatesampleage
-- ----------------------------




create procedure [updatesampleage](@sampleageid int,
@age float = null,
@ageyounger float = null,
@ageolder float = null)
as
if (@age is not null)
  begin
    update ndb.sampleages
    set    ndb.sampleages.age = @age
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end
else
  begin
    update ndb.sampleages
    set    ndb.sampleages.age = null
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end

if (@ageyounger is not null)
  begin
    update ndb.sampleages
    set    ndb.sampleages.ageyounger = @ageyounger
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end
else
  begin
    update ndb.sampleages
    set    ndb.sampleages.ageyounger = null
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end

if (@ageolder is not null)
  begin
    update ndb.sampleages
    set    ndb.sampleages.ageolder = @ageolder
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end
else
  begin
    update ndb.sampleages
    set    ndb.sampleages.ageolder = null
    where  (ndb.sampleages.sampleageid = @sampleageid)
  end


go

-- ----------------------------
-- procedure structure for updatesampleanalysisunit
-- ----------------------------



create procedure [updatesampleanalysisunit](@sampleid int, @analunitid int)
as
update ndb.samples
set analysisunitid = @analunitid
where sampleid = @sampleid





go

-- ----------------------------
-- procedure structure for updatesamplelabnumber
-- ----------------------------




create procedure [updatesamplelabnumber](@sampleid int, @labnumber nvarchar(40) = null)
as
if (@labnumber is null or @labnumber = n'')
  begin
    update ndb.samples
    set    ndb.samples.labnumber = null
    where  (ndb.samples.sampleid = @sampleid)
  end
else
  begin
    update ndb.samples
    set    ndb.samples.labnumber = @labnumber
    where  (ndb.samples.sampleid = @sampleid)
  end



go

-- ----------------------------
-- procedure structure for updatesite
-- ----------------------------




create procedure [updatesite](@siteid int,
@stewardcontactid int,
@sitename nvarchar(128),
@east float = null,
@north float = null,
@west float = null,
@south float = null,
@altitude int = null,
@area float = null,
@descript nvarchar(max) = null,
@notes nvarchar(max) = null)

as
declare @oldsitename nvarchar(128) = (select sitename from ndb.sites where siteid = @siteid)
declare @oldaltitude float = (select altitude from ndb.sites where siteid = @siteid)
declare @oldarea float = (select area from ndb.sites where siteid = @siteid)
declare @oldsitedescription nvarchar(max) = (select sitedescription from ndb.sites where siteid = @siteid)
declare @oldnotes nvarchar(max) = (select notes from ndb.sites where siteid = @siteid)
declare @oldgeog geography = (select geog from ndb.sites where siteid = @siteid)

if @oldsitename <> @sitename
  begin
    update ndb.sites
    set sitename = @sitename where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'sitename')
  end

declare @geog geography
if ((@north > @south) and (@east > @west))
  set @geog = geography::stgeomfromtext('polygon((' +
              cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
              cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + '))', 4326).makevalid()
else
  set @geog = geography::stgeomfromtext('point(' + cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ')', 4326).makevalid()
if (@geog.stequals(@oldgeog) is null)
  begin
    update ndb.sites
    set geog = @geog where siteid = @siteid
	insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'geog')
  end

if @altitude is null
  begin
    if @oldaltitude is not null
      begin
        update ndb.sites
        set altitude = null where siteid = @siteid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'sites', @siteid, n'update', n'altitude')
      end
  end
else if (@oldaltitude is null) or (@altitude <> @oldaltitude)
  begin
    update ndb.sites
    set altitude = @altitude where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'altitude')
  end
if @area is null
  begin
    if @oldarea is not null
      begin
        update ndb.sites
        set area = null where siteid = @siteid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'sites', @siteid, n'update', n'area')
      end
  end
else if (@oldarea is null) or (@area <> @oldarea)
  begin
    update ndb.sites
    set area = @area where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'area')
  end
if @descript is null
  begin
    if @oldsitedescription is not null
      begin
        update ndb.sites
        set sitedescription = null where siteid = @siteid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'sites', @siteid, n'update', n'sitedescription')
      end
  end
else if (@oldsitedescription is null) or (@descript <> @oldsitedescription)
  begin
    update ndb.sites
    set sitedescription = @descript where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'sitedescription')
  end
if @notes is null
  begin
    if @oldnotes is not null
      begin
        update ndb.sites
        set notes = null where siteid = @siteid
	    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
        values      (@stewardcontactid, n'sites', @siteid, n'update', n'notes')
      end
  end
else if (@oldnotes is null) or (@notes <> @oldnotes)
  begin
    update ndb.sites
    set notes = @notes where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'notes')
  end

go

-- ----------------------------
-- procedure structure for updatesitegeopol
-- ----------------------------

create procedure [updatesitegeopol](@siteid int, @stewardcontactid int, @oldgeopolid int, @newgeopolid int)
as
declare @sitegeopolid int = (select sitegeopoliticalid from ndb.sitegeopolitical where (siteid = @siteid and geopoliticalid = @oldgeopolid))
if @sitegeopolid is not null
begin
  update ndb.sitegeopolitical
  set geopoliticalid = @newgeopolid where sitegeopoliticalid = @sitegeopolid
  insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
  values      (@stewardcontactid, n'sitegeopolitical', @sitegeopolid, n'update', n'geopoliticalid')
end



go

-- ----------------------------
-- procedure structure for updatesitegeopoldelete
-- ----------------------------



create procedure [updatesitegeopoldelete](@stewardcontactid int, @siteid int, @geopoliticalid int)
as
declare @sitegeopolid int = (select sitegeopoliticalid from ndb.sitegeopolitical where (siteid = @siteid and geopoliticalid = @geopoliticalid))
if @sitegeopolid is not null
  begin
    delete from ndb.sitegeopolitical where (sitegeopoliticalid = @sitegeopolid)
    insert into ti.stewardupdates(contactid, tablename, pk1, operation)
    values      (@stewardcontactid, n'sitegeopolitical', @sitegeopolid, n'delete')
  end



go

-- ----------------------------
-- procedure structure for updatesitegeopolinsert
-- ----------------------------




create procedure [updatesitegeopolinsert](@siteid int, @stewardcontactid int, @geopoliticalid int)

as
insert into ndb.sitegeopolitical(siteid, geopoliticalid)
values      (@siteid, @geopoliticalid)

/*
---return id
declare @newsitegeopoliticalid int = (select scope_identity())
select @newsitegeopoliticalid
*/

declare @newsitegeopoliticalid int = (select sitegeopoliticalid from ndb.sitegeopolitical where (siteid = @siteid and geopoliticalid = @geopoliticalid))
insert into ti.stewardupdates(contactid, tablename, pk1, operation)
values      (@stewardcontactid, n'sitegeopolitical', @newsitegeopoliticalid, n'insert')

go

-- ----------------------------
-- procedure structure for updatesitelatlon
-- ----------------------------



create procedure [updatesitelatlon](@siteid int, @stewardcontactid int, @east float, @north float, @west float, @south float)
as
declare @oldgeog geography = (select geog from ndb.sites where siteid = @siteid)
declare @geog geography
if ((@north > @south) and (@east > @west))
  set @geog = geography::stgeomfromtext('polygon((' +
              cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
              cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@east as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ', ' +
			  cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@south as decimal(20,15)) as varchar(20)) + '))', 4326).makevalid()
else
  set @geog = geography::stgeomfromtext('point(' + cast(cast(@west as decimal(20,15)) as varchar(20)) + ' ' + cast(cast(@north as decimal(20,15)) as varchar(20)) + ')', 4326).makevalid()
if (@geog.stequals(@oldgeog) = 0)
  begin
    update ndb.sites
    set    geog = @geog where siteid = @siteid
    insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
    values      (@stewardcontactid, n'sites', @siteid, n'update', n'geog')
  end

go

-- ----------------------------
-- procedure structure for updatespecimendatetaxonid
-- ----------------------------




create procedure [updatespecimendatetaxonid](@oldtaxonid int, @newtaxonid int)
as
update ndb.specimendates
set taxonid = @newtaxonid
where taxonid = @oldtaxonid




go

-- ----------------------------
-- procedure structure for updatespecimennisp
-- ----------------------------





create procedure [updatespecimennisp](@specimenid int, @nisp float, @contactid int)
as
update ndb.specimens
set ndb.specimens.nisp = @nisp
where ndb.specimens.specimenid = @specimenid
insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
values (@contactid, n'specimens', @specimenid, n'update', n'nisp')

go

-- ----------------------------
-- procedure structure for updatesynonymtypeid
-- ----------------------------



create procedure [updatesynonymtypeid](@synonymid int, @synonymtypeid int)
as
update ndb.synonyms
set synonymtypeid = @synonymtypeid
where synonymid = @synonymid





go

-- ----------------------------
-- procedure structure for updatesynonymy
-- ----------------------------



create procedure [updatesynonymy](@synonymyid int,
@reftaxonid int,
@fromcontributor bit = 0,
@publicationid int = null,
@notes nvarchar(max) = null,
@contactid int = null,
@datesynonymized date = null)

as
update ndb.synonymy
set reftaxonid = @reftaxonid,
    fromcontributor = @fromcontributor,
	publicationid = @publicationid,
	notes = @notes,
	contactid = @contactid,
	datesynonymized = convert(datetime, @datesynonymized, 105)
where synonymyid = @synonymyid

insert into ti.stewardupdates(contactid, tablename, pk1, operation)
values      (@contactid, n'synonymy', @synonymyid, n'update')





go

-- ----------------------------
-- procedure structure for updatetaphonomicsystemnotes
-- ----------------------------




create procedure [updatetaphonomicsystemnotes](@taphonomicsystemid int, @notes nvarchar(max))

as update ndb.taphonomicsystems

set notes = @notes
where taphonomicsystemid = @taphonomicsystemid







go

-- ----------------------------
-- procedure structure for updatetaxonauthor
-- ----------------------------


create procedure [updatetaxonauthor](@taxonid int, @author nvarchar(128) = null)
as
update ndb.taxa
set author = @author
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for updatetaxoncode
-- ----------------------------


create procedure [updatetaxoncode](@taxonid int, @taxoncode nvarchar(64))
as
update ndb.taxa
set taxoncode = @taxoncode
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for updatetaxonextinct
-- ----------------------------


create procedure [updatetaxonextinct](@taxonid int, @extinct bit)
as
update ndb.taxa
set extinct = @extinct
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for updatetaxonhighertaxonid
-- ----------------------------



create procedure [updatetaxonhighertaxonid](@taxonid int, @highertaxonid int)
as
update ndb.taxa
set highertaxonid = @highertaxonid
where taxonid = @taxonid





go

-- ----------------------------
-- procedure structure for updatetaxonhighertaxonidtonull
-- ----------------------------




create procedure [updatetaxonhighertaxonidtonull](@taxonid int)
as
update ndb.taxa
set highertaxonid = null
where taxonid = @taxonid



go

-- ----------------------------
-- procedure structure for updatetaxonname
-- ----------------------------


create procedure [updatetaxonname](@taxonid int, @taxonname nvarchar(80))
as
update ndb.taxa
set taxonname = @taxonname
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for updatetaxonnotes
-- ----------------------------



create procedure [updatetaxonnotes](@taxonid int, @notes nvarchar(max) = null)
as
update ndb.taxa
set notes = @notes
where taxonid = @taxonid





go

-- ----------------------------
-- procedure structure for updatetaxonpublicationid
-- ----------------------------


create procedure [updatetaxonpublicationid](@taxonid int, @publicationid int = null)
as
update ndb.taxa
set publicationid = @publicationid
where taxonid = @taxonid




go

-- ----------------------------
-- procedure structure for updatetaxonvalidation
-- ----------------------------


create procedure [updatetaxonvalidation](@taxonid int, @validatorid int, @validatedate nvarchar(10))
as
update ndb.taxa
set validatorid = @validatorid, validatedate = @validatedate
where taxonid = @taxonid

/* convert(varchar(10), cast(@validatedate as datetime), 105)
   convert(datetime, @validatedate, 105) */


go

-- ----------------------------
-- procedure structure for updatetaxonvalidity
-- ----------------------------



create procedure [updatetaxonvalidity](@taxonid int, @valid bit)
as
update ndb.taxa
set valid = @valid
where taxonid = @taxonid





go

-- ----------------------------
-- procedure structure for updatevariabletaxonid
-- ----------------------------


create procedure [updatevariabletaxonid](@variableid int, @newtaxonid int)
as
update ndb.variables
set    taxonid = @newtaxonid
where  (variableid = @variableid)



go

-- ----------------------------
-- procedure structure for validatesteward
-- ----------------------------


create procedure [validatesteward](@username nvarchar(15), @pwd nvarchar(15))
as
select     ndb.constituentdatabases.databaseid
from         ti.stewards inner join
                      ti.stewarddatabases on ti.stewards.stewardid = ti.stewarddatabases.stewardid inner join
                      ndb.constituentdatabases on ti.stewarddatabases.databaseid = ndb.constituentdatabases.databaseid
where     (ti.stewards.username = @username) and (ti.stewards.pwd = @pwd)





go

-- ----------------------------
-- procedure structure for validateusername
-- ----------------------------


create procedure [validateusername](@username nvarchar(15))
as
select     contactid, taxonomyexpert
from         ti.stewards
where     (username = @username)






go
