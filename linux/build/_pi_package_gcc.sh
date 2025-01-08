#!/usr/bin/bash

set -x

#
# Raspberry Pi
# Build gcc from sources & install as a Debian package
# https://forums.raspberrypi.com/viewtopic.php?t=362502
# Debian:
#  - https://anavi.org/article/215/
#  - https://wiki.debian.org/BuildingTutorial
# 

VERSION=14.2.0

OPTS=$(cat << END
     --enable-languages=c,c++ \
     --disable-multilib \
     --disable-werror   \
     --disable-bootstrap
END
)

#
#  For any computer with less than 4GB of memory.
#
#if [ -f /etc/dphys-swapfile ]; then
#  sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
#  sudo /etc/init.d/dphys-swapfile restart
#fi

pushd ${HOME}/work || exit 1

if [ -d gcc-$VERSION ]; then
  cd gcc-$VERSION
  rm -rf obj
else
  #wget https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.xz || exit 1
  tar xf gcc-$VERSION.tar.xz
  #rm -f gcc-$VERSION.tar.xz
  cd gcc-$VERSION
  contrib/download_prerequisites
  dh_make -f ../gcc-$VERSION.tar.xz
fi
mkdir -p obj
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
if make #-j `nproc`
then
  echo
  read -p "Do you wish to install the new GCC (y/n)? " yn
  case $yn in
     #[Yy]* ) sudo make install ;;
     [Yy]* ) sudo checkinstall --install=no ;; #-D make install ;;
	 * ) exit ;;
  esac
fi

echo "Done"
popd
