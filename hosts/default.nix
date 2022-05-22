{ lib, inputs, nixpkgs, home-manager, user, location, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in {
  laptop = lib.nixosSystem { # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location; }; # Pass flake variable
    modules = [ # Modules that are used.
      ./matebook
      ./configuration.nix
      

      home-manager.nixosModules.home-manager
      { # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; }; # Pass flake variable
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ] ++ [ (import ./matebook/home.nix) ];
        };
      }
    ];
  };
}
