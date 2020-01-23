CREATE OR REPLACE FUNCTION ndb.contacts_delete_fn()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		update ndb.chronologies
		set contactid = null
		where contactid = OLD.contactid; 

		delete from ndb.collectors
		where contactid = OLD.contactid;

		update ndb.constituentdatabases
		set contactid = null
		where contactid = OLD.contactid ;

		delete from ndb.dataprocessors
		where contactid = OLD.contactid;

		delete from ndb.datasetpis
		where contactid = OLD.contactid;

		update ndb.datasetsubmissions
		set contactid = null
		where contactid = OLD.contactid; 

		delete from ndb.datasettaxonnotes
		where contactid = OLD.contactid;

		delete from ndb.datataxonnotes
		where contactid = OLD.contactid;

		update ndb.isometadata
		set analystid = null
		where analystid = OLD.contactid; 

		delete from ndb.publicationauthors
		where contactid = OLD.contactid;

		delete from ndb.sampleanalysts
		where contactid = OLD.contactid;

		update ndb.siteimages
		set contactid = null
		where contactid = OLD.contactid; 

		delete from ti.stewards
		where contactid = OLD.contactid;

		delete from ti.stewardupdates
		where contactid = OLD.contactid;

		update ndb.synonymy
		set contactid = null
		where contactid = OLD.contactid;  

		update ndb.taxa
		set validatorid = null
		where validatorid = OLD.contactid; 

		RETURN NULL;
	END;
  $function$
