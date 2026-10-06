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

    settingsFile =
      let fromEnv = builtins.getEnv "DOTFILES_SETTINGS";
      in if fromEnv != "" then fromEnv
        else if builtins.pathExists ./settings.nix then ./settings.nix
        else ./settings.example.nix;

    settings = import settingsFile;

    specialArgs = {
      dotfiles = "${self}/config";
      inherit settings;
    };

    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/default.nix
        ./hosts/${hostname}/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;
            users.${settings.username} = import ./home/default.nix;
          };
        }
      ];
    };
  in {
    nixosConfigurations.${settings.hostname} = mkHost settings.hostname;
  };
}
