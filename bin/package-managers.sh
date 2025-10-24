#!/usr/bin/env bash
#
# Package manager abstraction layer for cross-platform dotfiles installation

# Detect the available package manager
detect_package_manager() {
    case $(uname) in
        Linux)
            export LINUX=1
            if command -v dnf >/dev/null 2>&1; then
                export PACKAGE_MANAGER='dnf'
            elif command -v apt-get >/dev/null 2>&1; then
                export PACKAGE_MANAGER='apt-get'
            elif command -v zypper >/dev/null 2>&1; then
                export PACKAGE_MANAGER='zypper'
            elif command -v pacman >/dev/null 2>&1; then
                export PACKAGE_MANAGER='pacman'
            else
                export PACKAGE_MANAGER='unknown'
            fi
            ;;
        Darwin)
            export DARWIN=1
            if command -v brew >/dev/null 2>&1; then
                export PACKAGE_MANAGER='brew'
            else
                export PACKAGE_MANAGER='unknown'
            fi
            ;;
        *)
            export PACKAGE_MANAGER='unknown'
            ;;
    esac
    echo "Package manager detected: $PACKAGE_MANAGER"
}

# Install basic dependencies
install_basic_deps() {
    echo "Installing basic dependencies with $PACKAGE_MANAGER..."
    
    case "$PACKAGE_MANAGER" in
        dnf)
            sudo dnf update
            sudo dnf install -y git mc htop npm wget zsh ack xclip
            ;;
        apt-get)
            sudo apt-get update
            sudo apt-get install -y zsh git nmap curl tmux iotop htop openssl xclip
            ;;
        brew)
            brew install tmux wget python reattach-to-user-namespace vim zsh
            ;;
        pacman)
            sudo pacman -Sy --noconfirm git zsh tmux htop wget curl xclip
            ;;
        *)
            echo "Unknown package manager. Please install dependencies manually."
            return 1
            ;;
    esac
}

# Install development dependencies
install_dev_deps() {
    echo "Installing development dependencies with $PACKAGE_MANAGER..."
    
    case "$PACKAGE_MANAGER" in
        dnf)
            sudo dnf install -y npm make automake gcc gcc-c++ gpg
            sudo dnf install -y dkms binutils make patch libgomp glibc-headers
            sudo dnf install -y libxslt-devel libxml2-devel nmap libffi-devel
            sudo dnf install -y gitflow subversion ghc ack hg
            ;;
        apt-get)
            sudo apt-get install -y python3-flake8 python3-setuptools python3-dev
            sudo apt-get install -y libxml2-dev libxslt1-dev fontconfig vim
            sudo apt-get install -y make git-core build-essential libffi-dev
            sudo apt-get install -y openssl libssl-dev autoconf automake libtool
            sudo apt-get install -y ack-grep mercurial docker libjpeg8 libfreetype6
            sudo apt-get install -y libfreetype6-dev libreadline-dev
            ;;
        brew)
            brew update
            brew install node doctl kubectx fluxctl helm postgres openssl automake libtool
            brew install kube-ps1 stern openssl readline sqlite3 xz zlib doctl nvim
            brew install derailed/popeye/popeye rbenv
            install_kubectl_macos
            ;;
        pacman)
            sudo pacman -S --noconfirm base-devel git nodejs npm python python-pip
            sudo pacman -S --noconfirm tmux vim neovim docker
            ;;
        *)
            echo "Unknown package manager. Please install development dependencies manually."
            return 1
            ;;
    esac
}

# Install kubectl on macOS
install_kubectl_macos() {
    if ! command -v kubectl >/dev/null 2>&1; then
        echo "Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
        sudo chown root: /usr/local/bin/kubectl
    fi
}

# Check if a package is installed
package_installed() {
    local package="$1"
    case "$PACKAGE_MANAGER" in
        dnf)
            dnf list installed "$package" >/dev/null 2>&1
            ;;
        apt-get)
            dpkg -l "$package" >/dev/null 2>&1
            ;;
        brew)
            brew list "$package" >/dev/null 2>&1
            ;;
        pacman)
            pacman -Q "$package" >/dev/null 2>&1
            ;;
        *)
            return 1
            ;;
    esac
}