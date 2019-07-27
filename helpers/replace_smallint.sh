#~/bin/bash
echo Replacing all instances of smallint in database functions.
echo Make sure this is running from the "helpers" directory.
sed -ri -e "s/smallint/boolean/g" $(grep -Elr --binary-files=without-match "smallint" "./../function/ti")
sed -ri -e "s/smallint/boolean/g" $(grep -Elr --binary-files=without-match "smallint" "./../function/ti")
