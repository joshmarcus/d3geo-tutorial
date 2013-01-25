#!/bin/sh

mkdir -p data
if [ ! -f data/ne_10m_populated_places.shp ] 
then
  wget -P data http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip
  cd data
  unzip ne_10m_populated_places.zip
fi 

if [ ! -f data/ne_10m_admin_0_map_subunits.shp ] 
then
  wget -P data http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_map_subunits.zip 
  cd data
  unzip ne_10m_admin_0_map_subunits.zip
fi 

cd data
ogr2ogr \
  -f GeoJSON \
  -where "adm0_a3 IN ('GBR', 'IRL')" \
  subunits.json \
  ne_10m_admin_0_map_subunits.shp

ogr2ogr \
  -f GeoJSON \
  -where "iso_a2 = 'GB' AND SCALERANK < 8" \
  places.json \
  ne_10m_populated_places.shp

topojson \
  --id-property su_a3 \
  -p NAME=name \
  -p name \
  -o uk.json \
  subunits.json \
  places.json

