# Communicator
![](https://mauikit.org/wp-content/uploads/2018/12/maui_project_logo.png)

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0) [![Awesome](https://awesome.re/badge.svg)](https://awesome.re) [![Generic badge](https://img.shields.io/badge/OS-Linux-blue.svg)](https://shields.io/)

_Create and organize contacts (phone, email, name, etc.)._

# Screenshots

![communicator](https://user-images.githubusercontent.com/3053525/141739588-fcb32abb-55a8-40c7-b257-78226ee80411.png)

# Build

### Requirements

#### Debian/Ubuntu

```
libkf5config-dev
libkf5contacts-dev
libkf5coreaddons-dev
libkf5i18n-dev
libkf5kio-dev
libkf5notifications-dev
libkf5people-dev
libkf5service-dev
libqt5svg5-dev
mauikit
mauikit-accounts
mauikit-filebrowsing
qtbase5-dev
qtdeclarative5-dev
qtquickcontrols2-5-dev
```

### Compile source
 1. `git clone --depth 1 --branch v2.1 https://invent.kde.org/maui/communicator.git` 
 2. `mkdir -p communicator/build && cd communicator/build`
 4. `cmake-DCMAKE_INSTALL_PREFIX=/usr -DENABLE_BSYMBOLICFUNCTIONS=OFF -DQUICK_COMPILER=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_SYSCONFDIR=/etc -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON -DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON -DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..`
 5. `make`

 ### Install
 1. `make install`

# Issues
If you find problems with the contents of this repository please create an issue.

©2021 Nitrux Latinoamericana S.C.
