{inputs, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    package = inputs.neovim-overlay.packages.${pkgs.system}.default;

    globals = {
    mapleader = " ";
    };

    colorschemes.nord.enable = true;

    plugins = {
      lualine.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      telescope.extensions.file-browser.enable = true;
      luasnip.enable = true;
      friendly-snippets.enable = true;

      neorg = {
        enable = true;
        modules = {
          "core.defaults" = {
            __empty = null;
          };
          "core.concealer" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                notes = "~/Documents/notes/";
              };
            };
          };
        };
      };

      treesitter = {
        enable = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          lua
            bash
            rust
            nix
            python
        ];
      };

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

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      shiftround = true;
      expandtab = true;

      showcmd = true;
      laststatus = 2;
      cursorline = true;

      autoindent = true;
      autoread = true;
      autowrite = true;
    };

    keymaps = [

    {
      action = ":nohlsearch<CR>";
      key = "<leader>h";
      options = {
        silent = true;
      };
    }

    {
      action = ":Telescope find_files<CR>";
      key = "<leader>tf";
      options = {
        silent = true;
      };
    }

    {
      action = ":Telescope grep<CR>";
      key = "<leader>tg";
      options = {
        silent = true;
      };
    }

    {
      action = ":Telescope file_browser<CR>";
      key = "<leader>tB";
      options = {
        silent = true;
      };
    }

    {
      action = ":Telescope buffers<CR>";
      key = "<leader>tb";
      options = {
        silent = true;
      };
    }

    ];
  };
}
