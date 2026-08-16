{ config, pkgs, ... }: 

let 
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path; 
  configs = {
    qtile = "qtile"; 
    nvim = "nvim";
    rofi = "rofi";
  };
in

{
	home.username = "z4un"; 
	home.homeDirectory = "/home/z4un";
	home.stateVersion = "26.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = " echo I use nixos, btw";
		}; 
	};

  programs.git = {
    enable = true;
    userName = "Med-Fedi-Adel";
    userEmail = "mohamedfedi.adel@insat.ucar.tn";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

	home.packages = with pkgs; [
		neovim
			ripgrep
			nil
			nixpkgs-fmt
			nodejs
			gcc
      rofi
	];
}

