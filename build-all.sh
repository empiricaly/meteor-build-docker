#!/bin/bash
set -e
# Find all clean release tags starting with 1.5.0
releases=$( git ls-remote -q --tags git@github.com:meteor/meteor.git release/METEOR@* | grep -o -P '(?<=METEOR@)1\.([5-9]|\d\{2,})\.\d+(\.\d+)*' | sort | uniq )
repo="empiricaly/meteor"

echo Meteor releases available: ${releases[@]}

releasesToSkip=( "1.5.4.2" "1.6.1.2" "1.6.1.3" "1.6.2" "1.7.1" )

echo Some of these \"available\" releases are not really available \(possibly, because they are expired\), namely: ${releasesToSkip[@]}

imagesAvailable=$( node ./get-dockerhub-tags.js https://hub.docker.com/v2/repositories/${repo}/tags | sort | uniq )

echo Images already on the registry $repo: ${imagesAvailable[@]}

releases=$(printf "%s\n" "${releases[@]}" "${imagesAvailable[@]}" ${releasesToSkip[@]} "latest" | sort | uniq -u)

echo Images to build: ${releases[@]}

for release in ${releases}
do
  tag="${repo}:${release}"
  echo Now building ${tag}:
  docker build -t "${tag}" --build-arg "METEOR_RELEASE=${release}" .
done