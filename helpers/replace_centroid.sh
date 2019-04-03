#~/bin/bash
echo Replacing all instances of centroids in database functions.
echo Make sure this is running from the "helpers" directory.
sed -ri -e "s/ST_CENTROID/ST_Centroid/g" $(grep -Elr --binary-files=without-match "ST_CENTROID" "./../function/ti")
sed -ri -e "s/ST_DISTANCE/ST_Distance/g" $(grep -Elr --binary-files=without-match "ST_DISTANCE" "./../function/ti")
