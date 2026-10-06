{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # editor & shell tools
    neovim
    ripgrep
    lazygit
    btop
    rofi
    openssl
    code-cursor

    # nix / rust toolchain
    nil
    nixpkgs-fmt
    alejandra
    nodejs
    gcc
    rustup

    # debugging
    lldb

    # language servers (used by config/nvim/plugin/lsp.lua)
    lua-language-server
    clang-tools
    gopls
    zls
    typescript-language-server
    vscode-langservers-extracted
    intelephense
    awscli2
  ];
}
