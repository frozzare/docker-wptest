#!/bin/bash

cat versions.sh <(cat install-tmpl.sh) > install.sh

chmod +x install.sh
chmod +x docker-entrypoint.sh

for d in */; do
  echo "Updating $d with new scripts"
  cp install.sh $d
  cp docker-entrypoint.sh $d
done

rm install.sh

echo "Done"
