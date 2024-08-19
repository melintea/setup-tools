#!/usr/bin/env bash

# @see https://raw.githubusercontent.com/ShangjinTang/dotfiles/05ef87daae29475244c276db5d406b58c52be445/linux/ubuntu/22.04/bin/update-alternatives-clang
# 
# wget https://apt.llvm.org/llvm.sh
# chmod +x ./llvm.sh && sudo ./llvm.sh
# sudo bash ./update-alternatives-clang


# Colors
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BOLD=$(tput bold)

# Get available versions from /lib/llvm-*
# You can also use specific versions, e.g. VERSIONS=("14" "17" "18"), but not recommend
VERSIONS=()
for dir in /lib/llvm-*; do
    if [[ -d "$dir" ]]; then
        version=$(basename "$dir" | cut -d'-' -f2)
        VERSIONS+=("$version")
    fi
done

# Loop through versions
for VERSION in "${VERSIONS[@]}"; do
    # Check if /lib/llvm-${VERSION} directory exists
    if [[ -d "/lib/llvm-${VERSION}" ]]; then
        # Scan paths and generate string
        alternative_string=""
        alternative_cmds=()
        for cmd in "/lib/llvm-${VERSION}/bin/"*; do
            if [[ -x "$cmd" ]] && [[ "$(basename "$cmd")" != "clang" ]]; then
                base_cmd=$(basename "$cmd")
                symlink="/usr/bin/${base_cmd}-${VERSION}"
                if [[ -x "${symlink}" ]]; then
                    alternative_cmds+=($(basename ${symlink}))
                    alternative_string+="--slave /usr/bin/${base_cmd} ${base_cmd} ${symlink} "
                fi
            fi
        done

        # Remove specific alternative configuration
        sudo update-alternatives --remove clang "/usr/bin/clang-${VERSION}" > /dev/null

        # Install alternatives
        install_command="sudo update-alternatives \
        --install /usr/bin/clang clang /usr/bin/clang-${VERSION} ${VERSION} \
        ${alternative_string}"

        # Print the concatenated string
        echo "${BOLD}${GREEN}[Adding alternative /usr/bin/clang-${VERSION} ...]${RESET}"
        echo "Master command: clang-${VERSION}"
        echo "Slave commands: ${alternative_cmds[*]}"

        eval "$install_command"

        # Check eval command's return value
        if [[ $? -eq 0 ]]; then
            echo "${BOLD}${GREEN}[Adding alternative /usr/bin/clang-${VERSION}: succeeded]${RESET}"
        else
            echo "${BOLD}${RED}[Adding alternative /usr/bin/clang-${VERSION}: failed]${RESET}"
        fi

        echo ""
    else
        # Remove specific alternative configuration if /lib/llvm-${VERSION} directory does not exist
        sudo update-alternatives --remove clang "/usr/bin/clang-${VERSION}" &> /dev/null
    fi
done

clang_path=$(sudo update-alternatives --get-selections | grep ^clang | awk '{print $NF}')

echo "======================================================================"
echo "${GREEN}clang alternative is set to: ${clang_path}${RESET}"
echo "======================================================================"
clang++ --version

# print helps
echo ""
echo "Info:"
num_versions=${#VERSIONS[@]}
if [[ num_versions -gt 1 ]]; then
    echo "  use '${GREEN}sudo update-alternatives --config clang${RESET}' to change default clang alternative"
fi
echo "  use '${GREEN}sudo update-alternatives --remove clang /usr/bin/clang-*${RESET}' to delete a clang alternative"
echo "  use '${GREEN}sudo update-alternatives --remove-all clang${RESET}' to delete all clang alternatives"

