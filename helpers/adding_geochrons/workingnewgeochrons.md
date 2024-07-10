# Adding new dates to existing sites

Coming from a FAUNMAP project. We have a set of new geochronological records that we need to add to exsiting data records.

## Data Description

### Spreadsheet Columns

| Table column | used |
| ------ | ---- |
| siteid | not used (dataset is unit) |
| sitename | not used (dataset is unit) |
| reference | `ts.insertdatasetpublication()` |
| collunitid | not used (dataset is unit) |
| handle | not used (dataset is unit) |
| discovery | ?? |
| analysisunitid | `ts.insertsamples()` |
| analysisunitname | compare and add if not in. |
| labnumber | `ts.insertgeochron()` |
| uncal14Cage | `ts.insertgeochron()` |
| uncal14Cerr | `ts.insertgeochron()` |
| infinite | `ts.insertgeochron()` |
| materialdated | `ts.insertgeochron()` |
| taxondated | `ts.insertsample()` |
| elementdated | `ts.insertspecimendates()` |
| depth | not used (analysis unit should have this assigned already) |
| notes | `ts.insertgeochron()` |
| method | `ts.insertreadiocarbon()` |
| d13C | `ts.insertreadiocarbon()` |
| %C | `ts.insertreadiocarbon()` |
| %N | `ts.insertreadiocarbon()` |
| C:N | `ts.insertreadiocarbon()` |

### Existing Data

We want to link these collectionunits to geochronology datasets so we can add the details to their geochrons. It looks like 255 of the collectionunits do not currently have geochronology datasets. In these cases we need to apply `ts.insertdataset()`.

We have the ability to assign new taxa to the samples through the `ndb.samples.taxonid` column.

## Functions Used

### ts.insertsamples()

We need to insert the sample for the geochron element.

| ts.insertsample | csv table |
| ------ | ---- |
| _analysisunitid | analysisunitid |
| _datasetid | from prepared query |
| _samplename | null |
| _sampledate | null |
| _analysisdate | null |
| _taxonid  | taxondated |
| _labnumber  | |
| _prepmethod  | method |
| _notes  |  |

### ts.insertgeochron()

We're going to use `ts.insertgeochron`, which takes the following parameters:

| ts.insertgeochron parameter | csv table |
| ------- | ------ |
| _sampleid | from `ts.insertsample()` |
| _geochrontypeid | *2 (constant)* |
| _agetypeid | *4 (constant)* |
| _age | uncal14Cage |
| _errorolder | uncal14Cerr + uncal14Cage |
| _erroryounger | uncal14Cerr + uncal14Cage |
| _infinite | infinite |
| _delta13c | d13C |
| _labnumber | labnumber |
| _materialdated | materialdated |
| _notes | notes |

