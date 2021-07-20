FROM ubuntu:latest

LABEL maintainer="Just van den Broecke <justb4@gmail.com>"

# ARGS
ARG TIMEZONE="Europe/Berlin"
ARG PLANET_FILE="https://ftp.fau.de/osm-planet/pbf/planet-latest.osm.pbf"

# ENV settings
ENV TZ=${TIMEZONE} \
   DEBIAN_FRONTEND="noninteractive" \
   DEB_PACKAGES="axel wput p7zip-full gdal-bin osmium-tool" \
   PLANET_FILE=${PLANET_FILE}

RUN \
	apt-get update \
	&& apt-get --no-install-recommends install -y ${DEB_PACKAGES} \
	&& cp /usr/share/zoneinfo/${TZ} /etc/localtime \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# Add scripts and make it working dir
ADD workflow_scripts /workflow_scripts

COPY docker/entrypoint.sh /workflow_scripts/

WORKDIR /workflow_scripts

ENTRYPOINT ["/workflow_scripts/entrypoint.sh"]
