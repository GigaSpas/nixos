{ config, pkgs, nixvim, ... }:
{
  imports = [
    ./starship/starship.nix
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


  programs.nixvim = {
	  enable = true;

	  colorschemes.catppuccin.enable = true;

	  plugins = {
		  lualine.enable = true;

		  lsp = {
			  enable = true;
			  servers = {
				rust-analyzer = {
				  enable = true;
				  installCargo = true;
				  installRustc= true;
				  };

				  lua-ls.enable = true;
				  nixd.enable = true;
			  };
		  };
	  };
	  options = {
		number = true;
		relativenumber = true;
		tabstop = 2;
		shiftwidth = 2;
		shiftround = true;
		expandtab = true;

		showcmd = true;
		laststatus = true;
		cursorline = true;

		autoindent = true;
		autoread = true;
		autowrite = true;

	  };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
