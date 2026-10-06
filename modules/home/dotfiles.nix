{ config, dotfiles, ... }:

let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    rofi = "rofi";
    alacritty = "alacritty";
  };
in
{
  # Do not set recursive = true — it links each file individually and can
  # corrupt the source tree when ~/.config/* resolves to the same directory.
  xdg.configFile = builtins.mapAttrs
    (_name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
    })
    configs;
}
