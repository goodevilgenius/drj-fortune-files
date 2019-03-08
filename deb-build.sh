#!/bin/bash
##
## build.sh
## 
## Made by Dan Jones
## 
## Started on  Wed Nov 15 13:52:21 CDT 2006 Dan Jones
## Edited on Fri Mar 08 08:06:55 CST 2019 Dan Jones
##

dir="$(dirname "$0")"
pushd "$dir"
name="fortunes-drj"
arch="$(dpkg-architecture -qDEB_BUILD_ARCH)"

mkdir -p "${name}/usr/share/games/fortunes"

find files/ ! -path '*.git*' -type f -a \! -name '*~' | while read file
do
    fmt -s -w 80 "$file" >> "${name}/usr/share/games/fortunes/$(basename ${file})"
done

find "${name}/usr/share/games/fortunes" -type f \! -name '*.dat' -exec strfile {} \;

VERSION="`date +%Y%m%d.%s`"

mkdir -v "${name}/DEBIAN"
cat >"${name}/DEBIAN/control" <<EOF
Package: ${name}
Version: 0.${VERSION}
Section: games
Architecture: ${arch}
Essential: no
Enhances: fortune-mod
Maintainer: "Dan Jones" <djones109@gmail.com>
Provides: ${name}
Description: My Fortune files
 These are quotes I've collected from various sources, mostly spiritual.
EOF

dpkg -b "${name}" "debs/${name}_${VERSION}-${arch}.deb" && rm -rf "${name}"
popd

REPO="${HOME}/public_html/apt-repository"
rm "${REPO}"/fortunes-drj_*.deb
mv "${dir}/debs/${name}_${VERSION}-${arch}.deb" "${REPO}"
pushd "${REPO}"
dpkg-scanpackages . /dev/null | gzip -9c > "Packages.gz"
popd
echo "${REPO}/${name}_${VERSION}-${arch}.deb"
