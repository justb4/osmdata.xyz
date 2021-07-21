# Docker for osmdata.xyz

initial author: Just van den Broecke - https://github.com/justb4

The Docker image can be used to execute the scripts under `workflow_scripts`
rendering the per-feature GeoPackage file under a local directory mounted into
the Docker Containers. You can test with a small OSM (PBF) file first.
Beware that for a full Planet file, additional memory settings may be required.

You may build/run the Docker Image directly or via `docker-compose`. The latter is
recommended.

# Using Docker Run

```
cd ..
docker build -t osmdata_xyz:latest .
mkdir -p output

# Leave out for entire Planet file
export PLANET_FILE="https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf"

docker run --rm -e PLANET_FILE=${PLANET_FILE} -v $(pwd)/output:/workflow_scripts/output:rw -it osmdata_xyz:latest
```

All GPKG files should be in `./output/`.

# Using docker-compose (recommended)
 
May change PBF URL in the [docker-compose file](docker-compose.yml).
The example here uses the "Bremen" OSM PBF dataset.

```
   environment:
      - PLANET_FILE=https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf
```

If left out or empty the entire Planet file is downloaded/processed.
 
Build and run, with all output in ./output in this dir:

```

mkdir -p output
docker-compose build
docker-compose run osm2gpkg

```