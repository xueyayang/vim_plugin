set nocompatible
filetype off

set rtp+=~/AppData/Local/nvim/Vundle.vim
call vundle#begin()

"Vundle itself
"Plugin 'gmarik/vundle'

"lsp
Plugin 'https://github.com/neovim/nvim-lspconfig'
Plugin 'hrsh7th/cmp-nvim-lsp'
Plugin 'hrsh7th/cmp-buffer'
Plugin 'hrsh7th/cmp-path'
Plugin 'hrsh7th/cmp-cmdline'
Plugin 'hrsh7th/nvim-cmp'

"Colorscheme package
Plugin 'flazz/vim-colorschemes'

"minibufexpl
"Plugin 'https://github.com/fholgado/minibufexpl.vim'

"lua-line
Plugin	'nvim-lualine/lualine.nvim'

"NerdTree
Plugin 'https://github.com/preservim/nerdtree'

"ultisnips
"Plugin 'SirVer/ultisnips'

" cpp syntax
"Plugin 'octol/vim-cpp-enhanced-highlight'

"syntastic
"Plugin 'https://github.com/vim-syntastic/syntastic'

"onedark
Plugin 'https://github.com/joshdick/onedark.vim'

"orgmode
Plugin 'https://github.com/kristijanhusak/orgmode.nvim'
Plugin 'https://github.com/nvim-treesitter/nvim-treesitter'

"plenary
Plugin 'https://github.com/nvim-lua/plenary.nvim'
"telescope
Plugin 'https://github.com/nvim-telescope/telescope.nvim'
"vim-markdown
"Plugin 'plasticboy/vim-markdown'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" vundle end
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" init.vim
lua << EOF
require 'nvim-treesitter.install'.prefer_git = false

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "c_sharp", "cpp"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<A-g>', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<A-G>', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  vim.api.nvim_create_autocmd("CursorHold", {
	  buffer = bufnr,
	  callback = function()
	  local opts = {
		  focusable = false,
		  close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
		  border = 'rounded',
		  source = 'always',
		  prefix = ' ',
		  scope = 'cursor',
	  }
	  vim.diagnostic.open_float(nil, opts)
	  end
  })
end

--require'lspconfig'.ccls.setup{
--	on_attach = on_attach,
--	init_options = {
--		cache = {
--			directory = ".ccls-cache";
--		};
--	}
--}

--------------------------------------------------------------------------------
-- telescope
--------------------------------------------------------------------------------
local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<A-O>', require'lspconfig'.clangd.switch_source_header, 0)
vim.keymap.set('n', '<space>m', builtin.lsp_document_symbols, {})
--vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
--vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--------------------------------------------------------------------------------
-- cmp
--------------------------------------------------------------------------------
local cmp = require'cmp'

cmp.setup({
snippet = {
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
		},
	mapping = cmp.mapping.preset.insert({
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.abort(),
	['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	-- { name = 'vsnip' }, -- For vsnip users.
	-- { name = 'luasnip' }, -- For luasnip users.
	-- { name = 'ultisnips' }, -- For ultisnips users.
	-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
	})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
								{ name = 'buffer' }
				}
				})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
				{ name = 'path' }
				}, {
								{ name = 'cmdline' }
				})
				})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['clangd'].setup { }
--require'lspconfig'.clangd.setup{
--capabilities = capabilities,
--on_attach = on_attach,
--	cmd = {
--	-- 'clangd',
--	-- '--compile-commands-dir=d:\\ATemp\\Test_Lsp\\Dev-Lessons\\TnlDemo\\',
--	},
--}

require('lualine').setup {
  options = {
    theme = 'gruvbox'
  }
}

-- Esc 时切换到英文
vim.api.nvim_set_keymap('i', '<Esc>', [[<Cmd>lua require('im_toggle').onEsc()<CR><Esc>]], { noremap = true, silent = true })
-- 按 i 或 a 时切换到中文
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        require('im_toggle').onInsert()
    end
}) 
EOF

set backspace=indent,eol,start
syntax on

"1 Monokai
"2 desert
"3 solarized
let themechoose=2
if themechoose == 1
colorscheme Monokai
elseif themechoose == 2
colorscheme default
elseif themechoose == 3
colorscheme onedark
else
colorscheme solarized8_light
endif
set nu
set tw=1024
set tabstop=4
set shiftwidth=4
set cino=g0 
"set formatoptions=ron2m1Bal 
set autochdir 
set hlsearch 
set cindent
set relativenumber
set clipboard=unnamedplus
set title
set showtabline=2

set grepprg=rg\ --vimgrep\ $*

set guifont=Cascadia\ Mono:h13

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

let mapleader = " "
nnoremap <Space>o <cmd>ClangdSwitchSourceHeader<cr>
nnoremap ff :
nnoremap fs /
nnoremap <Leader>w :w<Enter>
