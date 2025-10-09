-- formatter_linter.lua

-- 1. Setup the formatter (conform.nvim)
require("conform").setup({
  -- Link the formatter "black" to python files
  formatters_by_ft = {
    python = { "black" },
  },

  -- This makes it format your code automatically when you save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- 2. Setup the linter (nvim-lint)
require("lint").linters_by_ft = {
  python = {"ruff"}
}

-- 3. Create an autocommand to run the linter automatically
vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "InsertLeave"}, {
    group = vim.api.nvim_create_augroup("linting", {clear = true}),
    callback = function()
        -- We want to run the linter, but not on every single event.
        -- This function will only run the linter if it hasn't been run in the last 1 second.
        require("lint").try_lint()
    end
})
