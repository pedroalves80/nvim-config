require('neodev').setup()

-- Mason
require('mason').setup({
    ui = {
        icons = {
            package_installed = ' ',
            package_pending = ' ',
            package_uninstalled = ' ',
        },
        border = 'rounded',
    },
})

require('mason-lspconfig').setup({
    ensure_installed = {
        'cssls',
        'emmet_ls',
        'html',
        'intelephense',
        'jdtls',
        'jsonls',
        'ltex',
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'texlab',
        'tsserver',
        'volar',
        'yamlls',
        'eslint',
        'prismals',
    },
})

local function find_project_root(filename)
    local current_dir = vim.fn.expand('%:p:h') -- Get the current directory of the opened file
    while current_dir ~= '/' do
        if vim.fn.filereadable(current_dir .. '/package.json') == 1 or
            vim.fn.filereadable(current_dir .. '/tsconfig.json') == 1 or
            vim.fn.isdirectory(current_dir .. '/.git') == 1 then
            return current_dir
        end
        current_dir = vim.fn.fnamemodify(current_dir, ':h') -- Move up one directory
    end
    return nil
end

-- Lspconfig
local lspconfig = require('lspconfig')
local util = lspconfig.util

require('lspconfig.ui.windows').default_options.border = 'rounded'


-- CMP LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Options with description
local opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
end

-- Keymaps
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts('Open Diagnostic Window'))
vim.keymap.set('n', '<space><left>', vim.diagnostic.goto_prev, opts('Previous Diagnostic'))
vim.keymap.set('n', '<space><right>', vim.diagnostic.goto_next, opts('Next Diagnostic'))
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts('Send Diagnostic to Locallist'))

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        local bufopts = function(desc)
            return { buffer = ev.buf, desc = desc }
        end
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts('Go to Declaration'))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts('Go to Definition'))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts('Hover'))
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts('Go to Implementation'))
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, bufopts('Singature Help'))
        vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts('Go to Reference'))
        vim.keymap.set('n', '<space>fm', function()
            -- if filetype is javascript, typescript, vue, html run eslintfix all, else run lsp format
            if vim.bo.filetype == 'javascript' or vim.bo.filetype == 'typescript' or vim.bo.filetype == 'vue' or vim.bo.filetype == 'html' then
                vim.cmd('EslintFixAll')
            else
                vim.lsp.buf.format(nil)
            end
            --vim.lsp.buf.format({ async = true })
        end, bufopts('Formatting with Eslint'))
    end,
})

local border = {
    { '┌', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '┐', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '┘', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '└', 'FloatBorder' },
    { '│', 'FloatBorder' },
}

-- LSP settings (for overriding per client)
local handlers = {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

-- Diagnostics signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
    },
    float = { border = border },
})

--  ╭──────────────────────────────────────────────────────────╮
--  │                         SERVERS                          │
--  ╰──────────────────────────────────────────────────────────╯
-- Lua server
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                -- enable = true,
                globals = { 'vim', 'use', 'winid' },
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('data') .. '/mason/packages/lua-language-server/libexec/meta/3rd/luv/library'] = true,
                    '${3rd}/luv/library',
                    vim.api.nvim_get_runtime_file('', true),
                    [vim.fn.expand('%:p:h')] = true,
                },
            },
            completion = {
                enable = true,
                callSnippet = 'Both',
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = 'space',
                    indent_size = '4',
                    quote_style = 'single',
                },
            },
            hint = {
                enable = true,
                arrayIndex = 'Disable',
            },
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,

})

-- JavaScript Server
lspconfig.tsserver.setup({
    capabilities = capabilities,
    handlers = handlers,
    init_options = {
        preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            importModuleSpecifierPreference = 'non-relative',
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        on_attach(client, bufnr)
    end,
})

-- Python Server
lspconfig.pyright.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,

})

-- Emmet Server
lspconfig.emmet_ls.setup({
    capabilities = capabilities,
    handlers = handlers,
    filetypes = { 'astro', 'css', 'eruby', 'html', 'htmldjango', 'javascript', 'javascriptreact', 'less', 'pug', 'sass',
        'scss', 'svelte', 'typescriptreact', 'vue' },
})

-- CSS Server
lspconfig.cssls.setup({
    capabilities = capabilities,
    handlers = handlers,
    filetypes = { 'css', 'less', 'scss', 'sass' },
    settings = {
        css = {
            lint = {
                unknownAtRules = 'ignore',
            },
        },
        scss = {
            lint = {
                unknownAtRules = 'ignore',
            },
            validate = true
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,

})

-- Volar Vue Server
lspconfig.volar.setup({
    capabilities = capabilities,
    root_dir = function(filename)
        return find_project_root(filename)
    end,
    handlers = handlers,
    filetypes = {
        'vue', --[[ 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'json' ]]
    },
    init_options = {
        preferences = {
            disableSuggestions = false,
        },
        languageFeatures = {
            implementation = true,
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            diagnostics = true,
        },
        typescript = {
            tsdk = 'node_modules/typescript/lib'
        },
    },
})

-- JSON Server
lspconfig.jsonls.setup({
    capabilities = capabilities,
    handlers = handlers,
    filetypes = { 'json', 'jsonc' },
    init_options = {
        provideFormatter = true,
    },
})

-- HTML Server
lspconfig.html.setup({
    capabilities = capabilities,
    handlers = handlers,
})

-- LTex Server
lspconfig.ltex.setup({
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        ltex = {
            language = 'de-DE',
        },
    },
})

-- TexLab Server
lspconfig.texlab.setup({
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        texlab = {
            auxDirectory = '.',
            bibtexFormatter = 'texlab',
            build = {
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                executable = 'latexmk',
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 100,
            forwardSearch = {
                args = {},
            },
            latexFormatter = 'latexindent',
            latexindent = {
                modifyLineBreaks = false,
            },
        },
    },
})

-- PHP Server
lspconfig.intelephense.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,
})

-- YAML Server
lspconfig.yamlls.setup({
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        yaml = {
            validate = true,
            hover = true,
            completion = true,
            format = {
                enable = true,
                singleQuote = true,
                bracketSpacing = true,
            },
            editor = {
                tabSize = 2,
            },
            schemaStore = {
                enable = true,
            },
        },
        editor = {
            tabSize = 2,
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,
})

-- Rust
lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    vim.lsp.buf.format(nil)
                end,
                group = au_lsp,
            })
        end
    end,
})

lspconfig.eslint.setup({
    capabilities = capabilities,
    flags = { debounce_text_changes = 500 },
    root_dir = function(filename)
        return find_project_root(filename)
    end,
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        if client.server_capabilities.document_formatting then
            local au_lsp = vim.api.nvim_create_augroup('eslint_lsp', { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*',
                callback = function()
                    -- vim.lsp.buf.format(nil)

                    if vim.bo.filetype == 'scss' or vim.bo.filetype == 'css' then
                        vim.lsp.buf.format(nil)
                    else
                        vim.cmd('EslintFixAll')
                    end
                end,
                group = au_lsp,
            })
        end
    end,
})
