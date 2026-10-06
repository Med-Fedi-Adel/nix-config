{ pkgs, ... }:

{
  time.timeZone = "Africa/Tunis";

  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ bash zsh ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
