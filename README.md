# libimobiledevice-installer

Automated build scripts for compiling and installing the [libimobiledevice](https://github.com/libimobiledevice) suite of tools from source.

## Supported Platforms

| Platform | Script | Default Prefix |
|----------|--------|---------------|
| macOS | `build-macos.sh` | `/usr/local` |
| Debian/Ubuntu | `build-debian.sh` | `/usr/local` |
| Cygwin (Windows) | `build-cygwin.sh` | `/usr` |
| MSYS2 (Windows) | `build-msys2.sh` | `$MINGW_PREFIX` (e.g. `/mingw64`) |

## Usage

```bash
# Clone the repo
git clone https://github.com/nightness/libimobiledevice-installer.git
cd libimobiledevice-installer

# Run the script for your platform (installs to default prefix)
./build-macos.sh
./build-debian.sh
./build-cygwin.sh
./build-msys2.sh

# Or specify a custom install prefix
./build-macos.sh /opt/libimobiledevice
./build-debian.sh /opt/libimobiledevice
```

Each script will automatically use `sudo` for install commands when the prefix directory requires elevated permissions. If the prefix is user-writable, `sudo` is skipped.

## What Gets Built

All scripts clone and build libraries from the [libimobiledevice](https://github.com/libimobiledevice) GitHub organization in dependency order:

**All platforms:**
- libplist
- libimobiledevice-glue
- libtatsu
- libusbmuxd
- libimobiledevice
- libirecovery
- idevicerestore

**macOS additionally builds:**
- libideviceactivation
- ideviceinstaller

**MSYS2 additionally builds:**
- libideviceactivation
- ideviceinstaller

**Debian additionally builds:**
- usbmuxd
- libideviceactivation
- ideviceinstaller
- ifuse

## Prerequisites

**macOS:** [Homebrew](https://brew.sh) (dependencies are installed automatically via `brew install`)

**Debian/Ubuntu:** Dependencies are installed automatically via `apt-get`. The script installs build tools (git, pkg-config, libtool, automake, autoconf) and external development libraries (libxml2, libusb, libssl, libreadline, libzip, libfuse3, libcurl). All libimobiledevice-stack libraries are built from source.

**Cygwin:** Dependencies must be pre-installed through the Cygwin setup program. Required packages: `git`, `libtool`, `automake`, `autoconf`, `make`, `pkg-config`, `libusb1.0-devel`, `libssl-devel`, `libcurl-devel`, `libreadline-devel`.

**MSYS2:** Dependencies are installed automatically via `pacman`. The script must be run from an MSYS2 MinGW shell (e.g. "MSYS2 MinGW 64-bit" from the Start menu).

**Note:** Only the macOS and Debian/Ubuntu scripts have been tested. The Windows scripts (Cygwin and MSYS2) are untested and may require adjustments.

## Windows Notes

Both Cygwin and MSYS2 builds require **Apple Mobile Device Support** to be installed for USB communication with iOS devices. This service is included with [iTunes for Windows](https://www.apple.com/itunes/) and provides the `usbmuxd` functionality on Windows. Neither script builds `usbmuxd` because Apple's own service handles USB device multiplexing on Windows.

Neither Windows script builds `ifuse`. FUSE filesystem support is Linux-specific, so mounting iOS device storage as a local directory is not available on Windows.

MSYS2 produces native Windows binaries (no emulation layer), while Cygwin binaries depend on the Cygwin POSIX compatibility DLL.

## License

The build scripts in this repository are provided as-is. The libraries built by these scripts are subject to their own licenses — see each project's repository for details.
