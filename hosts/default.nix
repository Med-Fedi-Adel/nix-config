{ settings, pkgs, ... }:

{
  imports = [
    ../modules/system/common.nix
    ../modules/system/desktop.nix
    ../modules/system/dev.nix
  ];

  networking.hostName = settings.hostname;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.${settings.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ tree ];
  };
}
