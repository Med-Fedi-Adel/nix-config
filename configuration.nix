{ config, lib, pkgs, ... }:

{
  imports =
    [ 
    ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw"; # Define your hostname.

# Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

  time.timeZone = "Africa/Tunis";

  i18n.defaultLocale = "fr_FR.UTF-8";

  console.keyMap = "fr";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

# Enable the X11 windowing system.
# services.xserver.enable = true;
  services.xserver = {
    xkb = {
      layout = "fr";
      variant = ""; # Leave empty for standard AZERTY, or use "latin9" etc.
    };
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

# Kill memory-hogging apps (e.g. Firefox) before the system locks up
  systemd.oomd = {
    enable = true;
    enableUserServices = true;
  };

# Configure keymap in X11
# services.xserver.xkb.layout = "us";
# services.xserver.xkb.options = "eurosign:e,caps:escape";

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
# services.pulseaudio.enable = true;
# OR
# services.pipewire = {
#   enable = true;
#   pulse.enable = true;
# };

# Enable touchpad support (enabled default in most desktopManager).
# services.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.z4un = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
      tree
      ];
  };

  programs.firefox.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vim 
      wget
      git
      gnumake
  ];

  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    bash
      zsh
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      glib          # libgobject-2.0, libglib-2.0, libgio-2.0
        nss           # libnss3, libnssutil3, libsmime3
        nspr          # libnspr4
        atk           # libatk-1.0
        at-spi2-atk   # libatk-bridge-2.0
        at-spi2-core  # libatspi
        cups.lib      # libcups
        dbus          # libdbus-1
        libdrm        # libdrm
        gtk3          # libgtk-3
        pango         # libpango-1.0
        cairo         # libcairo
        xorg.libX11         # libX11
        xorg.libXcomposite  # libXcomposite
        xorg.libXdamage     # libXdamage
        xorg.libXext        # libXext
        xorg.libXfixes      # libXfixes
        xorg.libXrandr      # libXrandr
        xorg.libxcb         # libxcb
        mesa          # libgbm
        expat         # libexpat
        libxkbcommon  # libxkbcommon
        alsa-lib      # libasound
        ];
  };

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

