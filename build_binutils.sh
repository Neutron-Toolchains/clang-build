#!/bin/bash
# A Script to build GNU binutils
set -e

BUILDDIR=$(pwd)
BINUTILS_DIR="$BUILDDIR/binutils-gdb"
INSTALL_DIR="$BUILDDIR/install"
BINTUILS_BUILD="$BUILDDIR/binutils-build"

cd $BINUTILS_DIR
# Turn off development mode
sed -i '/^development=/s/true/false/' bfd/development.sh
cd $BUILDDIR

build() {
	rm -rf $BINTUILS_BUILD
	mkdir -p $BINTUILS_BUILD
	cd $BINTUILS_BUILD
	if [[ $1 == "X86" ]]; then
		"$BINUTILS_DIR"/configure \
			CC="gcc" \
			CXX="g++" \
			CFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			CXXFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			LDFLAGS="-Wl,-O3,--sort-common,--as-needed,-z,now" \
			--target=x86_64-pc-linux-gnu \
			--prefix=$INSTALL_DIR \
			--disable-compressed-debug-sections \
			--disable-gdb \
			--disable-gdbserver \
			--disable-docs \
			--disable-sim \
			--disable-werror \
			--enable-lto \
			--enable-relro \
			--with-pic \
			--enable-deterministic-archives \
			--enable-new-dtags \
			--enable-plugins \
			--enable-gold \
			--enable-threads \
			--enable-targets=x86_64-pep \
			--with-system-zlib \
			--enable-ld=default \
			--quiet \
			--with-pkgversion="Neutron Binutils"
	elif [[ $1 == "ARM64" ]]; then
		"$BINUTILS_DIR"/configure \
			CC="gcc" \
			CXX="g++" \
			CFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			CXXFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			LDFLAGS="-O3" \
			--target=aarch64-linux-gnu \
			--prefix=$INSTALL_DIR \
			--disable-compressed-debug-sections \
			--disable-gdb \
			--disable-gdbserver \
			--disable-docs \
			--disable-multilib \
			--disable-werror \
			--disable-nls \
			--with-gnu-as \
			--with-gnu-ld \
			--enable-lto \
			--enable-deterministic-archives \
			--enable-new-dtags \
			--enable-plugins \
			--enable-gold \
			--enable-threads \
			--with-system-zlib \
			--enable-ld=default \
			--quiet \
			--with-pkgversion="Neutron Binutils"
	elif [[ $1 == "ARM" ]]; then
		"$BINUTILS_DIR"/configure \
			CC="gcc" \
			CXX="g++" \
			CFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			CXXFLAGS="-march=x86-64 -mtune=generic -flto=auto -flto-compression-level=10 -O3 -pipe -ffunction-sections -fdata-sections -ffat-lto-objects" \
			LDFLAGS="-O3" \
			--target=arm-linux-gnueabi \
			--prefix=$INSTALL_DIR \
			--disable-compressed-debug-sections \
			--disable-gdb \
			--disable-gdbserver \
			--disable-docs \
			--disable-multilib \
			--disable-werror \
			--disable-nls \
			--with-gnu-as \
			--with-gnu-ld \
			--enable-lto \
			--enable-deterministic-archives \
			--enable-new-dtags \
			--enable-plugins \
			--enable-gold \
			--enable-threads \
			--with-system-zlib \
			--enable-ld=default \
			--quiet \
			--with-pkgversion="Neutron Binutils"
	fi
	make -j$(($(nproc --all) + 2))
	make install -j$(($(nproc --all) + 2))
}

echo "Starting Binutils Build"
echo "Starting Binutils Build for x86-64"
build "X86"
echo "Starting Binutils Build for arm"
build "ARM"
echo "Starting Binutils Build for arm64"
build "ARM64"
echo "Binutils Build: END"
