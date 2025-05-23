#!/usr/bin/bash

set -x

#
# Raspberry Pi
# Build gcc from sources & install as a Debian package
# https://forums.raspberrypi.com/viewtopic.php?t=362502
# Debian:
#  - https://earthly.dev/blog/creating-and-hosting-your-own-deb-packages-and-apt-repo/
#  - https://anavi.org/article/215/
#  - https://wiki.debian.org/BuildingTutorial
# 

VERSION=14.2.0
MAJVER=14

BUILDROOT=${HOME}/work
DEBDIR=gcc-$VERSION-1_arm64
INSTALLDIR=${BUILDROOT}/gcc-$VERSION/${DEBDIR}

OPTS=$(cat << END
   --enable-languages=c,c++ \
   --disable-multilib       \
   --disable-bootstrap      \
   --prefix=${INSTALLDIR}/usr/local
END
)

#
#  For any computer with less than 4GB of memory.
#
#if [ -f /etc/dphys-swapfile ]; then
#  sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
#  sudo /etc/init.d/dphys-swapfile restart
#fi

pushd ${BUILDROOT} || exit 1

if [ -d gcc-$VERSION ]; then
  cd gcc-$VERSION
  rm -rf obj
else
  if [[ ! -f gcc-$VERSION.tar.xz ]]; then
    wget https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.xz || exit 1
  fi
  tar xf gcc-$VERSION.tar.xz
  #rm -f gcc-$VERSION.tar.xz
  cd gcc-$VERSION
  contrib/download_prerequisites
fi
mkdir -p obj || exit 1
cd obj

#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform. You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#  For a very quick build try: --disable-bootstrap
#

# x86_64
# ../configure $OPTS

# AArch64 Pi4
#../configure --with-cpu=cortex-a72 $OPTS

# AArch64 Pi5
../configure --with-cpu=cortex-a76 $OPTS

# Pi Zero and Pi1
#../configure --enable-languages=$LANG --with-cpu=arm1176jzf-s \
#  --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Pi4 in 32-bit mode
#../configure --enable-languages=$LANG --with-cpu=cortex-a72 \
#  --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Pi3+, Pi3, new Pi2
#../configure --enable-languages=$LANG --with-cpu=cortex-a53 \
#  --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Old Pi2
#../configure --enable-languages=$LANG --with-cpu=cortex-a7 \
#  --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

#
#  Now build GCC which will take a long time.  This could range from less
#  than 2 hours on an 8GB Pi5 up to over 100 hours on a 256MB Pi1.  It can be
#  left to complete overnight (or over the weekend for a Pi Zero :-)
#  The most likely causes of failure are lack of disk space, lack of
#  swap space or memory, or the wrong configure section uncommented.
#  The new compiler is placed in /usr/local/bin, the existing compiler remains
#  in /usr/bin and may be used by giving its version gcc-8 (say).
#
#make #-j `nproc`
make 
make install
#sudo checkinstall --install=no ;; #-D make install ;;

#
#Debian pkg
#
cd ..
mkdir -p ${INSTALLDIR}/DEBIAN || exit 1

cat << EOF > ${INSTALLDIR}/DEBIAN/control
Source: gcc
Section: devel
Provides: c-compiler
Priority: optional
Maintainer: unknown
Rules-Requires-Root: no
Package: gcc-${MAJVER}
Version: $VERSION-1
Architecture: arm64
Description: Home brew gcc $VERSION
EOF

dpkg --build ${DEBDIR}
ls -l *.deb
dpkg-deb --info *.deb
#dpkg-deb --contents *.deb

cat << EOM
TODO: postinstall & reverse on removing:

    ln -s /usr/local/bin/gcc        /usr/bin/gcc-${MAJVER}
    ln -s /usr/local/bin/g++        /usr/bin/g++-${MAJVER}
    ln -s /usr/local/bin/gcc-ranlib /usr/bin/gcc-ranlib-${MAJVER}
    ln -s /usr/local/bin/gcov       /usr/bin/gcov-${MAJVER}
    ln -s /usr/local/bin/gcov-dump  /usr/bin/gcov-dump-${MAJVER}
    ln -s /usr/local/bin/cpp        /usr/bin/cpp-${MAJVER}
    ln -s /usr/local/bin/gcov-tool  /usr/bin/gcov-tool-${MAJVER}
    ln -s /usr/local/bin/lto-dump   /usr/bin/lto-dump-${MAJVER}
    ln -s /usr/local/bin/gcc-ar     /usr/bin/gcc-ar-${MAJVER}
    ln -s /usr/local/bin/gcc-nm     /usr/bin/gcc-nm-${MAJVER}
    
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${MAJVER}  ${MAJVER}  --slave /usr/bin/g++ g++ /usr/bin/g++-${MAJVER}
    update-alternatives --config gcc
    
EOM

echo "Done"
popd
