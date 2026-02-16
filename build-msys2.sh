#!/bin/bash
set -e

# Verify we're running inside an MSYS2 MinGW shell
if [ -z "$MSYSTEM" ] || [ -z "$MINGW_PACKAGE_PREFIX" ]; then
    echo -e "\033[1;31m[!] This script must be run from an MSYS2 MinGW shell (e.g. 'MINGW64').\033[0m"
    echo -e "\033[1;31m[!] Launch 'MSYS2 MinGW 64-bit' from the Start menu and try again.\033[0m"
    exit 1
fi

PREFIX="${1:-$MINGW_PREFIX}"

function install_deps(){
    echo -e "\033[1;33m[*] Removing conflicting pre-built MSYS2 packages...\033[1;32m"
    pacman -Rns --noconfirm \
        ${MINGW_PACKAGE_PREFIX}-libplist \
        ${MINGW_PACKAGE_PREFIX}-libusbmuxd \
        ${MINGW_PACKAGE_PREFIX}-libimobiledevice \
        2>/dev/null || true
    echo -e "\033[1;33m[*] Installing build dependencies...\033[1;32m"
    pacman -S --noconfirm --needed \
        git autoconf automake libtool make \
        ${MINGW_PACKAGE_PREFIX}-gcc \
        ${MINGW_PACKAGE_PREFIX}-pkg-config \
        ${MINGW_PACKAGE_PREFIX}-libusb \
        ${MINGW_PACKAGE_PREFIX}-openssl \
        ${MINGW_PACKAGE_PREFIX}-curl \
        ${MINGW_PACKAGE_PREFIX}-readline \
        ${MINGW_PACKAGE_PREFIX}-libzip
    echo -e "\033[1;33m[*] Build dependencies installed"
}

function build_libimobiledevice(){
    libs=( "libplist" "libimobiledevice-glue" "libtatsu" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" "libideviceactivation" "ideviceinstaller" )

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

    echo -e "\033[1;33m[*] Building and installing libplist, libimobiledevice-glue, libtatsu, libusbmuxd, libimobiledevice, libirecovery, idevicerestore, libideviceactivation, ideviceinstaller..."
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
    cd ..
    echo -e "\033[1;33m[*] Finished"
}

install_deps
build_libimobiledevice
