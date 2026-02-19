# NixOS Configuration for Christopher Chan
# Generated from dotfiles analysis
#
# Usage:
#   1. Copy this to /etc/nixos/configuration.nix on your NixOS machine
#   2. Adjust hardware-configuration.nix import path if needed
#   3. Run: sudo nixos-rebuild switch
#
# This configuration sets up:
#   - i3 window manager with gaps
#   - ZSH with vi mode
#   - Neovim as default editor
#   - Development tools (Python, Go, Rust)
#   - Your preferred terminal and utilities

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # BOOT & KERNEL
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # NETWORKING
  # ============================================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ============================================================================
  # LOCALE & TIME
  # ============================================================================
  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # ============================================================================
  # USERS
  # ============================================================================
  users.users.chris = {
    isNormalUser = true;
    description = "Christopher Chan";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.zsh;
  };

  # ============================================================================
  # DISPLAY SERVER & WINDOW MANAGER
  # ============================================================================
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    # i3 window manager
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
        rofi
        dunst
        feh
        picom
        xclip
        xsel
        maim
        xdotool
      ];
    };

    # Display manager
    displayManager.lightdm.enable = true;
  };

  # ============================================================================
  # AUDIO
  # ============================================================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================================================
  # FONTS
  # ============================================================================
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # ============================================================================
  # SHELL - ZSH
  # ============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000000;
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    curl
    wget
    unzip
    zip
    ripgrep
    fd
    tree
    htop
    btop
    lsd
    bat
    fzf
    jq
    yq

    # Terminal & Shell
    ghostty         # Primary terminal
    kitty           # Backup terminal
    tmux
    zoxide
    starship

    # File management
    yazi
    lf
    ranger

    # Editor
    neovim

    # Development - Languages
    python311
    python311Packages.pip
    python311Packages.virtualenv
    go
    rustup
    nodejs_20
    lua
    luajit

    # Development - Tools
    gcc
    gnumake
    cmake
    pkg-config

    # Language servers & formatters (for neovim)
    pyright
    gopls
    lua-language-server
    stylua
    black
    isort
    nodePackages.prettier
    shellcheck
    shfmt

    # Git tools
    gh
    lazygit
    delta

    # Cloud & DevOps
    docker-compose
    kubectl
    google-cloud-sdk
    terraform

    # Database
    postgresql
    pgcli

    # Data science
    R

    # System monitoring
    ncdu
    duf
    procs

    # Networking
    nmap
    inetutils

    # Clipboard
    wl-clipboard  # For wayland if needed
    xclip
    xsel
  ];

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  # ============================================================================
  # SERVICES
  # ============================================================================
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Printing
  services.printing.enable = true;

  # ============================================================================
  # ENVIRONMENT VARIABLES (XDG)
  # ============================================================================
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "firefox";

    # Rust
    CARGO_HOME = "$HOME/.local/share/cargo";
    RUSTUP_HOME = "$HOME/.local/share/rustup";

    # Go
    GOPATH = "$HOME/.local/share/go";
    GOMODCACHE = "$HOME/.cache/go/mod";
  };

  environment.shellAliases = {
    v = "nvim";
    vim = "nvim";
    ls = "lsd";
    ll = "lsd -l";
    la = "lsd -la";
    lt = "lsd --tree";
    cat = "bat";
    grep = "rg";
    find = "fd";
    top = "btop";
    ".." = "cd ..";
    "..." = "cd ../..";
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline --graph";
    gd = "git diff";
  };

  # ============================================================================
  # SECURITY
  # ============================================================================
  security.sudo.wheelNeedsPassword = true;

  # Allow unfree packages (for some fonts, drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # NIX SETTINGS
  # ============================================================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ============================================================================
  # SYSTEM STATE VERSION
  # ============================================================================
  # This determines the NixOS release compatibility
  # Change this only after reading the release notes
  system.stateVersion = "24.11";
}
