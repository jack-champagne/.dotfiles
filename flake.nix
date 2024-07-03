{
  description = "Jack's system configuration!";
  # Nearly all taken from @librephoenix
  # See here: https://librephoenix.com/2024-02-10-using-both-stable-and-unstable-packages-on-nixos-at-the-same-time

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { 
        inherit system; 
        config = { 
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "discord"
            "vscode"
            "slack"
            "spotify"
            "obsidian"
          ];
        }; 
      };
    in {
      nixosConfigurations = {
        nixbox = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
        jack = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./jack/home.nix ];
        };
      };
    };
}
