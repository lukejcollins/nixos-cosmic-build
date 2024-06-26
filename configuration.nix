{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader and boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_9;
  };

  # Networking configuration
  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Timezone configuration
  time.timeZone = "Europe/London";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };
  
  # Services configuration
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      #displayManager.gdm.enable = true;
      #desktopManager.gnome.enable = true;
    };
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    emacs = {
      enable = true;
      startWithGraphical = true;
      defaultEditor = true;
      package = pkgs.emacsWithPackagesFromUsePackage {
        config = ./emacs/init.el;
        defaultInitFile = true;
        alwaysEnsure = true;
        alwaysTangle = true;
        extraEmacsPackages = epkgs: [
          epkgs.use-package epkgs.terraform-mode epkgs.flycheck epkgs.flycheck-inline
          epkgs.dockerfile-mode epkgs.nix-mode epkgs.treemacs epkgs.markdown-mode
          epkgs.treemacs-all-the-icons epkgs.helm epkgs.vterm epkgs.markdown-mode
          epkgs.grip-mode epkgs.dash epkgs.s epkgs.editorconfig epkgs.autothemer
          epkgs.rust-mode epkgs.lsp-mode epkgs.dashboard epkgs.direnv epkgs.projectile
          epkgs.nerd-icons epkgs.doom-modeline epkgs.grip-mode epkgs.company
          epkgs.elfeed epkgs.elfeed-protocol epkgs.catppuccin-theme epkgs.yaml-mode
          epkgs.flycheck epkgs.lsp-pyright epkgs.csv-mode epkgs.persistent-scratch
        ];
      };
    };
    fwupd.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tailscale.enable = true;
  };

  # Sound configuration
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    #ipu6 = {
    #  enable = true;
    #  platform = "ipu6ep";
    #};
  };

  # Security configuration
  security.rtkit.enable = true;

  # User account configuration
  users.users.lukecollins = {
    isNormalUser = true;
    description = "Luke Collins";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Program configuration
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim git gh alacritty wget nodejs python3 python3Packages.pip zellij pet
    shfmt postgresql docker-compose tailscale gcc direnv neofetch pyright
    nil bash-language-server zoom-us dockerfile-language-server-nodejs
    terraform-ls clippy awscli2 typst yarn fzf spotify yaml-language-server 
    google-chrome zip unzip btop libfido2
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # Nixpkgs config
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
        sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
      }))
    ];
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
