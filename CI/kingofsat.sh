#!/bin/sh

cd kingofsat
./oscam-srvid-generator-kingofsat.sh
cd ..

git add -u
git add *
git commit -m "Fetch latest kingofsat info"
