WITH newname AS (
    INSERT INTO ndb.contacts (contactname, familyname, givennames, email, address)
     VALUES ('Jennifer Cooling', 
             'Cooling',
             'Jennifer',
             'j.cooling@uq.edu.au',
             'University of Queensland') RETURNING contactid
)
SELECT ts.insertsteward(_contactid := (SELECT contactid FROM newname),
        _username := 'jcooling',
        _password := 'Orallo!',
        _taxonomyexpert := false,
        _databaseid := 4);
