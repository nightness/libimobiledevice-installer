#!/bin/bash
function build_libimobiledevice(){
    libs=( "libplist" "libusbmuxd" "libimobiledevice" "libirecovery" "idevicerestore" )
   
    buildlibs() {
        for i in "${libs[@]}"
        do
            echo -e "\033[1;33m[*] Fetching $i...\033[1;32m"
            git clone https://github.com/libimobiledevice/${i}.git
            cd $i
            echo -e "\033[1;33m[*] Configuring $i...\033[1;32m"
            autoreconf --install
            ./autogen.sh --prefix=/usr --without-cython
            echo -e "\033[1;33m[*] Building $i...\033[1;32m"
            make > /dev/null
            echo -e "\033[1;33m[*] Installing $i...\033[1;32m"
            sudo make install > /dev/null
            cd ..
        done
    }
   
    echo -e "\033[1;33m[*] Building and installing libplist, libusbmuxd, libimobiledevice, libirecovery, idevicerestore..."
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