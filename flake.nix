{
  inputs = {
    # Importing the nixpkgs repository from GitHub with the nixos-unstable branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Importing the nixos-cosmic repository from GitHub and linking its nixpkgs input to the above nixpkgs
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Importing the home-manager repository from GitHub and linking its nixpkgs input to the above nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic, home-manager }: {
    nixosConfigurations = {
      # Configuration for mySystem
      mySystem = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            # Nix settings for substituters and trusted-public-keys
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          # Including the default NixOS Cosmic module
          nixos-cosmic.nixosModules.default
          # Including the user's configuration
          ./configuration.nix
          # Including the home-manager NixOS module
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      # Configuration for user lukecollins
      lukecollins = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          {
            # State version and user-specific settings
            home.stateVersion = "24.05"; # Add the appropriate state version
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
        ];
      };
    };
  };
}
