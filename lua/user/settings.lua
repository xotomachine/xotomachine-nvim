local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
local set = vim.opt

local config = {

  -- Set colorscheme
  colorscheme = "tokyonight",

  -- Add plugins
  plugins = {
    -- Plugin definition:
    -- {
    --   "simrat39/rust-tools.nvim",
    --   requires = { "nvim-lspconfig", "nvim-lsp-installer", "nvim-dap", "Comment.nvim" },
    --   -- Is configured via the server_registration_override installed below!
    -- },
  },

  overrides = {
    lsp_installer = {
    --   server_registration_override = function(server, server_opts)
    --     -- Special code for rust.tools.nvim!
    --     if server.name == "rust_analyzer" then
    --       local extension_path = vim.fn.stdpath "data" .. "/dapinstall/codelldb/extension/"
    --       local codelldb_path = extension_path .. "adapter/codelldb"
    --       local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    --       require("rust-tools").setup {
    --         server = server_opts,
    --         dap = {
    --           adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    --         },
    --       }
    --     else
    --       server:setup(server_opts)
    --     end
    --   end,
    },
    treesitter = {
      ensure_installed = { "lua" },
    },
  },

  -- On/off virtual diagnostics text
  virtual_text = true,

  -- Disable default plugins
  enabled = {
    bufferline = true,
    nvim_tree = true,
    lualine = true,
    lspsaga = true,
    gitsigns = true,
    colorizer = true,
    toggle_term = true,
    comment = true,
    symbols_outline = true,
    compe_config = true,
    indent_blankline = true,
    dashboard = true,
    which_key = true,
    neoscroll = true,
    ts_rainbow = true,
    ts_autotag = true,
  },
}

-- Set options
set.relativenumber = true

-- Set key bindings
map("n", "<C-s>", ":w!<CR>", opts)

-- Set autocommands
vim.cmd [[
  augroup packer_conf
    autocmd!
    autocmd bufwritepost plugins.lua source <afile> | PackerSync
  augroup end
]]

return config
