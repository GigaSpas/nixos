{ config, pkgs, nixvim, ... }:
{
  imports = [
  	./nvim.nix
	./starship.nix
  ];

  home.username = "spas";
  home.homeDirectory = "/home/spas";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.rustup
    pkgs.lua
  ];

  home.file.".config/qtile" = {
    source = ./qtile;
    recursive = true;
    #onChange = home-manager switch;
  };

  programs.nushell = {
    enable = true;
    environmentVariables = {
      EDITOR = "nvim";
    };
    extraConfig = ''
      ${builtins.readFile ./nushell/config.nu}
      '';
    extraEnv = ''
      ${builtins.readFile ./nushell/env.nu}
      '';
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ./kitty/kitty.conf}
      '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
