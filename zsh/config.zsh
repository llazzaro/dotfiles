# Platform detection
detect_platform() {
    local _uname
    _uname="$(uname)"
    if [[ "$_uname" == 'Linux' ]]; then
        export LINUX=1
        export GNU_USERLAND=1
        export OSX=0
    elif [[ "$_uname" == 'Darwin' ]]; then
        export OSX=1
        export LINUX=0
        export GNU_USERLAND=0
    else
        export LINUX=0
        export OSX=0
        export GNU_USERLAND=0
    fi
}

# Platform-specific configuration
setup_platform_config() {
    if [[ "$LINUX" == "1" ]]; then
        local _cpus
        _cpus="$(command -v nproc >/dev/null 2>&1 && nproc || grep -c processor /proc/cpuinfo)"
        export MAKEFLAGS="-j${_cpus}"
        export PROJECT_HOME=$HOME/Devel
    fi
}

# Development tools setup
setup_dev_tools() {
    # Common exports
    export LANG=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export EDITOR=vim
    export TERM=xterm-256color
    [ -n "$TMUX" ] && export TERM=screen-256color

    # PATH additions
    export PATH=$PATH:~/.local/bin:/opt/homebrew/bin
    export PATH="$HOME/.rbenv/bin:$HOME/opt/vim/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"

    # Ansible
    export ANSIBLE_CONFIG=~/.ansible/ansible.cfg
    export ANSIBLE_HOSTS=~/.ansible/hosts

    # Go
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

    # RVM
    export PATH=$PATH:$HOME/.rvm/bin
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # rbenv (lazy loaded)
    if command -v rbenv >/dev/null 2>&1; then
        rbenv() {
            unfunction rbenv
            eval "$(command rbenv init -)"
            rbenv "$@"
        }
    fi

    # uv Python package manager (cached completion)
    if command -v uv >/dev/null 2>&1; then
        _uv_comp_cache="${HOME}/.zsh_cache/_uv"
        if [[ ! -f "$_uv_comp_cache" ]] || [[ "$(command -v uv)" -nt "$_uv_comp_cache" ]]; then
            mkdir -p "${HOME}/.zsh_cache"
            uv generate-shell-completion zsh > "$_uv_comp_cache"
        fi
        source "$_uv_comp_cache"
    fi

    # NVM (lazy loaded)
    NVM_SOURCE=$HOME/.nvm/nvm.sh
    if [[ -f "$NVM_SOURCE" ]]; then
        lazy_source nvm $NVM_SOURCE
    fi
}

# Initialize all configurations
init_dotfiles_config() {
    detect_platform
    setup_platform_config
    setup_dev_tools
}
