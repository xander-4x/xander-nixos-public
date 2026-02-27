{
  description = "NixOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dgop = {
      url = "github:AvengeMedia/dgop";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    overlay = final: prev: {
      dgop = final.callPackage ./pkgs/dgop.nix { src = inputs.dgop; };
    };

    mkHost = host: username:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs username host;};
        modules = [
          { nixpkgs.overlays = [ overlay ]; }
          ./hosts/${host}
        ];
      };
  in {
    nixosConfigurations = {
      "desktop" = mkHost "desktop" "nixuser";
      "server" = mkHost "server" "nixuser";
    };
  };
}
