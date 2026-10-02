#!/usr/bin/env bash

if [ "$EUID" == 0 ]
  then echo "Please run as a non-root user."
  exit
fi

echo "DRAFT — eckirchn/BirdNET-Pi. Not for a station you rely on."
echo "Identification method: https://birdnet.cornell.edu/"
echo "Engine source: https://github.com/birdnet-team"

if [ "$(uname -m)" != "aarch64" ] && [ "$(uname -m)" != "x86_64" ];then
  echo "This draft needs 64-bit Raspberry Pi OS (uname -m must be aarch64)."
  echo "This machine reports $(uname -m). 32-bit Pi OS cannot run the BirdNET TFLite model."
  echo "On a Pi 3B, 3B+, 4, 400, 5, or Zero 2 W, reflash Raspberry Pi OS Lite (64-bit), then run this again."
  exit 1
fi

PY_VERSION=$(python3 -c "import sys; print(f'{sys.version_info[0]}{sys.version_info[1]}')")
if [ "${PY_VERSION}" == "39" ] ;then
  echo "### BirdNET-Pi requires a newer OS. Bullseye is deprecated, please use Bookworm. ###"
  [ -z "${FORCE_BULLSEYE}" ] && exit
fi

# we require passwordless sudo
sudo -K
if ! sudo -n true; then
    echo "Passwordless sudo is not working. Aborting"
    exit
fi

# Simple new installer
HOME=$HOME
USER=$USER

export HOME=$HOME
export USER=$USER

PACKAGES_MISSING=
for cmd in git jq ; do
  if ! which $cmd &> /dev/null;then
      PACKAGES_MISSING="${PACKAGES_MISSING} $cmd"
  fi
done
if [[ ! -z $PACKAGES_MISSING ]] ; then
  sudo apt update
  sudo apt -y install $PACKAGES_MISSING
fi

branch=main
git clone -b $branch --depth=1 https://github.com/eckirchn/BirdNET-Pi.git ${HOME}/BirdNET-Pi &&

$HOME/BirdNET-Pi/scripts/install_birdnet.sh
if [ ${PIPESTATUS[0]} -eq 0 ];then
  echo "Installation completed successfully"
  sudo reboot
else
  echo "The installation exited unsuccessfully."
  exit 1
fi
