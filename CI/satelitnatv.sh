#!/bin/sh

cd satelitnatv
./oscam-srvid-generator-satelitnatv.sh
cd ..

git add -u
git add *
git commit -m "Fetch latest satelitnatv info"
