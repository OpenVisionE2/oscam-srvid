#!/bin/sh

cd twojeip
./oscam-srvid-generator-twojeip.sh
cd ..

git add -u
git add *
git commit -m "Fetch latest twojeip info"
