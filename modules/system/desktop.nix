{ settings, ... }:

{
  networking.networkmanager.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    xkb = {
      layout = settings.keyboardLayout;
      variant = "";
    };
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  systemd.oomd = {
    enable = true;
    enableUserServices = true;
  };

  programs.firefox.enable = true;
}
