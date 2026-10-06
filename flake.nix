{
  description = "NixOs from Scratch Z4un adventuring";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    specialArgs = { dotfiles = "${self}/config"; };

    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/${hostname}/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;
            users.z4un = import ./home/z4un/default.nix;
          };
        }
      ];
    };
  in {
    nixosConfigurations.nixos-btw = mkHost "nixos-btw";
  };
}
