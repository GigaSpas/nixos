require("mason").setup()
require("mason-lspconfig").setup({
ensure_installed = {'lua_ls', 'rust_analyzer'}
})
require("lspconfig").lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  }
}
require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup {}

