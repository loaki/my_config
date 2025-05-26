#!/bin/bash

declare -A osInfo;
osInfo[/etc/debian_version]=apt-get

for f in "${!osInfo[@]}"; do
    if [[ -f $f ]]; then
        package_manager=${osInfo[$f]}
        echo "Detected package manager: $package_manager"
        break
    fi
done

if [[ -z $package_manager ]]; then
    echo "No supported package manager detected."
    exit 1
fi

if [[ ! -f packages.txt ]]; then
    echo "packages.txt not found."
    exit 1
fi

packages=($(cat packages.txt))
total_packages=${#packages[@]}

print_error() {
    echo -e "\e[31m[✘]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[✔]\e[0m $1"
}

update_progress() {
    local success=$1
    local package=$2
    local current=$3
    local total=$4
    local progress=$((current * 100 / total))
    local bar=$(printf '=%.0s' $(seq 1 $((progress / 2))))
    local spaces=$(printf ' %.0s' $(seq 1 $((50 - progress / 2))))

    echo -ne "\033[$(tput lines);0H"
    echo -ne "\033[K"
    if [[ $success -eq 0 ]]; then
        echo -e "\e[32m[✔]\e[0m $2"
    else
        echo -e "\e[31m[✘]\e[0m $2"
    fi
    printf "Progress: [%-50s] %d%%" "$bar$spaces" "$progress"
}

install_packages() {
    local cmd="$1"
    shift
    local packages=("$@")
    local total=${#packages[@]}
    local current=0

    for package in "${packages[@]}"; do
        ((current++))
        sudo $cmd "$package" > /dev/null 2>&1
        update_progress $? $package $current $total
    done
    echo
    echo "Package installation process completed."
}


sudo apt-get update > /dev/null 2>&1
install_packages "apt-get install -y" "${packages[@]}"

sudo usermod -aG video $USER
