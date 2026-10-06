{ settings, ... }:

{
  imports = [
    ../modules/home/shell.nix
    ../modules/home/dev-tools.nix
    ../modules/home/dotfiles.nix
  ];

  home.username = settings.username;
  home.homeDirectory = "/home/${settings.username}";
  home.stateVersion = settings.stateVersion;
}
