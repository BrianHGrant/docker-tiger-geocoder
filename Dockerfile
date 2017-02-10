FROM postgres:9.6
MAINTAINER Brian H. Grant <brian@bhgconcepts.com>

ENV POSTGIS_MAJOR 2.3
ENV POSTGIS_VERSION 2.3.2+dfsg-1~exp1.pgdg80+1

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
RUN mkdir -p /sql
COPY ./0initdb-postgis.sh /docker-entrypoint-initdb.d/0postgis.sh
COPY ./1create-geocoder-database.sh /docker-entrypoint-initdb.d/1create-geocoder-database.sh
COPY ./2make-geocoder-download-scripts.sh /docker-entrypoint-initdb.d/2make-geocoder-download-scripts.sh
COPY ./3runscripts.sh /docker-entrypoint-initdb.d/3runscripts.sh
COPY ./make-tiger-scripts1.psql /sql/make-tiger-scripts1.psql
COPY ./make-tiger-scripts2.psql /sql/make-tiger-scripts2.psql
COPY ./load-tiger-scripts.psql /sql/load-tiger-scripts.psql

RUN rm -fr /gisdata/temp
RUN mkdir -p /gisdata/temp
RUN chown -R ${USER}:${USER} /gisdata
RUN chown -R postgres:postgres /gisdata
