{ config, pkgs, ... }:

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
    initrd.luks.devices."luks-3de39b16-319c-4aad-a741-459caabd76de".device = "/dev/disk/by-uuid/3de39b16-319c-4aad-a741-459caabd76de";
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
    };
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
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
  hardware.pulseaudio.enable = false;
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  # Security configuration
  security.rtkit.enable = true;

  # User account configuration
  users.users.lukecollins = {
    isNormalUser = true;
    description = "Luke Collins";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Program configuration
  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim git gh alacritty wget docker nodejs python3 python3Packages.pip zellij pet
    shfmt postgresql docker-compose tailscale gcc direnv neofetch nodePackages.pyright
    nil nodePackages.bash-language-server zoom-us dockerfile-language-server-nodejs
    terraform-ls clippy awscli2 typst yarn fzf spotify yaml-language-server nerdfonts
    google-chrome
    # Install emacs with packages
    (emacsWithPackagesFromUsePackage {
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
        epkgs.flycheck epkgs.lsp-pyright epkgs.csv-mode
      ];
    })
  ];

  # Emacs overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
      sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
    }))
  ];

  system.stateVersion = "23.11";
}
