# Docker for osmdata.xyz

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
 
May change PBF URL in the [docker-compose file](docker-compose.yml):

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