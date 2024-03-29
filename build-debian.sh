#!/bin/bash

function install_deps(){
    echo -e "\033[1;33m[*] Installing package dependencies...\033[1;32m"
    sudo apt-get remove libimobiledevice-utils libimobiledevice-dev libusbmuxd-dev
    sudo apt-get install git libtool m4 automake autoconf libxml2-dev python2.7-dev libusb-dev cython \
        libusb-1.0-0-dev libssl-dev libreadline-dev libplist-dev libplist++-dev libplist++3v5 libplist-utils \
	libzip-dev libfuse-dev libcurl4-openssl-dev
    echo -e "\033[1;33m[*] Package dependencies installed"
}

function build_libimobiledevice(){
    libs=( "libplist" "libimobiledevice-glue" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" "usbmuxd" "libideviceactivation" "ideviceinstaller" "ifuse" )
    
    buildlibs() {
        for i in "${libs[@]}"
        do
            echo -e "\033[1;33m[*] Fetching $i...\033[1;32m"
            git clone https://github.com/libimobiledevice/${i}.git
            cd $i
            echo -e "\033[1;33m[*] Configuring $i...\033[1;32m"
            autoreconf --install
            ./autogen.sh
            echo -e "\033[1;33m[*] Building $i...\033[1;32m"
            make > /dev/null
            echo -e "\033[1;33m[*] Installing $i...\033[1;32m"
            sudo make install > /dev/null
            cd ..
        done
    }
    
    echo -e "\033[1;33m[*] Building and installing libplist, libusbmuxd, libimobiledevice, libirecovery, idevicerestore, usbmuxd, libideviceactivation, ideviceinstaller, ifuse..."
    # Create a new dist folder
    if [ -d `pwd`/dist ]; then
        echo -e "\033[1;31m[*] Removing old dist directory"
        rm -rf ./dist
    fi
    echo -e "\033[1;33m[*] Creating new dist directory"
    mkdir dist
    cd dist
    buildlibs
    sudo ldconfig &>/dev/null
    cd ..
    echo -e "\033[1;33m[*] Finished"
}

install_deps
build_libimobiledevice

