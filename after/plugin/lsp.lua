local lsp = require("lsp-zero")

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-k>'] = function()
        if cmp.visible_docs() then
            cmp.close_docs()
        else
            cmp.open_docs()
        end
    end,
})

cmp.setup({
    sources = {
        { name = 'nvim_lsp', max_item_count = 7, keyword_length = 2 },
        { name = 'buffer',   max_item_count = 1, keyword_length = 2 },
    },
    mapping = cmp_mappings
})

local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- this should return the path to the configuration dir (the one containing init.lua)
GetConfigPath = function()
    local runtimepath = vim.api.nvim_list_runtime_paths()
    return runtimepath[1];
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'rust_analyzer' },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            local lspconfig = require('lspconfig')
            local configs = require('lspconfig.configs')
            lspconfig.lua_ls.setup(lua_opts)

            -- JAI SETUP
            if not configs.jails then
                configs.jails = {
                    default_config = {
                        cmd = { "/usr/local/bin/jails" },
                        root_dir = lspconfig.util.root_pattern("jails.json", "build.jai", "main.jai"),
                        filetypes = { "jai" },
                        name = "Jails",
                        capabilities = cmp_nvim_lsp.default_capabilities()
                    },
                }
            end
            lspconfig.jails.setup({
            })
            vim.filetype.add({ extension = { jai = "jai", } })
            -- END JAI SETUP

            lspconfig.basedpyright.setup({
                cmd = "basedpyright",
                on_attach = on_attach,
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = 'workspace',
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = 'basic'
                        }
                    }
                }
            })
        end,
    },
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vf", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "es", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "ef", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
