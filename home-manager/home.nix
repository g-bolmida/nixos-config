{ config, pkgs, ... }:

{
  home.username = "gbolmida";
  home.homeDirectory = "/home/gbolmida";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Development Tools
    git
    jq
    pre-commit
    gnumake
    vscode
    nano
    wget
    conda
    python313Packages.huggingface-hub

    # Container & Kubernetes
    kubectl
    k9s
    docker-compose
    tilt

    # System Utilities
    htop
    neofetch

    # Office & Productivity
    libreoffice
    hugo

    # Internet & Network
    ungoogled-chromium
    protonvpn-gui
    tidal-hifi
    deluge

    # Communication
    discord-ptb

    # Gaming & Gaming Tools
    lutris
    bottles
    mangohud
    gamescope
    prismlauncher
    protonup-ng
    protontricks
    steamtinkerlaunch
    lsfg-vk
    lsfg-vk-ui

    # Media
    vlc
    orca-slicer

    # Hardware & Utilities
    android-tools
    rpi-imager
    claude-code
    redisinsight
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "/home/user/.steam/root/compatibilitytools.d";
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    
    # NVIDIA Shader Cache - Increased for Stalker 2
    __GL_SHADER_DISK_CACHE_SIZE = "5097152"; # 2GB in MB
    __GL_SHADER_DISK_CACHE_PATH = "/home/gbolmida/.cache/nvidia-shader-cache";
  };
}