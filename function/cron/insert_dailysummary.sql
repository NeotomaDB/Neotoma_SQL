SELECT cron.schedule('00 00 * * *', 'INSERT INTO ap.summaries SELECT * FROM ap.dailysummaries(''2'') ON CONFLICT (dbdate) DO UPDATE
  SET sites = EXCLUDED.sites,
      datasets = EXCLUDED.datasets,
      publications = EXCLUDED.publications,
      observations = EXCLUDED.observations;');