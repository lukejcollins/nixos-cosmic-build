{ pkgs, ... }:

let
  # Python Environment Definition
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim flake8 pylint black requests grip ratelimit typing unidecode
  ]);

  # Powerlevel10k Installation Definition
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

in
  {
    home.stateVersion = "24.05";  # Replace with the desired Home Manager state version

    home.username = "lukecollins";    # Replace with your actual username
    home.homeDirectory = "/home/lukecollins";  # Replace with the path to your home directory

    home.packages = [
      myPythonEnv pkgs.home-manager
    ];

    # Set the file locations for the configuration files
    home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    home.file.".zshrc".source = ./dotfiles/.zshrc;
    home.file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    home.file.".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
    home.file.".config/zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
    home.file."/powerlevel10k".source = powerlevel10kSrc;  
  }
