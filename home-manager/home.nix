{ config, pkgs, ... }:
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


  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [

      lazy-nvim
      vim-nix
      telescope-file-browser-nvim
      mason-nvim
      mason-lspconfig-nvim
      nvim-lspconfig
      luasnip
      nvim-cmp
      cmp_luasnip

      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugins/lualine.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugins/telescope.lua;
      }

      {
        plugin = which-key-nvim;
        #config = toLuaFile ./nvim/plugins/which-key.lua;
      }

      #{
        #plugin = neorg;
        #config = toLuaFile ./nvim/plugins/neorg.lua;
      #}

      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin";
      }

      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
          p.tree-sitter-rust
        ]));
        #config = toLuaFile ./nvim/plugins/treesiter.lua;
      }
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
    '';

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
