-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("subatiq.set")
require("subatiq.remap")


-- Setup lazy.nvim
local plugins = {

    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.4',
    },
    'nvim-lua/plenary.nvim',

    'rluba/jai.vim',

    'SogoCZE/Jails',

    'editorconfig/editorconfig-vim',

    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    },
    'nvim-treesitter/playground',
    'ThePrimeagen/harpoon',
    -- The setup config table shows all available config options with their default values:
    'nvim-tree/nvim-web-devicons',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    'mbbill/undotree',

    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
        }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    "ellisonleao/gruvbox.nvim",
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({})
            vim.cmd.colorscheme("nord")
        end,
    },
    install = {
        colorscheme = { "nord" },
    },

}
require("lazy").setup(plugins, {
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "tokyonight" } },
    -- automatically check for plugin updates
    checker = { enabled = false },

})

vim.cmd.colorscheme("tokyonight-night")
groups = {
    "Normal", "NormalFloat", "NormalNC", "PreProc",
    "Repeat", "LineNr",
    "SignColumn", "EndOfBuffer", "NvimTreeNormal",
    "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder", "TelescopePreviewBorder",
    "TelescopeResultsBorder"
}
for _,group in pairs(groups) do
    vim.api.nvim_set_hl(0, group, {guibg=NONE, ctermbg=NONE})
end
vim.api.nvim_set_hl(0, "Visual", {bg="#FDFDFD", fg="black"})
