CREATE TABLE doi.frozen(datasetid integer CONSTRAINT goodds CHECK (doi.inds(datasetid)),
                    record jsonb NOT null,
                    doi text NOT null CONSTRAINT validdoi CHECK (doi ~ '/^10.\d{4,9}/[-._;()/:A-Z0-9]+$/i'),
                    recdatecreated TIMESTAMP DEFAULT NOW(),
                    recmodified int);
