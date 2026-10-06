{ ... }:

{
  imports = [
    ../../modules/home/shell.nix
    ../../modules/home/dev-tools.nix
    ../../modules/home/dotfiles.nix
  ];

  home.username = "z4un";
  home.homeDirectory = "/home/z4un";
  home.stateVersion = "26.05";
}
