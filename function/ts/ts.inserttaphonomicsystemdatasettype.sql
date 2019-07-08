CREATE OR REPLACE FUNCTION ts.inserttaphonomicsystemdatasettype(_datasettypeid int,
	_taphonomicsystemid int) RETURNS void
AS $$
INSERT INTO ndb.taphonomicsystemsdatasettypes
	(datasettypeid, taphonomicsystemid)
VALUES (_datasettypeid, _taphonomicsystemid)
$$ LANGUAGE SQL;