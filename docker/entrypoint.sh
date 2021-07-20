#!/bin/bash
#
# Docker Entrypoint for osmdata.xyz per-feature GeoPackage files
# from Planet PBF.
#
# Author: Just van den Broecke
#

mkdir -p output
cd output

/bin/rm *.pbf > /dev/null 2>&1

# Getting the newest planet file
echo "$(date) : Downloading PLANET_FILE=${PLANET_FILE}..."
axel --insecure -n 5 -a -v ${PLANET_FILE} -o planet-latest.osm.pbf

# Filter out per-feature PBFs
echo "$(date) : Download done filtering per-feature PBF..."
bash ../01_osmfilter.txt

# Convert PBFs to GeoPackage files
cp -p ../*.ini .
echo "$(date) : Running ogr2ogr to convert PBFs to GeoPackages..."
bash ../02_queries.txt

# Cleanup
/bin/rm *.ini *.pbf > /dev/null 2>&1

ls -lh
echo "$(date) : All done!"
