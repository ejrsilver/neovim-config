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

local lspconfig = require('lspconfig')
if vim.loop.os_uname().sysname == "Windows" then
    lspconfig.intelephense.setup {
      on_attach = on_attach, 
      capabilities = capabilities, 
      settings = {
        intelephense = {
          environment = {
            includePaths = {"C:\\Users\\ethan.admin\\Documents\\PapEasy\\papeasy-web\\wordpress", }
          }
        }
      }
    }
end

local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behaviour = cmp.SelectBehavior.Select })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {'i', 's', 'c',}),
    }
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

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

    vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function ()
            vim.lsp.buf.format()
        end
    })
end)

lsp.setup()

