{ config, pkgs, ... }:

let
  secrets = import ./configuration-secrets.nix;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Boot & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # This is busted atm
  #systemd.sleep.settings.Sleep = ''
  #  AllowSuspend=no
  #  AllowHibernation=no
  #  AllowHybridSleep=no
  #  AllowSuspendThenHibernate=no
  #'';

  # Networking
  networking.hostName = "geo-nix";
  networking.networkmanager.enable = true;
  networking.firewall.allowedUDPPorts = [ 27036 27037 ];
  services.openssh.enable = true;

  # Time & Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Hardware - Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ libva-vdpau-driver libva ];
  };

  # Hardware - NVIDIA
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Hardware - Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Hardware - Printing
  services.printing.enable = true;

  # Display & Desktop Environment
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Users
  users.users.gbolmida = {
    isNormalUser = true;
    description = "George Bolmida";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
  };

  # Programs
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };


  # Docker w/ NVIDIA Container Toolkit
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      runtimes = {
        nvidia = {
          path = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime";
          runtimeArgs = [];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker
  ];

  hardware.nvidia-container-toolkit.enable = true;

  # System Services
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [ "phi4-reasoning:14b" ];
  };

  services.flatpak.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
     fnm
  ];

  services.teleport = {
    enable = true;
    package = pkgs.teleport_18;
    settings = {
      version = "v3";
      teleport = {
        nodename = "nixos-desktop";
        data_dir = "/var/lib/teleport";
        join_params = {
          token_name = secrets.teleport.token_name;
          method = "token";
        };
        proxy_server = secrets.teleport.proxy_server;
        log = {
          output = "stderr";
          severity = "INFO";
          format = {
            output = "text";
          };
        };
        ca_pin = "";
        diag_addr = "";
      };
      auth_service = {
        enabled = "no";
      };
      ssh_service = {
        enabled = "yes";
        listen_addr = "127.0.0.1:3022";
        labels = {
          hostname = "nixos-desktop";
        };
      };
      proxy_service = {
        enabled = "no";
        https_keypairs = [];
        https_keypairs_reload_interval = "0s";
        acme = {};
      };
      app_service = {
        enabled = "no";
      };
    };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # Storage
  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-uuid/fbdf6a62-a5ee-48cd-8687-242a9eb22b6b";
    fsType = "ext4";
  };

  # Auto Cleanup
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;

  boot.tmp.cleanOnBoot = true;

  system.stateVersion = "25.05";
}