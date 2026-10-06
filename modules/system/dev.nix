{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gnumake
    steam-run
    dart
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glib
      nss
      nspr
      atk
      at-spi2-atk
      at-spi2-core
      cups.lib
      dbus
      libdrm
      gtk3
      pango
      cairo
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libxcb
      mesa
      expat
      libxkbcommon
      alsa-lib
      libgbm
    ];
  };
}
