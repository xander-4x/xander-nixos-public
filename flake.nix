{
  description = "NixOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkHost =
        host: username:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username host; };
          modules = [ ./hosts/${host} ];
        };
    in
    {
      nixosConfigurations = {
        "desktop" = mkHost "desktop-host" "desktop-user";
        "server" = mkHost "server-host" "server-user";
      };
    };
}
