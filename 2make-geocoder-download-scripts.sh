#! /bin/bash

# execute script builder
psql -d geocoder -f /sql/make-tiger-scripts1.psql
chmod +x /gisdata/*.sh
/gisdata/nation.sh
psql -d geocoder -f /sql/make-tiger-scripts2.psql
chmod +x /gisdata/*.sh
/gisdata/oregon.sh

# edit the scripts
for i in '/gisdata/nation.sh' '/gisdata/oregon.sh'
do
  sed -i 's;export PGBIN=.*$;export PGBIN=/usr/bin;' ${i}
  sed -i 's;export PGPASSWORD;#export PGPASSWORD;' ${i}
  sed -i 's;export PGHOST;#export PGHOST;' ${i}
done
