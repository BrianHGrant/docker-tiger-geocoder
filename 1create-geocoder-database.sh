#! /bin/bash

echo "Creating a geocoder database"
echo "If you've already created the geocoder database you can ignore the error messages."
createdb -O postgres -T template_postgis geocoder
