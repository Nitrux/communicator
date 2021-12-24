#!/bin/bash

set -x

### Install Build Tools #1

DEBIAN_FRONTEND=noninteractive apt -qq update
DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	appstream \
	automake \
	autotools-dev \
	build-essential \
	checkinstall \
	cmake \
	curl \
	devscripts \
	equivs \
	extra-cmake-modules \
	gettext \
	git \
	gnupg2 \
	lintian \
	wget

### Add Neon Sources

wget -qO /etc/apt/sources.list.d/neon-user-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.neon.user

DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	55751E5D > /dev/null

curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;

wget -qO /etc/apt/sources.list.d/nitrux-testing-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.nitrux.testing

DEBIAN_FRONTEND=noninteractive apt -qq update

### Install Package Build Dependencies #2

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends \
	libkf5config-dev \
	libkf5contacts-dev \
	libkf5coreaddons-dev \
	libkf5i18n-dev \
	libkf5kio-dev \
	libkf5notifications-dev \
	libkf5people-dev \
	libkf5service-dev \
	libqt5svg5-dev \
	mauikit-git \
	mauikit-accounts-git \
	mauikit-filebrowsing-git \
	qtbase5-dev \
	qtdeclarative5-dev \
	qtquickcontrols2-5-dev

### Clone repo.

git clone --single-branch --branch master https://invent.kde.org/maui/communicator.git

rm -rf communicator/{android_files,LICENSE,README.md}

sed -i 's+install(FILES org.maui.communicator.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})+install(FILES org.kde.communicator.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})+g' CMakeLists.txt

sed -i 's+install(FILES org.maui.communicator.json DESTINATION /usr/share/maui-accounts/manifests)+install(FILES org.kde.communicator.json DESTINATION /usr/share/maui-accounts/manifests)+g' CMakeLists.txt

### Compile Source

mkdir -p communicator/build && cd communicator/build

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
	-DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..

make

### Run checkinstall and Build Debian Package
### DO NOT USE debuild, screw it

>> description-pak printf "%s\n" \
	'MauiKit Contacts and dialer application.' \
	'' \
	'Communicator allows you to save and manage contacts' \
	'' \
	'Communicator works on desktops, Android and Plasma Mobile.' \
	'' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=communicator \
	--pkgversion=2.1.0 \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=lib \
	--pkgsource=communicator \
	--pakdir=../.. \
	--maintainer=uri_herrera@nxos.org \
	--provides=index \
	--requires="libc6,libkf5contacts5,libkf5coreaddons5,libkf5i18n5,libkf5people5,libkf5service5,libqt5core5a,libqt5gui5,libqt5qml5,libqt5quick5,libqt5widgets5,libstdc++6,mauikit-git \(\>= 2.1.1+git\),qml-module-qt-labs-platform" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
