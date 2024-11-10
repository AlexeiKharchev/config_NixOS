# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
#  inputs,
#  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./boot-configuration.nix
    ./hardware-configuration.nix

    <home-manager/nixos>
  ];

  nixpkgs = {
    # You can add overlays here
    #overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
     # outputs.overlays.additions
     # outputs.overlays.modifications
     # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
     #];
    config = {
      allowUnfree = true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];

      firefox = {
      # jre = false;
       enableGoogleTalkPlugin = true;
       enableAdobeFlash = true;
      };

     # chromium = {
     #  jre = false;
     #  enableGoogleTalkPlugin = true;
     #  enableAdobeFlash = true;
     # };
    };

  };

#  nix = let
#    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
#  in {
      # Opinionated: make flake registry and nix path match flake inputs
#      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
#      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
#  };
  nix = {
    useChroot = true;  # build packages in chroot
    settings = {
      # auto-optimize-store = true;

      # Enable flakes and new 'nix' command
      experimental-features = [ "nix-command" "flakes" ];

     # trustedBinaryCaches = [ "http://hydra.nixos.org/" ];

      # Opinionated: disable channels
     # channel.enable = false;

      # Opinionated: disable global registry
     # flake-registry = "";

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Irkutsk";

  # Configure network proxy if necessary
  # ;networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n = {
     defaultLocale = "en_US.UTF-8";
  #   extraLocaleSettings = {
  #     LC_ = "";
  #   };
     supportedLocales = [
       "C.UTF-8/UTF-8"
       "en_US.UTF-8/UTF-8"
       "ru_RU.UTF-8/UTF-8"
     ];
   };
  #
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services = {    
    # nixosManual.showManual = true;  # Add the NixOS Manual on virtual console 8
    ntp.enable = true;

   # printing.enable = true;
   # postgresql.enable = true;
   # postgresql.package = pkgs.postgresql92;

    # Enable the X11 windowing system.
    # Configure keymap in X11
    xserver = {
      enable = true;
     # xkbModel = "thinkpad60";
      libinput.enable = true;
      displayManager.lightdm.enable = true;
      desktopManager = {
        cinnamon.enable = true;
        };
      displayManager.defaultSession = "cinnamon";
  #  ;xkb = {
  #    layout = "us";
  #    options = "eurosign:e,caps:escape";
  #    };
    };
    displayManager.autoLogin = {
      enable = true;
      user = "alex"; 
    };

  };

  networking = { # Pick only one of the below networking options.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    hostName = "MyHost"; # Define your hostname.
    wireless = { # Enables wireless support via wpa_supplicant.
      enable = false;
      networks = {
        };
      };
      extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
      userControlled.enable = true;
    };
  };
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

   # users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.alex = {
    # name = "alex";
    # group = "alex";
    # uid = 499;
     isNormalUser = true;
     # Enable ‘sudo’ for the user.
     extraGroups = [ "wheel" ];  # "vboxusers" "networkmanager"
    # createHome = true;
    # home = "/home/alex";
     packages = with pkgs; [
       firefox
  #     tree
     ];
   # shell = "/run/current-system/sw/bin/bash";
   };
  # users.extraGroups.alex = {
  #  gid = 498;
  # };

  home-manager.users.alex = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  documentation.dev.enable = true;

  #environment = {
  #  profiles = [ ];
  #  shellInit = ""; # script before shell will start
  #  shells = [ pkgs.bashInteractive pkgs.zsh ] ;
  #  shellAliases = {
  #     chconf = "sudo xed /etc/nixos/configuration.nix";
  #    ll = "ls -l";
  #  };
  #  wordlist = {
  #    enable = true;
  #    lists = {
  #      WORDLIST = [ "list.txt" ];
  #    };
  #  };
  #};
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
   # xorg.libXxf86vm - because I cannot start sudo xed configuration.nix
    xcalib

    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    emacs

    doublecmd mc
    tree

    wget curl
    gnupg
    p7zip unzip unrar

    sqlite

    # --------------------------------------- postgresql
   # pgadmin

    rmlint # Extremely fast tool to remove duplicates and ...

    # browsers
    links2
    firefox google-chrome w3m # chromium

    viber

    # -------------------------------------- development
    git

    perl
    nodejs_22

    libevent

   # subversion
   # mercurial
   # gitFull
   # gitAndTools.tig

    vscode
    nodePackages.jshint
    #nodePackages.ungit
    #phantomjs

    # -------------------------------------- python stuff
   # pypy
   # cython
   # python27Full python26Full
   # python33
   # python32
   # pythonPackages.virtualenv
   # pythonPackages.flake8
   # pythonPackages.pillow
   # pythonPackages.mrbob
   # pythonPackages.bpython

   # sys tools
   # extundelete
   # hdparm
   # aircrackng
   # tmux
   # nmap
   # ncdu
   # telnet
   # psmisc
   ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
