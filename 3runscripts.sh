#! /bin/sh

psql -U postgres -d geocoder -f /sql/load-tiger-scripts.psql
