# libimobiledevice-installer

Automated build scripts for compiling and installing the [libimobiledevice](https://github.com/libimobiledevice) suite of tools from source.

## Supported Platforms

| Platform | Script | Default Prefix |
|----------|--------|---------------|
| macOS | `build-macos.sh` | `/usr/local` |
| Debian/Ubuntu | `build-debian.sh` | `/usr/local` |
| Cygwin (Windows) | `build-cygwin.sh` | `/usr` |

## Usage

```bash
# Clone the repo
git clone https://github.com/nightness/libimobiledevice-installer.git
cd libimobiledevice-installer

# Run the script for your platform (installs to default prefix)
./build-macos.sh
./build-debian.sh
./build-cygwin.sh

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

**Debian additionally builds:**
- usbmuxd
- libideviceactivation
- ideviceinstaller
- ifuse

## Prerequisites

**macOS:** [Homebrew](https://brew.sh) (dependencies are installed automatically via `brew install`)

**Debian/Ubuntu:** Dependencies are installed automatically via `apt-get`. The script installs build tools (git, libtool, automake, autoconf) and required development libraries (libusb, libssl, libreadline, libplist, libzip, libfuse, libcurl, etc.).

**Cygwin:** Dependencies must be pre-installed through the Cygwin setup program.

## License

The build scripts in this repository are provided as-is. The libraries built by these scripts are subject to their own licenses — see each project's repository for details.
