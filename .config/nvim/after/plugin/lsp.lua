local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- This function runs whenever a new language server attaches to a file.
  -- It allows us to create keybindings that are local to that file.
  
  local opts = {buffer = bufnr, remap = false, silent = true}

  -- Code Navigation and Information
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)


  -- Code Actions and Formatting
  vim.keymap.set({"n", "v"}, "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
  end, opts)

end)



require('mason').setup({})
require('mason-lspconfig').setup({
  -- This is the list of servers to automatically install
  ensure_installed = {
    'pyright',  -- The best server for Python
    'jsonls',   -- The server for JSON
    'lua_ls',   -- We keep this for configuring Neovim itself
  },
  handlers = {
    lsp_zero.default_setup,
  },
})
