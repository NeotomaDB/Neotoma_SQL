COMMENT ON COLUMN ndb.agetypes.agetype IS 'Age type or units:
* Calendar years AD/BC
* Calendar years BP
* Calibrated radiocarbon years BP
* Radiocarbon years BP
* Varve years BP';
COMMENT ON COLUMN ndb.aggregatechronologies.aggregatedatasetid IS 'Dataset to which the Aggregate Chronology applies. Field links to the AggregateDatasets table.';
COMMENT ON COLUMN ndb.aggregatechronologies.notes IS 'Free form notes or comments about the Aggregate Chronology.';
COMMENT ON COLUMN ndb.aggregatechronologies.ageboundolder IS 'The older reliable age bound for the Aggregate Chronology. Ages older than AgeOlderBound may be assigned to samples, but are not regarded as reliable. This situation is particularly true for ages extrapolated beyond the oldest Chron Control. If the entire Chronology is considered reliable, AgeBoundOlder is assigned the oldest sample age rounded up to the nearest 10. Thus, for 12564 BP, AgeBoundOlder is 12570.';
COMMENT ON COLUMN ndb.aggregatechronologies.ageboundyounger IS 'The younger reliable age bound for the Aggregate Chronology. Younger ages may be assigned to samples, but are not regarded as reliable. If the entire Chronology is considered reliable, AgeBoundYounger is assigned the youngest sample age rounded down to the nearest 10. Thus, for 72 BP, AgeBoundYounger = 70 BP; for -45 BP, AgeBoundYounger = -50 BP.';
COMMENT ON COLUMN ndb.aggregatechronologies.chronologyname IS 'Optional name for the Chronology.';
COMMENT ON COLUMN ndb.aggregatechronologies.isdefault IS 'Indicates whether the Aggregate Chronology is a default or not. Default status is determined by a Neotoma data steward. Aggregate Datasets may have more than one default Aggregate Chronology, but may have only one default Aggregate Chronology per Age Type.'
;
COMMENT ON COLUMN ndb.aggregatechronologies.agetypeid IS 'Age type or units. Field links to the AgeTypes table.';
COMMENT ON COLUMN ndb.aggregatedatasets.aggregatedatasetid IS 'An arbitrary Aggregate Dataset identification number.';
COMMENT ON COLUMN ndb.aggregatedatasets.aggregatedatasetname IS 'Name of Aggregate Dataset.';
COMMENT ON COLUMN ndb.aggregatedatasets.aggregateordertypeid IS 'Aggregate Order Type identification number. Field links to the AggregateOrderTypes lookup table.';
COMMENT ON COLUMN ndb.aggregatedatasets.notes IS 'Free form notes about the Aggregate Order Type.';
COMMENT ON COLUMN ndb.aggregateordertypes.notes IS 'Free form notes or comments about the Aggregate Order Type.';
COMMENT ON COLUMN ndb.aggregateordertypes.aggregateordertypeid IS 'An arbitrary Aggregate Order Type identification number.';
COMMENT ON COLUMN ndb.aggregateordertypes.aggregateordertype IS 'The Aggregate Order Type.';
COMMENT ON COLUMN ndb.aggregatesampleages.sampleageid IS 'Sample Age ID number. Field links to the SampleAges table.';
COMMENT ON COLUMN ndb.aggregatesampleages.aggregatechronid IS 'Aggregate Chronology identification number Field links to the AggregateChronologies table.';
COMMENT ON COLUMN ndb.aggregatesampleages.aggregatedatasetid IS 'Aggregate Dataset identification number. Field links to the AggregateDatasets table.';
COMMENT ON COLUMN ndb.aggregatesamples.sampleid IS 'Sample ID number. Field links to the Samples table.';
COMMENT ON COLUMN ndb.aggregatesamples.aggregatedatasetid IS 'An arbitrary Aggregate Dataset identification number. Field links to the AggregateDatasets table.
';
COMMENT ON COLUMN ndb.analysisunits.analysisunitname IS 'Optional name for an Analysis Unit. Analysis Units are usually designated with either a depth or a name, sometimes both.';
COMMENT ON COLUMN ndb.analysisunits.notes IS 'Free form notes or comments about the Analysis Unit.';
COMMENT ON COLUMN ndb.analysisunits.igsn IS 'International Geo Sample Number. The IGSN is a unique identifier for a Geoscience sample. They are assigned by the SESAR, the System for Earth Sample Registration (www.geosamples.org), which is a registry that provides and administers the unique identifiers. IGSN’s may be assigned to all types of geoscience samples, including cores, rocks, minerals, and even fluids. Their purpose is to facilitate sharing and correlation of samples and sample-based data. For data in Neotoma, their primary value would be for correlation various samples from the same Analysis Units, for example pollen, charcoal, diatoms, and geochemical analyses. Conceivably, the AnalysisUnitID could be used for this purpose; however, IGSN’s could be assigned by projects before their data are submitted to the database. Moreover, AnalysisUnitID’s are intended to be internal to the database. Although IGSN’s could be assigned to Neotoma Collection Units and Samples, their primary value lies in their assignment to Analysis Units. IGSN’s are not yet assigned to Neotoma Analysis Units; however, that may change after consultation with SESAR.';
COMMENT ON COLUMN ndb.analysisunits.mixed IS 'Indicates whether specimens in the Analysis Unit are of mixed ages, for example Pleistocene fossils occurring with late Holocene fossils. Although Analysis Units may be mixed, samples from the Analysis Unit may not be, for example individually radiocarbon dated specimens.';
COMMENT ON COLUMN ndb.analysisunits.faciesid IS 'Sedimentary facies of the Analysis Unit. Field links to the FaciesTypes table.';
COMMENT ON COLUMN ndb.analysisunits.thickness IS 'Optional thickness of the Analysis Unit in cm. For many microfossil core samples, the depths are treated as points, and the thicknesses are not given in the publications, although 0.5 to 1.0 cm would be typical.';
COMMENT ON COLUMN ndb.analysisunits.depth IS 'Optional depth of the Analysis Unit in cm. Depths are typically designated for Analysis Units from cores and for Analysis Units excavated in arbitrary (e.g. 10 cm) levels. Depths are normally the midpoints of arbitrary levels. For example, for a level excavated from 10 to 20 cm or for a core section from 10 to 15 cm, the depth is 15. Designating depths as midpoints and thicknesses facilitates calculation of ages from age models that utilize single midpoint depths for Analysis Units rather than top and bottom depths. Of course, top and bottom depths can be calculated from midpoint depths and thicknesses. For many microfossil core samples, only the midpoint depths are known or published; the diameter or width of the sampling device is often not given.';
COMMENT ON COLUMN ndb.analysisunits.collectionunitid IS 'Collection Unit ID number. Field links to CollectionUnits table. Every Analysis Unit belongs to a Collection Unit.';
COMMENT ON COLUMN ndb.analysisunits.analysisunitid IS 'An arbitrary Analysis Unit identification number.';
COMMENT ON COLUMN ndb.chroncontrols.chroncontroltypeid IS 'The type of Chronology Control. Field links to the ChronControlTypes table.';
COMMENT ON COLUMN ndb.chroncontrols.notes IS 'Free form notes or comments about the Chronology Control.';
COMMENT ON COLUMN ndb.chroncontrols.agelimitolder IS 'The older age limit of a Chronology Control.';
COMMENT ON COLUMN ndb.chroncontrols.agelimityounger IS 'The younger age limit of a Chronology Control. This limit may be explicitly defined, for example the younger of the 2-sigma range limits of a calibrated radiocarbon date, or it may be more loosely defined, for example the younger limit on the range of dates for a biostratigraphic horizon.';
COMMENT ON COLUMN ndb.chroncontrols.age IS 'Age of the Chronology Control.';
COMMENT ON COLUMN ndb.chroncontrols.thickness IS 'Thickness of the Chronology Control in cm.';
COMMENT ON COLUMN ndb.chroncontrols.depth IS 'Depth of the Chronology Control in cm.';
COMMENT ON COLUMN ndb.chroncontrols.chronologyid IS 'Chronology to which the ChronControl belongs. Field links to the Chronolgies table.';
COMMENT ON COLUMN ndb.chroncontrols.chroncontrolid IS 'An arbitrary Chronology Control identification number.';
COMMENT ON COLUMN ndb.chroncontroltypes.chroncontroltypeid IS 'An arbitrary Chronology Control Type identification number.';
COMMENT ON COLUMN ndb.chroncontroltypes.chroncontroltype IS 'The Chronology Control Type. Chronology Controls include such geophysical controls as radiocarbon dates, calibrated radiocarbon dates, averages of several radiocarbon dates, potassium-argon dates, and thermoluminescence dates, as well as biostratigraphic controls, sediment stratigraphic controls, volcanic tephras, archaeological cultural associations, and any other types of age controls.';
COMMENT ON COLUMN ndb.chronologies.contactid IS 'Person who developed the Age Model. Field links to the Contacts table.';
COMMENT ON COLUMN ndb.chronologies.agetypeid IS 'Age type or units. Field links to the AgeTypes table.';
COMMENT ON COLUMN ndb.chronologies.collectionunitid IS 'Collection Unit to which the Chronology applies. Field links to the CollectionUnits table.';
COMMENT ON COLUMN ndb.chronologies.chronologyid IS 'An arbitrary Chronology identification number.';
COMMENT ON COLUMN ndb.chronologies.notes IS 'Free form notes or comments about the Chronology.';
COMMENT ON COLUMN ndb.chronologies.ageboundolder IS 'The older reliable age bound for the Chronology. Ages older than AgeOlderBound may be assigned to samples, but are not regarded as reliable. This situation is particularly true for ages extrapolated beyond the oldest Chron Control. . If the entire Chronology is considered reliable, AgeBoundOlder is assigned the oldest sample age rounded up to the nearest 10. Thus, for 12564 BP, AgeBoundOlder is 12570.';
COMMENT ON COLUMN ndb.chronologies.ageboundyounger IS 'The younger reliable age bound for the Chronology. Younger ages may be assigned to samples, but are not regarded as reliable. If the entire Chronology is considered reliable, AgeBoundYounger is assigned the youngest sample age rounded down to the nearest 10. Thus, for 72 BP, AgeBoundYounger = 70 BP; for -45 BP, AgeBoundYounger = -50 BP.';
COMMENT ON COLUMN ndb.chronologies.agemodel IS 'The age model used for the Chronology. Some examples are: linear interpolation, 3rd order polynomial, and individually dated analysis units.';
COMMENT ON COLUMN ndb.chronologies.dateprepared IS 'Date that the Chronology was prepared.';
COMMENT ON COLUMN ndb.chronologies.chronologyname IS 'Optional name for the Chronology. Some examples are:
COHMAP chron 1 A Chronology assigned by the COHMAP project.
COHMAP chron 2 An alternative Chronology assigned by the COHMAP project
NAPD 1 A Chronology assigned by the North American Pollen Database.
Gajewski 1995 A Chronology assigned by Gajewski (1995).';
COMMENT ON COLUMN ndb.chronologies.isdefault IS 'Indicates whether the Chronology is a default chronology or not. Default status is determined by a Neotoma data steward. Collection Units may have more than one default Chronology, but may have only one default Chronology per Age Type. Thus, there may be a default radiocarbon year Chronology and a default calibrated radiocarbon year Chronology, but only one of each. Default Chronologies may be used by the Neotoma web site, or other web sites, for displaying default diagrams or time series of data. Default Chronologies may also be of considerable use for actual research purposes; however, users may of course choose to develop their own chronologies.';
COMMENT ON COLUMN ndb.collectiontypes.colltype IS 'The Collection Type. Types include cores, sections, excavations, and animal middens. Collection Units may be modern collections, surface float, or isolated specimens. Composite Collections Units include different kinds of Analysis Units, for example a modern surface sample for ostracodes and an associated water sample.';
COMMENT ON COLUMN ndb.collectiontypes.colltypeid IS 'An arbitrary Collection Type identification number.';
COMMENT ON COLUMN ndb.collectionunits.collectionunitid IS 'An arbitrary Collection Unit identification number.';
COMMENT ON COLUMN ndb.collectionunits.handle IS 'Code name for the Collection Unit. This code may be up to 10 characters, but an effort is made to keep these to 8 characters or less. Data are frequently distributed by Collection Unit, and the Handle is used for file names.';
COMMENT ON COLUMN ndb.collectionunits.siteid IS 'Site where CollectionUnit was located. Field links to Sites table.';
COMMENT ON COLUMN ndb.collectionunits.colltypeid IS 'Type of Collection Unit. Field links to the CollectionTypes table.';
COMMENT ON COLUMN ndb.collectionunits.depenvtid IS 'Depositional environment of the CollectionUnit. Normally, this key refers to the modern environment. For example, the site may be located on a colluvial slope, in which case the Depositional Environment may be Colluvium or Colluvial Fan. However, an excavation may extend into alluvial sediments, which represent a different depositional environment. These are accounted for by the Facies of the AnalysisUnit. Field links to the DepEnvtTypes table.';
COMMENT ON COLUMN ndb.collectionunits.collunitname IS 'Name of the Collection Unit. Examples: Core BPT82A, Structure 9, P4A Test 57. If faunal data are reported from a site or locality without explicit Collection Units, then data are assigned to a single Collection Unit with the name «Locality».';
COMMENT ON COLUMN ndb.collectionunits.colldate IS 'Date Collection Unit was collected.';
COMMENT ON COLUMN ndb.collectionunits.gpslatitude IS 'Precise latitude of the Collection Unit, typically taken with a GPS, although may be precisely measured from a map.';
COMMENT ON COLUMN ndb.collectionunits.gpslongitude IS 'Precise longitude of the Collection Unit, typically taken with a GPS, although may be precisely measured from a map.';
COMMENT ON COLUMN ndb.collectionunits.gpsaltitude IS 'Precise altitude of the Collection Unit, typically taken with a GPS or precisely obtained from a map.';
COMMENT ON COLUMN ndb.collectionunits.gpserror IS 'Error in the horizontal GPS coordinates, if known.';
COMMENT ON COLUMN ndb.collectionunits.waterdepth IS 'Depth of water at the Collection Unit location. This field applies mainly to Collection Units from lakes.';
COMMENT ON COLUMN ndb.collectionunits.substrateid IS 'Substrate or rock type on which the Collection Unit lies. Field links to the RockTypes table. This field is especially used for rodent middens.';
COMMENT ON COLUMN ndb.collectionunits.slopeaspect IS 'For Collection Units on slopes, the horizontal direction to which a slope faces measured in degrees clockwise from north. This field is especially used for rodent middens.';
COMMENT ON COLUMN ndb.collectionunits.slopeangle IS 'For Collection Units on slopes, the angle of slope from horizontal. field is especially used for rodent middens.';
COMMENT ON COLUMN ndb.collectionunits.location IS 'Short description of the location of the Collection Unit within the site.';
COMMENT ON COLUMN ndb.collectionunits.notes IS 'Free form notes or comments about the Collection Unit.';
COMMENT ON COLUMN ndb.collectors.collectorid IS 'An arbitrary Collector identification number.';
COMMENT ON COLUMN ndb.collectors.collectororder IS 'Order in which Collectors should be listed.';
COMMENT ON COLUMN ndb.collectors.contactid IS 'Person who collected the CollectionUnit. Multiple individuals are listed in separate records. Field links to the Contacts table.';
COMMENT ON COLUMN ndb.collectors.collectionunitid IS 'CollectionUnit collected. Field links to CollectionUnits table.';
COMMENT ON COLUMN ndb.contacts.address IS 'Full mailing address.';
COMMENT ON COLUMN ndb.contacts.contactname IS 'Full name of the person, last name first (e.g. «Simpson, George Gaylord») or name of organization or project (e.g. «Great Plains Flora Association»).';
COMMENT ON COLUMN ndb.contacts.contactstatusid IS 'Current status of the person, organization, or project. Field links to the ContactStatuses lookup table.';
COMMENT ON COLUMN ndb.contacts.contactid IS 'An arbitrary Contact identification number.';
COMMENT ON COLUMN ndb.contacts.familyname IS 'Family or surname name of a person.';
COMMENT ON COLUMN ndb.contacts.leadinginitials IS 'Leading initials for given or forenames without spaces (e.g. «G.G.»).';
COMMENT ON COLUMN ndb.contacts.givennames IS 'Given or forenames of a person (e.g. «George Gaylord»). Initials with spaces are used if full given names are not known (e.g. «G. G»).';
COMMENT ON COLUMN ndb.contacts.suffix IS 'Suffix of a person''s name (e.g. «Jr.», «III»).';
COMMENT ON COLUMN ndb.contacts.notes IS 'Free form notes or comments about the person, organization, or project.';
COMMENT ON COLUMN ndb.contacts.title IS 'A person’s title (e.g. «Dr.», «Prof.», «Prof. Dr»).';
COMMENT ON COLUMN ndb.contacts.aliasid IS 'The ContactID of a person’s current name. If the AliasID is different from the ContactID, the ContactID refers to the person’s former name. For example, if J. L. Bouvier became J. B. Kennedy, the ContactID for J. B. Kennedy is the AliasID for J. L. Bouvier.';
COMMENT ON COLUMN ndb.contacts.phone IS 'Telephone number.';
COMMENT ON COLUMN ndb.contacts.fax IS 'Fax number.';
COMMENT ON COLUMN ndb.contacts.email IS 'Email address.';
COMMENT ON COLUMN ndb.contacts.url IS 'Universal Resource Locator, an Internet World Wide Web address.';
COMMENT ON COLUMN ndb.contactstatuses.contactstatus IS 'Status of person, organization, or project.';
COMMENT ON COLUMN ndb.contactstatuses.statusdescription IS 'Description of the status.';
COMMENT ON COLUMN ndb.contactstatuses.contactstatusid IS 'An arbitrary Contact Status identification number.';
COMMENT ON COLUMN ndb.data.variableid IS 'Variable identification number. Field links to Variables table.';
COMMENT ON COLUMN ndb.data.value IS 'The value of the variable.';
COMMENT ON COLUMN ndb.data.sampleid IS 'Sample identification number. Field links to Samples table.';
COMMENT ON COLUMN ndb.datasetpis.contactid IS 'Contact identification number. Field links to Contacts table.';
COMMENT ON COLUMN ndb.datasetpis.piorder IS 'Order in which PIs are listed.';
COMMENT ON COLUMN ndb.datasetpis.datasetid IS 'Dataset identification number. Field links to Dataset table.';
COMMENT ON COLUMN ndb.datasetpublications.publicationid IS 'Publication identification number. Field links to Publications table.';
COMMENT ON COLUMN ndb.datasetpublications.primarypub IS 'Is «True» if the publication is the primary publication for the dataset.';
COMMENT ON COLUMN ndb.datasetpublications.datasetid IS 'Dataset identification number. Field links to Dataset table.';
COMMENT ON COLUMN ndb.datasets.notes IS 'Free form notes or comments about the Dataset.';
COMMENT ON COLUMN ndb.datasets.datasetname IS 'Optional name for the Dataset.';
COMMENT ON COLUMN ndb.datasets.datasettypeid IS 'Dataset Type identification number. Field links to the DatasetTypes lookup table.';
COMMENT ON COLUMN ndb.datasets.collectionunitid IS 'Collection Unit identification number. Field links to the CollectionUnits table.';
COMMENT ON COLUMN ndb.datasets.datasetid IS 'An arbitrary Dataset identification number.';
COMMENT ON COLUMN ndb.datasetsubmissions.submissionid IS 'An arbitrary submission identification number.';
COMMENT ON COLUMN ndb.datasetsubmissions.datasetid IS 'Dataset identification number. Field links to the Datasets table. Datasets may occur multiple times in this table (e.g. once for the original compilation into a different database and a second time for the recompilation into Neotoma).';
COMMENT ON COLUMN ndb.datasetsubmissions.contactid IS 'Contact identification number. Field links to the Contacts table. The Contact is the person who submitted, resubmitted, compiled, or recompiled the data. This person is not necessarily the Dataset PI; it is the person who submitted the data or compiled the data from the literature.';
COMMENT ON COLUMN ndb.datasetsubmissions.submissiontypeid IS 'Submission Type identification number. Field links to the DatasetSubmissionsType table.';
COMMENT ON COLUMN ndb.datasetsubmissions.submissiondate IS 'Date of the submission, resubmission, compilation, or recompilation.';
COMMENT ON COLUMN ndb.datasetsubmissions.notes IS 'Free form notes or comments about the submission.';
COMMENT ON COLUMN ndb.datasetsubmissiontypes.submissiontypeid IS 'An arbitrary Submission Type identification number.';
COMMENT ON COLUMN ndb.datasetsubmissiontypes.submissiontype IS 'Type of submission. The database has the following types:
Original submission from data contributor
Resubmission or revision from data contributor
Compilation into a flat file database
Compilation into a another relational database
Recompilation or revisions to a another relational database
Compilation into Neotoma from another database
Recompilation into Neotoma from another database
Compilation into Neotoma from primary source
Recompilation into or revisions to Neotoma';
COMMENT ON COLUMN ndb.datasettypes.datasettypeid IS 'An arbitrary Dataset Type identification number.';
COMMENT ON COLUMN ndb.datasettypes.datasettype IS 'The Dataset type, including the following:
geochronologic
loss-on-ignition
pollen
plant macrofossils
vertebrate fauna
mollusks';
COMMENT ON COLUMN ndb.depagents.analysisunitid IS 'Analysis Unit identification number. Field links to AnalysisUnits table.';
COMMENT ON COLUMN ndb.depagents.depagentid IS 'Deposition Agent identification number. Field links to DepAgentTypes table.';
COMMENT ON COLUMN ndb.depagenttypes.depagentid IS 'An arbitrary Depositional Agent identification number.';
COMMENT ON COLUMN ndb.depagenttypes.depagent IS 'Depositional Agent.';
COMMENT ON COLUMN ndb.depenvttypes.depenvtid IS 'An arbitrary Depositional Environment Type identification number.';
COMMENT ON COLUMN ndb.depenvttypes.depenvt IS 'Depositional Environment.';
COMMENT ON COLUMN ndb.depenvttypes.depenvthigherid IS 'The Depositional Environment Types are hierarchical. DepEnvtHigherID is the DepEnvtID of the higher ranked Depositional Environment. The following table gives some examples.';
COMMENT ON COLUMN ndb.ecolgroups.taxonid IS 'Taxon identification number. Field links to the Taxa table.';
COMMENT ON COLUMN ndb.ecolgroups.ecolsetid IS 'Ecological Set identification number. Field links to the EcolSetTypes table.';
COMMENT ON COLUMN ndb.ecolgroups.ecolgroupid IS 'A four-letter Ecological Group identification code. Field links to the EcolGroupTypes table.';
COMMENT ON COLUMN ndb.ecolgrouptypes.ecolgroupid IS 'An arbitrary Ecological Group identification number.';
COMMENT ON COLUMN ndb.ecolgrouptypes.ecolgroup IS 'Ecological Group.';
COMMENT ON COLUMN ndb.ecolsettypes.ecolsetid IS 'An arbitrary Ecological Set identification number.';
COMMENT ON COLUMN ndb.ecolsettypes.ecolsetname IS 'Ecological Set name.';
COMMENT ON COLUMN ndb.faciestypes.facies IS 'Short Facies description.';
COMMENT ON COLUMN ndb.faciestypes.faciesid IS 'An arbitrary Facies identification number.';
COMMENT ON COLUMN ndb.geochronology.sampleid IS 'Sample identification number. Field links to Samples table.';
COMMENT ON COLUMN ndb.geochronology.notes IS 'Free form notes or comments about the geochronologic measurement.';
COMMENT ON COLUMN ndb.geochronology.materialdated IS 'Material analyzed for a geochronologic measurement.';
COMMENT ON COLUMN ndb.geochronology.labnumber IS 'Lab number for the geochronologic measurement.';
COMMENT ON COLUMN ndb.geochronology.delta13c IS 'The measured or assumed δ13C value for radiocarbon dates, if provided. Radiocarbon dates are assumed to be normalized to δ13C, and if uncorrected and normalized ages are reported, the normalized age should be entered in the database.';
COMMENT ON COLUMN ndb.geochronology.infinite IS 'Is «True» for and infinite or “greater than” geochronologic measurement, otherwise is «False».';
COMMENT ON COLUMN ndb.geochronology.erroryounger IS 'The younger error limit of the age value.';
COMMENT ON COLUMN ndb.geochronology.errorolder IS 'The older error limit of the age value. For a date reported with ±1 SD or σ, the ErrorOlder and ErrorYounger values are this value.';
COMMENT ON COLUMN ndb.geochronology.age IS 'Reported age value of the geochronologic measurement.';
COMMENT ON COLUMN ndb.geochronology.agetypeid IS 'Identification number for the age units, e.g. «Radiocarbon years BP», «Calibrated radiocarbon years BP».';
COMMENT ON COLUMN ndb.geochronology.geochrontypeid IS 'Identification number for the type of Geochronologic analysis, e.g. «Carbon-14», «Thermoluminescence». Field links to the GeochronTypes table.';
COMMENT ON COLUMN ndb.geochronology.geochronid IS 'An arbitrary Geochronologic identification number.';
COMMENT ON COLUMN ndb.geochronpublications.publicationid IS 'Publication identification number. Field links to the Publications table.';
COMMENT ON COLUMN ndb.geochronpublications.geochronid IS 'Geochronologic identification number. Field links to the Geochronology table.';
COMMENT ON COLUMN ndb.geochrontypes.geochrontypeid IS 'Geochronology Type identification number.';
COMMENT ON COLUMN ndb.geochrontypes.geochrontype IS 'Type of Geochronologic measurement.';
COMMENT ON COLUMN ndb.geopoliticalunits.geopoliticalid IS 'An arbitrary GeoPolitical identification number.';
COMMENT ON COLUMN ndb.geopoliticalunits.highergeopoliticalid IS 'The GeoPoliticalUnit with higher rank, e.g. the country in which a state lies.';
COMMENT ON COLUMN ndb.geopoliticalunits.rank IS 'The rank of the unit.';
COMMENT ON COLUMN ndb.geopoliticalunits.geopoliticalunit IS 'The name of the unit, e.g. country, state, county, island, governorate, oblast.';
COMMENT ON COLUMN ndb.geopoliticalunits.geopoliticalname IS 'Name of the GeoPolitical Unit, e.g. Canada, Saskatchewan.';
COMMENT ON COLUMN ndb.keywords.keyword IS 'A keyword for identifying samples sharing a common attribute.';
COMMENT ON COLUMN ndb.keywords.keywordid IS 'An arbitrary Keyword identification number.';
COMMENT ON COLUMN ndb.lithology.lithologyid IS 'An arbitrary identification number for a lithologic unit.';
COMMENT ON COLUMN ndb.lithology.collectionunitid IS 'Collection Unit identification number. Field links to the CollectionUnits table.';
COMMENT ON COLUMN ndb.lithology.depthtop IS 'Depth of the top of the lithologic unit in cm.';
COMMENT ON COLUMN ndb.lithology.depthbottom IS 'Depth of the bottom of the lithologic unit in cm.';
COMMENT ON COLUMN ndb.lithology.description IS 'Description of the lithologic unit. These can be quite detailed, with Munsell color or Troels-Smith descriptions. Some examples:
interbedded gray silt and peat
marly fine-detritus copropel
humified sedge and Sphagnum peat
sedge peat 5YR 5/4
gray sandy loam with mammoth and other animal bones
grey-green gyttja, oxidizing to gray-brown
Ag 3, Ga 1, medium gray, firm, elastic
nig3, strf0, elas2, sicc0; Th2 T12 Tb+
Ld°4, Ga+, Dg+, Dh+';
COMMENT ON COLUMN ndb.publicationauthors.publicationid IS 'Publication identification number. Field links to the Publications table.';
COMMENT ON COLUMN ndb.publicationauthors.authororder IS 'Ordinal number for the position in which the author’s name appears in the publication’s author list.';
COMMENT ON COLUMN ndb.publicationauthors.familyname IS 'Family name of author';
COMMENT ON COLUMN ndb.publicationauthors.initials IS 'Initials of author’s given names';
COMMENT ON COLUMN ndb.publicationauthors.suffix IS 'Authors suffix (e.g. «Jr.»)';
COMMENT ON COLUMN ndb.publicationauthors.contactid IS 'Contact identification number. Field links to the Contacts table.';
COMMENT ON COLUMN ndb.publicationauthors.authorid IS 'An arbitrary Author identification number.';
COMMENT ON COLUMN ndb.publicationeditors.editorid IS 'An arbitrary Editor identification number.';
COMMENT ON COLUMN ndb.publicationeditors.publicationid IS 'Publication identification number. Field links to the Publications table.';
COMMENT ON COLUMN ndb.publicationeditors.editororder IS 'Ordinal number for the position in which the editor’s name appears in the publication’s author list.';
COMMENT ON COLUMN ndb.publicationeditors.suffix IS 'Authors suffix (e.g. «Jr.»)';
COMMENT ON COLUMN ndb.publicationeditors.initials IS 'Initials of editor’s given names';
COMMENT ON COLUMN ndb.publicationeditors.familyname IS 'Family name of editor';
COMMENT ON COLUMN ndb.publications.booktitle IS 'The title of a book or journal';
COMMENT ON COLUMN ndb.publications.publicationid IS 'An arbitrary Publication identification number.';
COMMENT ON COLUMN ndb.publications.pubtypeid IS 'Publication type. Field links to the PublicationTypes lookup table.';
COMMENT ON COLUMN ndb.publications.year IS 'Year of publication.';
COMMENT ON COLUMN ndb.publications.citation IS 'The complete citation in a standard style. For Legacy citations inherited from other databases, this field holds the citation as ingested from the other databases';
COMMENT ON COLUMN ndb.publications.articletitle IS 'The title of a journal or book chapter article.';
COMMENT ON COLUMN ndb.publications.volume IS 'The volume number of a journal or the volume number of a book in a set. A set of books is comprised of a fixed number of volumes and normally have ISBN numbers, not ISSN numbers. Book sets are often published simultaneously, but not necessarily. For instance, many floras, such as The Flora of North America north of Mexico and Flora Europaea, consist of a set number of volumes planned in advance but published over a period of years.';
COMMENT ON COLUMN ndb.publications.issue IS 'Journal issue number, normally included only if issues are independently paginated.';
COMMENT ON COLUMN ndb.publications.pages IS 'Page numbers for journal or book chapter articles, or the number of pages in theses, dissertations, and reports.';
COMMENT ON COLUMN ndb.publications.citationnumber IS 'A citation or article number used in lieu of page numbers for digital or online publications, typically used in conjunction with the DOI. For example, journals published by the American Geophysical Union since 1999 use citation numbers rather than page numbers.';
COMMENT ON COLUMN ndb.publications.doi IS 'Digital Object Identifier. A unique identifier assigned to digital publications. The DOI consists of a prefix and suffix separated by a slash. The portion before the slash stands for the publisher and is assigned by the International DOI Foundation. For example, 10.1029 is the prefix for the American Geophysical Union. The suffix is assigned by the publisher according to their protocols. For example, the DOI 10.1029/2002PA000768 is for an article submitted to Paleoceanography in 2002 and is article number 768 submitted since the system was installed. An example of CitationNumber and DOI:
Barron, J. A., L. Heusser, T. Herbert, and M. Lyle. 2003. High-resolution climatic evolution of coastal northern California during the past 16,000 years, Paleoceanography 18(1):1020. DOI:10.1029/2002PA000768.
';
COMMENT ON COLUMN ndb.publications.numvolumes IS 'Number of volumes in a set of books. Used when the entire set is referenced. An example of NumVolumes and Edition:
Wilson, D. E., and D. M. Reeder. 2005. Mammal species of the world: a taxonomic and geographic reference. Third edition. 2 volumes. The Johns Hopkins University Press, Baltimore, Maryland, USA.
';
COMMENT ON COLUMN ndb.publications.edition IS 'Edition of a publication.';
COMMENT ON COLUMN ndb.publications.volumetitle IS 'Title of a book volume in a set. Used if the individual volume is referenced. Example of Volume and VolumeTitle:
Flora of North America Editorial Committee. 2002. Flora of North America north of Mexico. Volume 26. Magnoliophyta: Liliidae: Liliales and Orchidales. Oxford University Press, New York, New York, USA.
';
COMMENT ON COLUMN ndb.publications.seriestitle IS 'Title of a book series. Book series consist of a series of books, typically published at irregular intervals on sometimes related but different topics. The number of volumes in a series is typically open ended. Book series are often assigned ISSN numbers as well as ISBN numbers. However, in contrast to most serials, book series have individual titles and authors or editors. Citation practices for book series vary; sometimes they are cited as books, other times as journals. The default citation for Neotoma includes all information. An example of SeriesTitle and SeriesVolume:
Curtis, J. H., and D. A. Hodell. 1993. An isotopic and trace element study of ostracods from Lake Miragoane, Haiti: A 10,500 year record of paleosalinity and paleotemperature changes in the Caribbean. Pages 135-152 in P. K. Swart, K. C. Lohmann, J. McKensie, and S. Savin, editors. Climate change in continental isotopic records. Geophysical Monograph 78. American Geophysical Union, Washington, D.C., USA.
';
COMMENT ON COLUMN ndb.publications.seriesvolume IS 'Volume number in a series.';
COMMENT ON COLUMN ndb.publications.publisher IS 'Publisher, including commercial publishing houses, university presses, government agencies, and non-governmental organizations, generally the owner of the copyright.';
COMMENT ON COLUMN ndb.publications.city IS 'City in which the publication was published. The first city if a list is given.';
COMMENT ON COLUMN ndb.publications.state IS 'State or province in which the publication was published. Used for the United States and Canada, not used for many countries.';
COMMENT ON COLUMN ndb.publications.country IS 'Country in which the publication was published, generally the complete country name, but «USA» for the United States.';
COMMENT ON COLUMN ndb.publications.originallanguage IS 'The original language if the publication or bibliographic citation is translated from another language or transliterated from a non-Latin character set. Field not needed for non-translated publications in languages using the Latin character set. In the following example, the ArticleTitle is translated from Russian to English and the BookTitle (journal name) is transliterated from Russian:
Tarasov, P.E. 1991. Late Holocene features of the Kokchetav Highland. Vestnik Moskovskogo Universiteta. Series 5. Geography 6:54-60 [in Russian].
';
COMMENT ON COLUMN ndb.publications.notes IS 'Free form notes or comments about the publication, which may be added parenthetically to the citation.';
COMMENT ON COLUMN ndb.publicationtypes.pubtype IS 'Publication Type. The database has the following types:
Legacy Legacy citation ingested from another database and not parsed into separate fields
Journal Article Article in a journal
Book Chapter Chapter or section in an edited book
Authored Book An authored book
Edited Book An edited book
Master's Thesis A Master's thesis
Doctoral Dissertation A doctoral dissertation or Ph.D. thesis
Authored Report An authored report
Edited Report An edited report
Other Authored An authored publication not fitting in any other category (e.g. web sites, maps)
Other Edited A edited publication not fitting into any other category
Examples of the different Publication Types are given in the following sections. Shown for each Publication Type are the fields in the Publications table that may be filled for that type, with the exception that OriginalLanguage and Notes are not shown unless used.
';
COMMENT ON COLUMN ndb.publicationtypes.pubtypeid IS 'An arbitrary Publication Type identification number.';
COMMENT ON COLUMN ndb.radiocarboncalibration.c14yrbp IS 'Age in radiocarbon years BP. The range is -100 to 45,000 by 1-year increments.';
COMMENT ON COLUMN ndb.radiocarboncalibration.calyrbp IS 'Age in calibrated radiocarbon years BP.';
COMMENT ON COLUMN ndb.relativeagepublications.publicationid IS 'Publication identification number. Field links to Publications table.';
COMMENT ON COLUMN ndb.relativeagepublications.relativeageid IS 'Relative Ages identification number. Field links to the RelativeAges table.';
COMMENT ON COLUMN ndb.relativeages.calageolder IS 'Older age of the Relative age unit in calendar years.';
COMMENT ON COLUMN ndb.relativeages.relativeageid IS 'An arbitrary Relative Age identification number.';
COMMENT ON COLUMN ndb.relativeages.c14ageolder IS 'Older age of the Relative Age unit in 14C yr B.P. Applies only to Relative Age units within the radiocarbon time scale.';
COMMENT ON COLUMN ndb.relativeages.c14ageyounger IS 'Younger age of the Relative Age unit in 14C yr B.P. Applies only to Relative Age units within the radiocarbon time scale.';
COMMENT ON COLUMN ndb.relativeages.calageyounger IS 'Younger age of the Relative Age unit in calendar years.';
COMMENT ON COLUMN ndb.relativeages.notes IS 'Free form notes or comments about Relative Age unit.';
COMMENT ON COLUMN ndb.relativeages.relativeage IS 'Relative Age (e.g. «Rancholabrean», a land mammal age; «MIS 11», marine isotope stage 11).';
COMMENT ON COLUMN ndb.relativeages.relativeagescaleid IS 'Relative Age Scale (e.g. «Geologic time scale», «Marine isotope stages»). Field links to the RelativeAgeScales lookup table.';
COMMENT ON COLUMN ndb.relativeages.relativeageunitid IS 'Relative Age Unit (e.g. «Marine isotope stage», «Land mammal age»). Field links to the RelativeAgeUnits lookup table.';
COMMENT ON COLUMN ndb.relativeagescales.relativeagescaleid IS 'An arbitrary Relative Age Scale identification number.';
COMMENT ON COLUMN ndb.relativeagescales.relativeagescale IS 'Relative Age Scale. The table stores the following Relative Age Scales:
Archaeological time scale
Geologic time scale
Geomagnetic polarity time scale
Marine isotope stages
North American land mammal ages
Quaternary event classification
';
COMMENT ON COLUMN ndb.relativeageunits.relativeageunitid IS 'An arbitrary Relative Age Unit identification number.';
COMMENT ON COLUMN ndb.relativeageunits.relativeageunit IS 'Relative Age Unit. Below are the Relative Age Units for the «Geologic time scale» with an example Relative Age.';
COMMENT ON COLUMN ndb.relativechronology.relativechronid IS 'An arbitrary Relative Chronology identification number.';
COMMENT ON COLUMN ndb.relativechronology.analysisunitid IS 'Analysis Unit identification number. Field links to the AnalysisUnits table.';
COMMENT ON COLUMN ndb.relativechronology.relativeageid IS 'Relative Age identification number. Field links to the RelativeAges lookup table.';
COMMENT ON COLUMN ndb.relativechronology.notes IS 'Free form notes or comments.';
COMMENT ON COLUMN ndb.repositoryinstitutions.acronym IS 'A unique acronym for the repository. Many repositories have well-established acronyms (e.g. AMNH = American Museum of Natural History); however, there is no official list. Various acronyms have been used for some institutions, and in some cases the same acronym has been used for different institutions. Consequently, the database acronym may differ from the acronym used in some publications. For example, «CMNH» has been used for the Carnegie Museum of Natural History, the Cleveland Museum of Natural History, and the Cincinnati Museum of Natural History. In Neotoma, two of these institutions were assigned different acronyms, ones that have been used for them in other publications: CM – Carnegie Museum of Natural History, CLM – Cleveland Museum of Natural History.';
COMMENT ON COLUMN ndb.repositoryinstitutions.notes IS 'Free form notes or comments about the repository, especially notes about name changes, closures, and specimen transfers. In some cases, it is known that the specimens were transferred, but their current disposition may be uncertain.';
COMMENT ON COLUMN ndb.repositoryinstitutions.repository IS 'The full name of the repository.';
COMMENT ON COLUMN ndb.repositoryinstitutions.repositoryid IS 'An arbitrary Repository identification number. Repositories include museums, university departments, and various governmental agencies.';
COMMENT ON COLUMN ndb.repositoryspecimens.datasetid IS 'Dataset identification number. Field links to the Datasets table.';
COMMENT ON COLUMN ndb.repositoryspecimens.repositoryid IS 'Repository identification number. Field links to the RepositoryInstitutions lookup table.';
COMMENT ON COLUMN ndb.repositoryspecimens.notes IS 'Free form notes or comments about the disposition of the specimens.';
COMMENT ON COLUMN ndb.sampleages.sampleageid IS 'An arbitrary Sample Age identification number.';
COMMENT ON COLUMN ndb.sampleages.sampleid IS 'Sample identification number. Field links to the Samples table.';
COMMENT ON COLUMN ndb.sampleages.chronologyid IS 'Chronology identification number. Field links to the Chronologies table.';
COMMENT ON COLUMN ndb.sampleages.age IS 'Age of the sample';
COMMENT ON COLUMN ndb.sampleages.ageyounger IS 'Younger error estimate of the age. The definition of this estimate is an attribute of the Chronology. Many ages do not have explicit error estimates assigned.';
COMMENT ON COLUMN ndb.sampleages.ageolder IS 'Older error estimate of the age.';
COMMENT ON COLUMN ndb.sampleanalysts.sampleid IS 'Sample identification number. Field links to the Samples table.';
COMMENT ON COLUMN ndb.sampleanalysts.analystorder IS 'Order in which Sample Analysts are listed if more than one (rare).';
COMMENT ON COLUMN ndb.sampleanalysts.contactid IS 'Contact identification number. Field links to the Contacts table.';
COMMENT ON COLUMN ndb.sampleanalysts.analystid IS 'An arbitrary Sample Analyst identification number.';
COMMENT ON COLUMN ndb.samplekeywords.keywordid IS 'Keyword identification number. Field links to the Keywords lookup table.';
COMMENT ON COLUMN ndb.samplekeywords.sampleid IS 'Sample identification number. Field links to the Samples table.';
COMMENT ON COLUMN ndb.samples.analysisdate IS 'Date of analysis.';
COMMENT ON COLUMN ndb.samples.notes IS 'Free form note or comments about the sample.';
COMMENT ON COLUMN ndb.samples.sampleid IS 'An arbitrary Sample identification number.';
COMMENT ON COLUMN ndb.samples.labnumber IS 'Laboratory number for the sample. A special case regards geochronologic samples, for which the LabNumber is the number, if any, assigned by the submitter, not the number assigned by the radiocarbon laboratory, which is in the Geochronology table.';
COMMENT ON COLUMN ndb.samples.analysisunitid IS 'Analysis Unit identification number. Field links to the AnalysisUnits table.';
COMMENT ON COLUMN ndb.samples.datasetid IS 'Dataset identification number. Field links to the Datasets table.';
COMMENT ON COLUMN ndb.samples.samplename IS 'Sample name if any.';
COMMENT ON COLUMN ndb.samples.preparationmethod IS 'Description, notes, or comments on preparation methods. For faunal samples, notes on screening methods or screen size are stored here.';
COMMENT ON COLUMN ndb.sitegeopolitical.geopoliticalid IS 'GeoPolitical identification number. Field links to the GeoPoliticalUnits lookup table.';
COMMENT ON COLUMN ndb.sitegeopolitical.sitegeopoliticalid IS 'An arbitrary Site GeoPolitical identification number.';
COMMENT ON COLUMN ndb.sitegeopolitical.siteid IS 'Site identification number. Field links to the Sites table.';
COMMENT ON COLUMN ndb.siteimages.siteimage IS 'Hyperlink to a URL for the image.';
COMMENT ON COLUMN ndb.siteimages.date IS 'Date of photograph or image.';
COMMENT ON COLUMN ndb.siteimages.siteimageid IS 'An arbitrary Site Image identification number.';
COMMENT ON COLUMN ndb.siteimages.siteid IS 'Site identification number. Field links to the Sites table.';
COMMENT ON COLUMN ndb.siteimages.contactid IS 'Contact identification number for image attribution.';
COMMENT ON COLUMN ndb.siteimages.caption IS 'Caption for the image.';
COMMENT ON COLUMN ndb.siteimages.credit IS 'Credit for the image. If null, the credit is formed from the ContactID.';
COMMENT ON COLUMN ndb.sites.siteid IS 'An arbitrary Site identification number.';

