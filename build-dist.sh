#!/bin/bash

function install_deps(){
    sudo apt-get remove libimobiledevice-utils libimobiledevice-dev
    sudo apt-get install git libtool m4 automake autoconf libxml2-dev python2.7-dev libusb-dev \
        libusb-1.0-0-dev libssl-dev libreadline-dev libplist-dev libplist++-dev libplist++3v5 libplist-utils
}

function build_libimobiledevice(){
    #libs=( "libplist" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" )
    #libs=( "libplist" "libusbmuxd" "libimobiledevice" )
    libs=( "idevicerestore" )
    
    buildlibs() {
        for i in "${libs[@]}"
        do
            echo -e "\033[1;32mFetching $i..."
            git clone https://github.com/libimobiledevice/${i}.git
            cd $i
            echo -e "\033[1;32mConfiguring $i..."
            autoreconf --install
            ./autogen.sh
            if [ "${i}" = "libimobiledevice" ]; then
                echo -e "\033[1;32mPatching $i..."
                patch -i ../../patches/cython.patch ./cython/debugserver.pxi > /dev/null 2> /dev/null
            fi
            echo -e "\033[1;32mBuilding $i..."
            if [[ -e $(make) ]]; then
                echo -e "\033[1;32mInstalling $i..."
                #sudo make install
            fi
            cd ..
        done
    }
    
    # Create a new deps folder
    if [ -d `pwd`/deps ]; then
        echo "[*] Removing old deps directory"
        rm -rf ./deps
    fi
    echo "[*] Creating new deps directory"
    mkdir deps
    cd deps
    buildlibs
    if [[ -e $(which ldconfig) ]]; then
        sudo ldconfig
    fi
    cd ..
}

echo "[*] Installing package dependencies..."
install_deps
echo "[*] Package dependencies installed"

echo "[*] Building and installing libplist, libusbmuxd, libimobiledevice, libirecovery, idevicerestore..."
build_libimobiledevice
echo "[*] Finished"