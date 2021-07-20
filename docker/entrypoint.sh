#!/bin/bash
#
# Docker Entrypoint for osmdata.xyz per-feature GeoPackage files
# from Planet PBF.
#
# Author: Just van den Broecke - https://github.com/justb4
#

# log
function log_info() {
  local msg=$1
  echo "INFO: $(date +"%y-%m-%d %H:%M:%S") - ${msg}"
}

# error and exit
function error_exit() {
  local msg=$1
  echo "ERROR: $(date +"%y-%m-%d %H:%M:%S") - ${msg} - exit..."
  exit -1
}

# error and exit
function cleanup() {
  log_info "Ocean cleanup"
  /bin/rm *.ini *.pbf > /dev/null 2>&1
}

# Init
PLANET_PBF="planet-latest.osm.pbf"
mkdir -p output
cd output
cleanup

# Getting the newest planet file
if [[ -z ${PLANET_FILE} ]]
then
	error_exit "PLANET_FILE URL variable is empty, check your settings."
fi

log_info "Downloading PLANET_FILE=${PLANET_FILE}..."
axel --insecure -n 5 -a -v ${PLANET_FILE} -o ${PLANET_PBF}

# Check download outcome and stop on error
if [ $? -ne 0 ] || [ ! -f "${PLANET_PBF}" ]
then
	error_exit "Download failed for PLANET_FILE=${PLANET_FILE}"
fi

# Filter out per-feature PBFs
log_info "Download OSM Planet ok, filtering per-feature PBF..."
bash ../01_osmfilter.txt

# Stop on error
if [ $? -ne 0 ]
then
	error_exit "01_osmfilter failed!"
fi

# Convert PBFs to GeoPackage files
cp -p ../*.ini .
log_info "Running ogr2ogr to convert PBFs to GeoPackages..."
bash ../02_queries.txt

# Stop on error
if [ $? -ne 0 ]
then
	error_exit "02_queries failed!"
fi

# Cleanup
cleanup

ls -lh
log_info "All done!"
