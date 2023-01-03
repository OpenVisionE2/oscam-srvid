#!/bin/sh

cd lyngsat
./oscam-srvid-generator-lyngsat.sh
cd ..

git add -u
git add *
git commit -m "Fetch latest lyngsat info"
