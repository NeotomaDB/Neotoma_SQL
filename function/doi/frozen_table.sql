CREATE TABLE IF NOT EXISTS doi.frozen(datasetid integer CONSTRAINT goodds CHECK (doi.inds(datasetid)),
                    record jsonb NOT null,
                    recdatecreated TIMESTAMP DEFAULT NOW(),
                    recmodified TIMESTAMP DEFAULT NOW());
GRANT SELECT, INSERT ON doi.frozen TO doiwriter;
