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
  # Home Manager configuration
  home = {
    stateVersion = "23.05";  # Replace with the desired Home Manager state version

    username = "lukecollins";    # Replace with your actual username
    homeDirectory = "/home/lukecollins";  # Replace with the path to your home directory

    packages = [
      myPythonEnv pkgs.home-manager
    ];

    # Configuration files
    file = {
      ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
      ".zshrc".source = ./dotfiles/.zshrc;
      ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
      ".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
      ".config/zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
      "/powerlevel10k".source = powerlevel10kSrc;
    };
  };
  # XDG Desktop Entry for Emacs
  xdg.desktopEntries.emacs = {
    name = "Emacs";
    genericName = "Editor";
    exec = "emacsclient -c";
    icon = "emacs";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };
}
