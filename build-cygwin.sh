#!/bin/bash

PREFIX="${1:-/usr}"

function build_libimobiledevice(){
    libs=( "libplist" "libimobiledevice-glue" "libtatsu" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" )

    export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"

    # Determine if sudo is needed for the install prefix
    if [ -w "${PREFIX}" ] 2>/dev/null || mkdir -p "${PREFIX}" 2>/dev/null; then
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
   
    echo -e "\033[1;33m[*] Building and installing libplist, libimobiledevice-glue, libtatsu, libusbmuxd, libimobiledevice, libirecovery, idevicerestore..."
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
build_libimobiledevice