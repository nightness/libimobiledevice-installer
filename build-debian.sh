#!/bin/bash
set -e

PREFIX="${1:-/usr/local}"

function install_deps(){
    echo -e "\033[1;33m[*] Removing conflicting system packages...\033[1;32m"
    sudo apt-get remove -y libimobiledevice-utils libimobiledevice-dev libusbmuxd-dev 2>/dev/null || true
    echo -e "\033[1;33m[*] Installing build dependencies...\033[1;32m"
    sudo apt-get install -y git pkg-config libtool m4 automake autoconf \
        libxml2-dev libusb-1.0-0-dev libssl-dev libreadline-dev \
        libzip-dev libfuse3-dev libcurl4-openssl-dev
    echo -e "\033[1;33m[*] Build dependencies installed"
}

function build_libimobiledevice(){
    libs=( "libplist" "libimobiledevice-glue" "libtatsu" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" "usbmuxd" "libideviceactivation" "ideviceinstaller" "ifuse" )

    export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"

    # Determine if sudo is needed for the install prefix
    mkdir -p "${PREFIX}/lib" 2>/dev/null || true
    if touch "${PREFIX}/lib/.write_test" 2>/dev/null; then
        rm -f "${PREFIX}/lib/.write_test"
        SUDO=""
    else
        SUDO="sudo"
    fi

    buildlibs() {
        for i in "${libs[@]}"
        do
            echo -e "\033[1;33m[*] Fetching $i...\033[1;32m"
            git clone https://github.com/libimobiledevice/${i}.git
            cd $i
            echo -e "\033[1;33m[*] Configuring $i...\033[1;32m"
            autoreconf --install
            ./autogen.sh --prefix="${PREFIX}" --without-cython
            echo -e "\033[1;33m[*] Building $i...\033[1;32m"
            make > /dev/null
            echo -e "\033[1;33m[*] Installing $i...\033[1;32m"
            $SUDO make install > /dev/null
            cd ..
        done
    }
    
    echo -e "\033[1;33m[*] Building and installing libplist, libimobiledevice-glue, libtatsu, libusbmuxd, libimobiledevice, libirecovery, idevicerestore, usbmuxd, libideviceactivation, ideviceinstaller, ifuse..."
    echo -e "\033[1;33m[*] Install prefix: ${PREFIX}"
    # Create a new dist folder
    if [ -d `pwd`/dist ]; then
        echo -e "\033[1;31m[*] Removing old dist directory"
        rm -rf ./dist
    fi
    echo -e "\033[1;33m[*] Creating new dist directory"
    mkdir dist
    cd dist
    buildlibs
    $SUDO ldconfig &>/dev/null
    cd ..
    echo -e "\033[1;33m[*] Finished"
}

install_deps
build_libimobiledevice

