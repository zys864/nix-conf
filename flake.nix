{
  description = "My Personal NixOS  Flake Configuration";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

      home-manager = { # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixgl.url = "github:guibou/nixGL"; # OpenGL

      #     nurpkgs = {                                                           # Nix User Packages
      #       url = github:nix-community/NUR;
      #       inputs.nixpkgs.follows = "nixpkgs";
      #     };
    };

  outputs = inputs@{ self, nixpkgs, home-manager, nixgl, ...
    }: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      user = "page";
      location = "$HOME/.setup";
      # Use above variables in ...
    in {
      nixosConfigurations = ( # NixOS configurations
        import ./hosts { # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user
            location; # Also inherit home-manager so it does not need to be defined here.
        });
    };
}