COMMENT ON COLUMN ndb.sites.sitename IS 'Name of the site. Alternative names, including archaeological site numbers, are placed in square brackets, for example:
New Paris #4 [Lloyd''s Rock Hole]
Modoc Rock Shelter [11RA501]
A search of the SiteName field for any of the alternative names or for the archaeological site number will find the site. Some archaeological sites are known only by their site number.
Modifiers to site names are placed in parentheses. Authors are added for generic sites names, especially for surface samples, that are duplicated in the database, for example:
Site 1 (Heusser 1978)
Site 1 (Delcourt et al. 1983)
Site 1 (Elliot-Fisk et al. 1982)
Site 1 (Whitehead and Jackson 1990)
For actual site names duplicated in the database, the name is followed by the 2-letter country code and state or province, for example:
Silver Lake (US:Minnesota)
Silver Lake (CA:Nova Scotia)
Silver Lake (US:Ohio)
Silver Lake (US:Pennsylvania)
';

COMMENT ON COLUMN ndb.sites.longitudeeast IS 'East bounding longitude for a site.';
COMMENT ON COLUMN ndb.sites.latitudenorth IS 'North bounding latitude for a site.';
COMMENT ON COLUMN ndb.sites.longitudewest IS 'West bounding longitude for a site.';
COMMENT ON COLUMN ndb.sites.latitudesouth IS 'South bounding latitude for a site.';
COMMENT ON COLUMN ndb.sites.altitude IS 'Altitude of a site in meters.';
COMMENT ON COLUMN ndb.sites.area IS 'Area of a site in hectares.';
COMMENT ON COLUMN ndb.sites.sitedescription IS 'Free form description of a site, including such information as physiography and vegetation around the site.';
COMMENT ON COLUMN ndb.sites.notes IS 'Free form notes or comments about the site.';
COMMENT ON COLUMN ndb.specimendates.notes IS 'Free form notes or comments about dated specimens.';
COMMENT ON COLUMN ndb.specimendates.sampleid IS 'Sample ID number. Field links to the Samples table.';
COMMENT ON COLUMN ndb.specimendates.taxonid IS 'Accepted name in Neotoma. Field links to Taxa table.';
COMMENT ON COLUMN ndb.specimendates.geochronid IS 'Geochronologic identification number. Field links to the Geochronology table.';
COMMENT ON COLUMN ndb.specimendates.specimendateid IS 'An arbitrary specimen date ID';
COMMENT ON COLUMN ndb.synonyms.synonymid IS 'An arbitrary synonym identification number.';
COMMENT ON COLUMN ndb.synonyms.synonymtypeid IS 'Type of synonym. Field links to the SynonymTypes lookup table.';
COMMENT ON COLUMN ndb.synonymtypes.synonymtypeid IS 'An arbitrary Synonym Type identification number.';
COMMENT ON COLUMN ndb.synonymtypes.synonymtype IS 'SynonymType: Synonym type. Below are some examples:
*nomenclatural, homotypic, or objective synonym – a synonym that unambiguously refers to the same taxon, particularly one with the same description or type specimen. These synonyms are particularly common above the species level. For example, Gramineae = Poaceae, Clethrionomys gapperi = Myodes gapperi. The term «objective» is used in zoology, whereas «nomenclatural» or «homotypic» is used in botany.
*taxonomic, heterotypic, or subjective synonym – a synonym typically based on a different type specimen, but which is now regarded as the same taxon as the senior synonym. For example, Iva ciliata = Iva annua. The term «subjective» is used in zoology, whereas «taxonomic» or «heterotypic» is used in botany.
*genus merged into another genus – heterotypic or subjective synonym; a genus has been merged into another genus and has not been retained at a subgeneric rank. This synonymy may apply to either the generic or specific level, for example: Petalostemon = Dalea, Petalostemon purpureus = Dalea purpurea.
*family merged into another family – heterotypic or subjective synonym; a family has been merged into another family and has not been retained at a subfamilial rank. For example, the Taxodiaceae has been merged with the Cupressaceae. This synonymy creates issues for data entry, because palynologically the Taxodiaceae sensu stricto is sometimes distinguishable from the Cupressaceae sensu stricto. If a pollen type was identified as «Cupressaceae/Taxodiaceae», then synonymizing to «Cupressaceae» results in no loss of information. However, synonymizing «Taxodiaceae» to «Cupressaceae» potentially does. In this case, consultation with the original literature or knowledge of the local biogeography may point to a logical name change that will retain the precision of the original identification. For example, in the southeastern United States, «Taxodiaceae» can be changed to «Taxodium» or «Taxodium-type» in most situations. If «Cupressaceae» was also identified, then it should be changed to «Cupressaceae undiff.» or possibly «Juniperus-type» if other Cupressaceae such as Chamaecyperus are unlikely.
*rank change: species reduced to subspecific rank – heterotypic or subjective synonym; a species has been reduced to a subspecies or variety of another species. These synonyms may be treated in two different ways, depending on the situation or protocols of the contributing data cooperative: (1) The taxon is reduced to the subspecific rank (e.g. Alnus fruticosa = Alnus viridis subsp. fruticosa, Canis familiaris = Canis lupus familiaris), either because the fossils can be assigned to the subspecies based on morphology, as is likely the case with the domestic dog, Canis lupus familiaris, or because the subspecies can be assigned confidently based on biogeography. (2) The taxon is changed to the new taxon and the subspecific rank is dropped because the fossil is not distinguishable at the subspecific level. For example, Alnus rugosa = Alnus incana subsp. rugosa, but may simply be changed to Alnus incana because the pollen of A. incana subsp. rugosa and A. incana subsp. incana are indistinguishable morphologically.
*rank change: genus reduced to subgenus – heterotypic or subjective synonym; a genus has been reduced to subgeneric rank in another family. At the generic level, this synonymy is clear from the naming conventions, e.g. Mictomys = Synaptomys (Mictomys); however, at the species level it is not, e.g. Mictomys borealis = Synaptomys borealis.
*rank change: family reduced to subfamily – heterotypic or subjective synonym; a family has been reduced to subfamily rank in another family. By botanical convention the family name is retained, e.g. Pyrolaceae = Ericaceae subf. Monotropoideae; whereas by zoological convention it is not, e.g. Desmodontidae = Desmodontinae.
*rank change: subspecific rank elevated to species – heterotypic or subjective synonym; a subspecies or variety has been raised to the species rank, e.g. Ephedra fragilis subsp. campylopoda = Ephedra foeminea.
*rank change: subgeneric rank elevated to genus – heterotypic or subjective synonym; a subgenus or other subgeneric rank has been raised to the generic rank. At the subgeneric level, this synonymy is clear from the naming conventions, e.g. Potamogeton subg. Coleogeton = Stuckenia; however, at the species level it is not, e.g. Potamogeton pectinatus = Stuckenia pectinata.
*rank change: subfamily elevated to family – heterotypic or subjective synonym; a subfamily has been raised to the family rank, e.g. Liliaceae subf. Amaryllidoideae = Amaryllidaceae, Pampatheriinae = Pampatheriidae.
*rank elevated because of taxonomic uncertainty – because the precise taxonomic identification is uncertain, the rank has been raised to a level that includes the universe of possible taxa. A common cause of such uncertainty is taxonomic splitting subsequent to the original identification, in which case the originally identified taxon is now a much smaller group. For example, the genus Psoralea has been divided into several genera; the genus Psoralea still exists, but now includes a much smaller number of species. Consequently, in the database Psoralea has been synonymized with Fabaceae tribe Psoraleeae, which includes the former Psoralea sensu lato. A zoological example is Mustela sp. The genus Mustela formerly included the minks, which have now been separated into the genus Neovison. Consequently, Mustela sp. = Mustela/Neovison sp.
*globally monospecific genus – although identified at the genus level, specimens assigned to this genus can be further assigned to the species level because the genus is monospecific.
*globally monogeneric family – although identified at the family level, specimens assigned to this family can be further assigned to the genus level because the family is monogeneric.
';
COMMENT ON COLUMN ndb.taxa.notes IS 'Free form notes or comments about the Taxon.';
COMMENT ON COLUMN ndb.taxa.publicationid IS 'Publication identification number. Field links to the Publications table.';
COMMENT ON COLUMN ndb.taxa.taxagroupid IS 'The TaxaGroupID facilitates rapid extraction of taxa groups that are typically grouped together for analysis. Some of these groups contain taxa in different classes or phyla. For example, vascular plants include the Spermatophyta and Pteridophyta; the herps include Reptilia and Amphibia; the testate amoebae include taxa from different phyla. Field links to the TaxaGroupTypes table.';
COMMENT ON COLUMN ndb.taxa.extinct IS 'True if the taxon is extinct, False if extant.';
COMMENT ON COLUMN ndb.taxa.highertaxonid IS 'The TaxonID of the next higher taxonomic rank, for example, the HigherTaxonID for «Bison» is the TaxonID for «Bovidae». For «cf.''s» and «-types», the next higher rank may be much higher owing to the uncertainty of the identification; the HigherTaxonID for «cf. Bison bison» is the TaxonId for «Mammalia». The HigherTaxonID implements the taxonomic hierarchy in Neotoma.';
COMMENT ON COLUMN ndb.taxa.author IS 'Author(s) of the name. Neither the pollen database nor FAUNMAP stored author names, so these do not currently exist in Neotoma for plant and mammal names. These databases follow standard taxonomic references (e.g. Flora of North America, Flora Europaea, Wilson and Reeder''s Mammal Species of the World), which, of course, do cite the original authors. However, for beetles, the standard practice is to cite original author names; therefore, this field was added to Neotoma.';
COMMENT ON COLUMN ndb.taxa.taxonname IS 'Name of the taxon. Most TaxonNames are biological taxa; however, some are biometric measures and some are physical parameters. In addition, some biological taxa may have parenthetic non-Latin modifers, e.g. «Betula (>20 µm)» for Betula pollen grains >20 µm in diameter. In general, the names used in Neotoma are those used by the original investigator. In particular, identifications are not changed, although Dataset notes can be added to the database regarding particular identifications. However, some corrections and synonymizations are made. These include:
*Misspellings are corrected.
*Nomenclatural, homotypic, or objective synonyms may be applied. Because these synonyms unambiguously refer to the same taxon, no change in identification is implied. For example, the old family name for the grasses «Gramineae» is changed to «Poaceae».
*Taxonomic, heterotypic, or subjective synonyms may be applied if the change does not effectively assign the specimen to a different taxon. Although two names may have been based on different type specimens, if further research has shown that these are in fact the same taxon, the name is changed to the accepted name. These synonymizations should not cause confusion. However, uncritical synonymization, although taxonomically correct, can result in loss of information, and should be avoided. For example, although a number of recent studies have shown that the Taxodiaceae should be merged with the Cupressaceae, simply synonymizing Taxodiaceae with Cupressaceae may expand the universe of taxa beyond that implied by the original investigator. For example, a palynologist in the southeastern United States may have used «Taxodiaceae» to imply «Taxodium», which is the only genus of the family that has occurred in the region since the Pliocene, but used the the family name because, palynologically, Taxodiuim cannot be differentiated from other Taxodiaceae. However, well preserved Taxodium pollen grains can be differentiated from the other Cupressaceous genera in the region, Juniperus and Chamaecyperus. Thus, the appropriate synonymization for «Taxodiaceae» in this region would be «Taxodium» or «Taxodium-type», which would retain the original taxonomic precision. On the other hand, the old «TCT» shorthand for «Taxodiaceae/Cupressaceae/Taxaceae» now becomes «Cupressaceae/Taxaceae» with no loss of information.
*For alternative taxonomic designations, the order may be changed. For example, «Ostrya/Carpinus» would be substituted for «Carpinus/Ostrya».
';
COMMENT ON COLUMN ndb.taxa.taxoncode IS 'A code for the Taxon. These codes are useful for other software or output for which the complete name is too long. Because of the very large number of taxa, codes can be duplicated for different Taxa Groups. In general, these various Taxa Groups are analyzed separately, and no duplication will occur within a dataset. However, if Taxa Groups are combined, unique codes can be generated by prefixing with the TaxaGroupID, For example:
*VPL:Cle Clethra
*MAM:Cle Clethrionomys
A set of conventions has been established for codes. In some cases conventions differ depending on whether the organism is covered by rules of botanical nomenclature (BN) or zoological nomenclature (ZN).
*Genus – Three-letter code, first letter capitalized, generally the first three unless already used.
**Ace Acer
**Cle Clethrionomys
*Subgenus – The genus code plus a two-letter subgenus code, first letter capitalized, separated by a period.
**Pin.Pi Pinus subg. Pinus
**Syn.Mi Synaptomys (Mictomys)
*Species – The genus code plus a two-letter, lower-case species code, separated by a period.
**Ace.sa Acer saccharum
**Ace.sc Acer saccharinum
**Cle.ga Clethrionomys gapperi
*Subspecies or variety – The species code a two-letter, lower-case subspecies code, separated by a period.
**Aln.vi.si Alnus viridis subsp. Sinuata
**Bis.bi.an Bison bison antiquus
*Family – Six-letter code, first letter capitalized, consisting of three letters followed by «eae» (BN) or «dae» (ZN).
**Roseae Rosaceae
**Bovdae Bovidae
*Subfamily or tribe – (BN) Family code plus two-letter subfamily code, first letter capitalized, separated by a priod. (ZN) Six-letter code, first letter capitalized, consisting of three letters followed by «nae».
**Asteae.As Asteraceae subf. Asteroideae
**Asteae.Cy Asteraceae tribe Cynarea
**Arvnae Arvicolinae
*Order – (BN) Six-letter code, first letter capitalized, consisting of three letters followed by «les». (ZN) Six-letter code, first letter capitalized, consisting of three letters, followed by the last three letters of the order name, unless the order name is ≤6 letters long, in which case the code = the order name. Zoological orders do not have a common ending.
**Ercles Ericales
**Artyla Artiodactyla
**Rodtia Rodentia
*Taxonomic levels higher than order – Six-letter code, first letter capitalized, consisting of three letters, followed by the last three letters of the order name, unless the order name is ≤6 letters long, in which case the code = the order name..
**Magida Magnoliopsida
**Magyta Magnoliophyta
**Mamlia Mammalia
*Types – The conventional taxon code followed by «-type».
**Aln.in-t Alnus incana-type
**Amb-t Ambrosia-type
*cf. – «cf. » is placed in the proper position.
**Odc.cf.he Odocoileus cf. O. hemionus
**cf.Odc.he cf. Odocoileus hemionus
**cf.Odc cf. Odocoileus
*aff. – «aff. » is abbreviated to «af. ».
**af.Can.di aff. Canis dirus
*? – «?» is placed in the proper position.
**?Pro.lo ?Procyon lotor
*Alternative names – A slash is placed between the conventional abbreviations for the alternative taxa.
**Ost/Cpn Ostrya/Carpinus
**Mstdae/Mepdae Mustelidae/Mephitidae
*Undifferentiated taxa – (BN) «.ud» is added to the code. (ZN) «.sp » is added to the code.
**Aln.ud Alnus undiff.
**Roseae.ud Rosaceae undiff.
**Mms.sp Mammuthus sp.
**Taydae.sp Tayassuidae sp
*Parenthetic modifiers – The conventional taxon code with an appropriate abbreviation for the modifier separated by periods. Multiple modifiers also separated by periods. *Abbreviations for pollen morphological modifiers follow Iversen and Troels-Smith (1950).
**Raneae.C3 Ranunculaceae (tricolpate)
**Raneae.Cperi Ranunculaceae (pericolpate)
**Pineae.ves.ud Pinaceae (vesiculate) undiff.
**Myteae.Csyn.psi Myrtaceae (syncolpate, psilate)
**Bet.>20µ Betula (>20 µm)
*Non-biological taxa – Use appropriate abbreviations.
**bulk.dens Bulk density
**LOI Loss-on-ignition
**Bet.pol.diam Betula mean pollen-grain diameter
';
COMMENT ON COLUMN ndb.taxa.taxonid IS 'An arbitrary Taxon identification number.';
COMMENT ON COLUMN ndb.taxagrouptypes.taxagroupid IS 'A three-letter Taxa Group code.';
COMMENT ON COLUMN ndb.taxagrouptypes.taxagroup IS 'The taxa group. Below are some examples:
TaxaGroupID
TaxaGroup
AVE
Birds
BIM
Biometric variables
BRY
Bryophytes
BTL
Beetles
FSH
Fish
HRP
Reptiles and amphibians
LAB
Laboratory analyses
MAM
Mammals
MOL
Molluscs
PHY
Physical variables
TES
Testate amoebae
VPL
Vascular plants';
COMMENT ON COLUMN ndb.tephras.notes IS 'Free form notes or comments about the tephra.';
COMMENT ON COLUMN ndb.tephras.tephraid IS 'An arbitrary Tephra identification number.';
COMMENT ON COLUMN ndb.variablecontexts.variablecontext IS 'Depositional context. Examples are:
*anachronic – specimen older than the primary deposit, e.g. a Paleozoic spore in a Holocene deposit; may be redeposited from the catchment or may be derived from long distance, e.g. Tertiary pollen grains in Quaternary sediments with no local Tertiary source. A Pleistocene specimen in a Holocene archaeological deposit, possibly resulting from aboriginal fossil collecting, would also be anachronic.
*intrusive – specimen generally younger younger than the primary deposit, e.g. a domestic pig in an otherwise Pleistocene deposit in North America.
*redeposited – specimen older than the primary deposit and assumed to have been redeposited from a local source by natural causes.
*articulated – articulated skeleton
*clump – clump, esp. of pollen grains
';
COMMENT ON COLUMN ndb.variablecontexts.variablecontextid IS 'An arbitrary Variable Context identification number.';
COMMENT ON COLUMN ndb.variableelements.variableelementid IS 'An arbitrary Variable Element identification number.';
COMMENT ON COLUMN ndb.variableelements.variableelement IS 'The element, part, or organ of the taxon identified. For plants, these include pollen, spores, and various macrofossil organs, such as «seed», «twig», «cone», and «cone bract». Thus, Betula pollen and Betula seeds are two different Variables. For mammals, Elements include the bone or tooth identified, e.g. «tibia». «tibia, distal, left», «M2, lower, left». Some more unusual elements are Neotoma fecal pellets and Erethizon dorsata quills. If no element is indicated for mammalian fauna, then the genric element «bone/tooth» is assigned. Elements were not assigned in FAUNMAP, so all Variables ingested from FAUNMAP were assigned the «bone/tooth» element. Physical Variables may also have elements. For example, the Loss-on-ignition Variables have «Loss-on-ignition» as a Taxon, and temperature of analysis as an element, e.g. «500°C», «900°C». Charcoal Variables have the size fragments as elements, e.g. «75-100 µm», «100-125 µm».';
COMMENT ON COLUMN ndb.variables.variableelementid IS 'Variable Element identification number. Field links to the VariableElements lookup table.';
COMMENT ON COLUMN ndb.variables.taxonid IS 'Taxon identification number. Field links to the Taxa table.';
COMMENT ON COLUMN ndb.variables.variableid IS 'An arbitrary Variable identification number.';
COMMENT ON COLUMN ndb.variables.variablecontextid IS 'Variable Context identification number. Field links to the VariableContexts lookup table.';
COMMENT ON COLUMN ndb.variables.variableunitsid IS 'Variable Units identification number. Field links to the VariableUnits lookup table.';
COMMENT ON COLUMN ndb.variableunits.variableunitsid IS 'An arbitrary Variable Units identification number.';
COMMENT ON COLUMN ndb.variableunits.variableunits IS 'The units of measurement. For fauna, these are «present/absent», «NISP» (Number of Individual Specimens), and «MNI» (Minimum Number of Individuals). For pollen, these are «NISP» (pollen counts) and «percent». Units for plant macrofossils include «present/absent» and «NISP», as well as a number of quantitative concentration measurements and semi-quantitative abundance measurements such as «1-5 scale». Examples of charcoal measurement units are «fragments/ml» and «µm^2/ml».';