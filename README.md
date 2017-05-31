# Neotoma_SQL

This is a repository to store the functions used within the Neotoma Database for data access and updates.  The Neotoma is a Postgres-based system, migrated from a SQL Server database.  As such, at the current time, this repository largely reflects the state of transition between the two systems.

## Contributors

All individuals are welcome to contribute to this repository.  Contributions are subject to the [Code of Conduct](https://github.com/neotomadb/Neotoma_SQL/blob/master/code_of_conduct.md) for this repository.

* Steve Crawford - [Penn State](http://www.ems.psu.edu/node/147)
* Simon Goring   - [University of Wisconsin](http://goring.org)
* Mike Stryker   - [Penn State](http://www.ems.psu.edu/node/2892)

## Description

The repository is divided into two main folders, `legacy` and `function`.  The `legacy` folder is intended to act as the store for the now deprecated SQL Server Stored Procedures.  The `function` folder represents the newer Postgres functions.  This folder is then divided into folders for each individual database schema.

This structure is not necessary, but has been implemented to help manage the workflow of rewriting the large number of functions associated with the original database.

### Standards For New Functions

Functions are expected to follow (as much as possible) [Simon Holywell's SQL Style Guide](http://www.sqlstyle.guide/) and the [Postgres Coding Convention](https://www.postgresql.org/docs/current/static/source.html).

* Functions should be generated in standalone files
* Functions should be named using verbs
* Functions should refrain from using vendor specific functions
* Use C style commenting: /* . . . */

## Issues and Bugs

Please feel free to raise issues using the issue tracker on this repository.


