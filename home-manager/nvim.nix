{ config, pkgs, nixvim, ... }:
{
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = tr

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
  };
}
