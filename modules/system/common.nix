{ settings, pkgs, ... }:

{
  time.timeZone = settings.timeZone;

  i18n.defaultLocale = settings.locale;
  console.keyMap = settings.keyboardLayout;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = settings.stateVersion;

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ bash zsh ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
