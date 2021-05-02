#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://api.github.com/repos/v2fly/v2ray-core/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
mkdir -p release
wget -O release/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O release/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

git clone -b ${VERSION} https://github.com/v2fly/v2ray-core.git && cd v2ray-core

# Start Build
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
	if [ "${ARCH}" == "arm" ]; then
		for ARM in ${ARMS[@]}; do
			echo "Building v2ray-linux-${ARCH}32-v${ARM}" && cd ${CUR}/v2ray-core
			env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/v2ray-linux-${ARCH}32-v${ARM} -trimpath -ldflags "-s -w -buildid=" ./main
            env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/v2ctl-linux-${ARCH}32-v${ARM} -trimpath -ldflags "-s -w -buildid=" -tags confonly ./infra/control/main
			cd ${CUR}/release && zip -9 -r v2ray-linux-${ARCH}32-v${ARM}.zip *-linux-${ARCH}32-v${ARM} geoip.dat geosite.dat && rm -rf *-linux-${ARCH}32-v${ARM}
		done
	else
		echo "Building v2ray-linux-${ARCH}" && cd ${CUR}/v2ray-core
		env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/v2ray-linux-${ARCH} -trimpath -ldflags "-s -w -buildid=" ./main
        env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/v2ctl-linux-${ARCH} -trimpath -ldflags "-s -w -buildid=" -tags confonly ./infra/control/main
		cd ${CUR}/release && zip -9 -r v2ray-linux-${ARCH}.zip *-linux-${ARCH} geoip.dat geosite.dat && rm -rf *-linux-${ARCH}
	fi
done

rm -rf ${CUR}/release/{"geoip.dat","geosite.dat"}