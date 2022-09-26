#!/bin/bash
if [ -z ${1+x} ]; then
    echo "No version pass as an argument, stopping the release process"
    exit 1
fi

echo "Updating application version to ${1}"
sed -i 's/version: .*+/version: '"${1}"'+/g' pubspec.yaml

echo  "Updating versionCode"
NEW_VERSION_CODE=$(($(grep -o -P '(?<=version: '"${1}"'\+).*(?=$)' pubspec.yaml)+1))
sed -i 's/version: '"${1}"'+.*$/version: '"${1}"'+'"$NEW_VERSION_CODE"'/g' pubspec.yaml