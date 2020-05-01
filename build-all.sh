#!/bin/bash
set -e
# Find all clean release tags starting with 1.5.0
releases=$( git ls-remote -q --tags git@github.com:meteor/meteor.git release/METEOR@* | grep -o -P '(?<=METEOR@)1\.([5-9]|\d\{2,})\.\d+(\.\d+)*' | sort | uniq )
repo="empiricaly/meteor"
echo Metoer releases available: ${releases[@]}

imagesAvailable=$(curl -s https://hub.docker.com/v2/repositories/${repo}/tags | node ./get-dockerhub-tags.js | sort | uniq )

echo Images already on the registry $repo: ${imagesAvailable[@]}

releases=$(printf "%s\n" "${releases[@]}" "${imagesAvailable[@]}" "latest" | sort | uniq -u)

echo Images to build: ${releases[@]}

for release in ${releases}
do
  tag="${repo}:${release}"
  echo Now building ${tag}:
  docker build -t "${tag}" --build-arg "METEOR_RELEASE=${release}" .
  docker push "${repo}"
  docker image rm "${tag}"
done