#!/usr/bin/env bash

# @see https://raw.githubusercontent.com/ShangjinTang/dotfiles/05ef87daae29475244c276db5d406b58c52be445/linux/ubuntu/22.04/bin/update-alternatives-clang
# 
# sudo bash ./update-alternatives-gcc


# Colors
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BOLD=$(tput bold)

VERSIONS=(11 12)

# Loop through versions
for VERSION in "${VERSIONS[@]}"; do

        alternative_string=""
        alternative_cmds=(g++)
        for cmd in ${alternative_cmds}; do
            symlink="/usr/bin/${cmd}-${VERSION}"
            if [[ -x "${symlink}" ]]; then
                alternative_string+=" --slave /usr/bin/${cmd} ${cmd} /usr/bin/${cmd}-${VERSION} "
            fi
        done
	
        # Remove specific alternative configuration
        sudo update-alternatives --remove gcc "/usr/bin/gcc-${VERSION}" > /dev/null

        # Install alternatives
        install_command="sudo update-alternatives \
        --install /usr/bin/gcc gcc /usr/bin/gcc-${VERSION} ${VERSION} \
        ${alternative_string}"

        # Print the concatenated string
        echo "${BOLD}${GREEN}[Adding alternative /usr/bin/gcc-${VERSION} ...]${RESET}"
        echo "Master command: gcc-${VERSION}"
        echo "Slave commands: ${alternative_cmds[*]}"
	echo "Alts: ${alternative_string}"

        eval "$install_command"

        # Check eval command's return value
        if [[ $? -eq 0 ]]; then
            echo "${BOLD}${GREEN}[Adding alternative /usr/bin/gcc-${VERSION}: succeeded]${RESET}"
        else
            echo "${BOLD}${RED}[Adding alternative /usr/bin/gcc-${VERSION}: failed]${RESET}"
        fi

        echo ""
done

gcc_path=$(sudo update-alternatives --get-selections | grep ^gcc | awk '{print $NF}')

echo "======================================================================"
echo "${GREEN}gcc alternative is set to: ${gcc_path}${RESET}"
echo "======================================================================"
gcc --version
g++ --version

# print helps
echo ""
echo "Info:"
num_versions=${#VERSIONS[@]}
if [[ num_versions -gt 1 ]]; then
    echo "  use '${GREEN}sudo update-alternatives --config gcc${RESET}' to change default gcc alternative"
fi
echo "  use '${GREEN}sudo update-alternatives --remove gcc /usr/bin/gcc-*${RESET}' to delete a gcc alternative"
echo "  use '${GREEN}sudo update-alternatives --remove-all gcc${RESET}' to delete all gcc alternatives"

