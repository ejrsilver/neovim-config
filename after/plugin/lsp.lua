local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'clangd',
    'lua_ls',
    'asm_lsp',
    'bashls',
    'html',
    'marksman',
    'intelephense',
    'sqlls',
})

local lsp_format_on_save = function(bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
        end,
    })
end

local lspconfig = require('lspconfig')
lspconfig.intelephense.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        intelephense = {
            format = {
                braces = "allman"
            },
            environment = {
                includePaths = { "C:\\Users\\ethan.admin\\Documents\\Projects\\PapEasy\\papeasy-web\\wordpress", }
            }
        }
    }
}

local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behaviour = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end, { 'i', 's', 'c', }),
        ['<Enter>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm()
            else
                fallback()
            end
        end, { 'i', 's', 'c', }),
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    lsp_format_on_save(bufnr)
end)

lsp.setup()
