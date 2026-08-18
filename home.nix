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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      btw = " echo I use nixos, btw";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format = ''
        ╭─ $directory$git_branch$git_status$nix_shell$python$nodejs$rust
        ╰─$character
        '';

      directory = {
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = false;
        read_only = " 󰌾";
      };

      git_branch = {
        symbol = "  ";
        style = "bold mauve";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style)) ";
        conflicted = "󰀨 ";
        ahead = "󰁝 $count ";
        behind = "󰁍 $count ";
        diverged = "󰹹 ";
        untracked = "󰋗 ";
        stashed = "󰏗 ";
        modified = "󰏫 ";
        staged = "󰐗 ";
        renamed = "󰁕 ";
        deleted = "󰆴 ";
      };

      nix_shell = {
        symbol = "󱄅 ";
        style = "bold cyan";
        format = "[$symbol$name]($style) ";
      };

      python = {
        symbol = "󰌠 ";
        style = "bold yellow";
        format = "[$symbol$pyenv_prefix$version]($style) ";
      };

      nodejs = {
        symbol = "󰎙 ";
        style = "bold green";
        format = "[$symbol$version]($style) ";
      };

      rust = {
        symbol = "󱘗 ";
        style = "bold red";
        format = "[$symbol$version]($style) ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration](bold yellow) ";
      };

      username = {
        disabled = true;
      };

      hostname = {
        disabled = true;
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "Catppuccin Mocha";

      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;

      background-opacity = 0.94;

      window-padding-x = 12;
      window-padding-y = 10;

      cursor-style = "bar";
      cursor-style-blink = true;

      confirm-close-surface = false;

      shell-integration-features = "cursor,sudo,title";
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
      lazygit
  ];
}

