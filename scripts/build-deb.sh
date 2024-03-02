#! /bin/bash

set -x

### Update sources

wget -qO /etc/apt/sources.list.d/nitrux-depot.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.depot
wget -qO /etc/apt/sources.list.d/nitrux-testing.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.testing
wget -qO /etc/apt/sources.list.d/nitrux-unison.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.unison

curl -L https://packagecloud.io/nitrux/depot/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/unison/gpgkey | apt-key add -;

apt -qq update

### Install Package Build Dependencies #2

apt -qq -yy install --no-install-recommends \
	mauikit-accounts-git \
	mauikit-filebrowsing-git \
	mauikit-git

### Download Source

git clone --depth 1 --branch $COMMUNICATOR_BRANCH https://invent.kde.org/maui/communicator.git

### Compile Source

mkdir -p build && cd build

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_BSYMBOLICFUNCTIONS=OFF \
	-DQUICK_COMPILER=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_SYSCONFDIR=/etc \
	-DCMAKE_INSTALL_LOCALSTATEDIR=/var \
	-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu ../communicator/

make -j$(nproc)

make install

### Run checkinstall and Build Debian Package

>> description-pak printf "%s\n" \
	'Contacts application built with MauiKit.' \
	'' \
	'Create and organize contacts (phone, email, name, etc.).' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=communicator-git \
	--pkgversion=$PACKAGE_VERSION \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=utils \
	--pkgsource=communicator \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=communicator \
	--requires="libc6,libkf5contacts5,libkf5coreaddons5,libkf5i18n5,libkf5kiocore5,libkf5people5,libkf5service5,libqt5core5a,libqt5gui5,libqt5qml5,libqt5sql5,libqt5widgets5,mauikit-accounts-git \(\>= 3.0.1+git\),mauikit-filebrowsing-git \(\>= 3.0.1+git\),mauikit-git \(\>= 3.0.1+git\)" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
