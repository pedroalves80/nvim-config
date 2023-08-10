local null_ls_status, null_ls = pcall(require, 'null-ls')
if not null_ls_status then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier.with({ "--no-semi", "--single-quote", "-jsx-single-quote" }),
    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.stylua,
    diagnostics.flake8
  }
})
