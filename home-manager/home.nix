{ config, pkgs, ... }:

{
  home.username = "gbolmida";
  home.homeDirectory = "/home/gbolmida";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Development Tools
    git
    git-lfs
    jq
    pre-commit
    gnumake
    vscode
    nano
    wget
    fnm
    conda
    terraform
    python313Packages.huggingface-hub
    (godotPackages_4_6.godot)

    # Container & Kubernetes
    kubectl
    k9s
    docker-compose
    tilt

    # System Utilities
    htop
    restic
    redu
    rustdesk
    kdePackages.ksshaskpass

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
    audacity
    blender
    blockbench
    gimp
    inkscape
    orca-slicer
    darktable

    # Hardware & Utilities
    android-tools
    rpi-imager
    claude-code
    redisinsight
    ncdu
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "/home/user/.steam/root/compatibilitytools.d";
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    
    # NVIDIA Shader Cache - Increased for Stalker 2
    __GL_SHADER_DISK_CACHE_SIZE = "5097152"; # 2GB in MB
    __GL_SHADER_DISK_CACHE_PATH = "/home/gbolmida/.cache/nvidia-shader-cache";
  };

  # FNM (Fast Node Manager) Configuration
  programs.bash.enable = true;
  programs.bash.initExtra = ''
    eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd)"
  '';

}