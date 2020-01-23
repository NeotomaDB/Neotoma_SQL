# Neotoma_SQL

This is a repository to store the functions used within the Neotoma Database for data access and updates.  The Neotoma is a Postgres-based system, migrated from a SQL Server database.  As such, at the current time, this repository largely reflects the state of transition between the two systems.

## Contributors

All individuals are welcome to contribute to this repository.  Contributions are subject to the [Code of Conduct](https://github.com/neotomadb/Neotoma_SQL/blob/master/code_of_conduct.md) for this repository.

* Steve Crawford - [Penn State](http://www.ems.psu.edu/node/147)
* Simon Goring   - [University of Wisconsin](http://goring.org)
* Mike Stryker   - [Penn State](http://www.ems.psu.edu/node/2892)
* Anna George    - University of Wisconsin
* Jack Williams  - University of Wisconsin

## Description

The repository is divided into two main folders, `legacy` and `function`:

* `legacy` folder is intended to act as the store for the now deprecated SQL Server Stored Procedures.
* `function` folder represents the newer Postgres functions.  This folder is then divided into folders for each individual database schema.

This structure is not necessary, but has been implemented to help manage the workflow of rewriting the large number of functions associated with the original database.

### Neotoma Postgres Databases

Neotoma maintains five separate databases within the PSU Postgres server.  Of these five, three are significant, each has a specific function:

* `neotomadev`: Main development database.  Currently this is the parent database and should be the most accurate/up to date version of the database.  This is the database that the API points to.
* `neotoma`: A database for experimentation.  This version of the database may be out of sync with the SQL Server and `neotomadev` as it is used to build and prototype new tools.
* `neotomatilia`: A database for testing and managing Tilia services.

### Associated Files

There are several files that have been used in the transition and are included here for posterity.

* [`rewrite_funs.R`](https://github.com/NeotomaDB/Neotoma_SQL/blob/master/rewrite_funs.R) is a short R script that was intended to rewrite any function in the legacy `TI` schema that used the format `SELECT * FROM table`.
* [`tilia_check.py`](https://github.com/NeotomaDB/Neotoma_SQL/blob/master/tilia_check.py) was intended to check against existing functions in the `ti` namespace to help ensure alignment with the Tilia software package designed to work with the Neotoma Paleoecology Database.

### Maintaining the Repository

This repository is currently intended to be **read-only** with respect to the databases (`neotoma`, `neotomadev` and `neotomatilia`).  The stored postgres functions can be updated using the Python3 script `connect_remote.py` by calling:

```python
python3 connect_remote.py
```

This program checks the `pg_catalog` for the stated database and pulls each function within a defined set of namespaces, and returns each function as its own `sql` file to a folder in the `function` directory.

#### Using `connect_remote.py`

`connect_remote.py` has built in help that can be accessed using:

```python3
connect_remote.py -h
```

```
usage: connect_remote.py [-h] [-dev] [-push] [-g [PULLGIT]] [-tilia]

Check Neotoma SQL functions against functions in the online database servers
(`neotoma` and `neotomadev`).

optional arguments:
  -h, --help    show this help message and exit
  -dev          Use the `dev` database? (`False` without the flag)
  -push         Assume that SQL functions in the repository are newer, push to
                the db server.
  -g [PULLGIT]  Pull from the remote git server before running?.
  -tilia        Use the `dev` database? (`False` without the flag)
```

A user should make sure that local changes are committed and pushed before using the script, but in the case that changes were made directly to the GitHub repository online, they may use the `-g` flag.

Expected use should `-push` to each of the three databases.

### Standards For New Functions

Functions are expected to follow (as much as possible) [Simon Holywell's SQL Style Guide](http://www.sqlstyle.guide/) and the [Postgres Coding Convention](https://www.postgresql.org/docs/current/static/source.html).

* Functions should be generated in standalone files
* Functions should be named using verbs
* Functions should refrain from using vendor specific functions
* Use C style commenting: /* . . . */

### Existing Database Schema

For more insight into the structure of the Neotoma Database (specifically the `ndb` schema, which contains the core data of the database), visit the [Neotoma Database Documentation](http://neotomadb.github.io/dbschema/index.html).  Documentation was generated using [the SchemaSpy software](http://schemaspy.org/).

## Issues and Bugs

Please feel free to raise issues using the issue tracker on this repository.
