#!/bin/sh

cd flysat
python oscam-srvid-generator-flysat.py
cd ..

git add -u
git add *
git commit -m "Fetch latest flysat info"
