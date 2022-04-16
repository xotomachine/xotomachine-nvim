<h1 align="center">XotoVim</h1>

<div align="center"><p>
    <a href="https://github.com/xotoenv/xotovim/pulse">
      <img src="https://img.shields.io/github/last-commit/kabinspace/XotoVim?color=%4dc71f&label=Last%20Commit&logo=github&style=flat-square"/>
    </a>
    <a href="https://github.com/xotoenv/xotovim/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/kabinspace/XotoVim?label=License&logo=GNU&style=flat-square"/>
 </a>
</p>
</div>

<p align="center">
XotoVim is an aesthetic and feature-rich neovim config that is extensible and easy to use with a great set of plugins
</p>

## 🌟 PREVIEW

![Preview1](./utils/media/preview1.png)

## ⚡ REQUIREMENTS

* [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
* [Neovim 0.6+](https://github.com/neovim/neovim/releases/tag/v0.6.1)

## 🛠️ INSTALLATION

### LINUX

#### MAKE A BACKUP OF YOUR CURRENT NVIM FOLDER

```shell
mv ~/.config/nvim ~/.config/nvim-BK
```

#### CLONE THE REPOSITORY

```shell
git clone https://github.com/xotoenv/xotovim ~/.config/nvim
nvim +XotovimSync
```

## 📦 SETUP

#### INSTALL LSP

Enter `:LspInstall` followed by the name of the server you want to install<br>
Example: `:LspInstall pyright`

```shell
# INSTALL LOCALLY
npm i -g vuels jdtls kotlin_language_server tsserver angularls stylelint_lsp cssmodules_ls cssls jsonls dockerls html eslint sumneko_lua clangd vimls emmet_ls graphql

# INSTALL LSP SERVERS
:LspInstall vuels jdtls kotlin_language_server tsserver angularls stylelint_lsp cssmodules_ls cssls jsonls dockerls html eslint sumneko_lua clangd vimls emmet_ls graphql
```

#### INSTALL LANGUAGE PARSER

Enter `:TSInstall` followed by the name of the language you want to install<br>
Example: `:TSInstall python`

```shell
# INSTALL TS SERVERS
:LspInstall vuels jdtls kotlin_language_server tsserver angularls stylelint_lsp cssmodules_ls cssls jsonls dockerls html eslint sumneko_lua clangd vimls emmet_ls graphql
```

#### MANAGE PLUGINS

Run `:PackerClean` to remove any disabled or unused plugins<br>
Run `:PackerSync` to update and clean plugins<br>

#### UPDATE XOTOVIM

Run `:XotovimUpdate` to get the latest updates from the repository<br>

## ✨ FEATURES

* File explorer with [Nvimtree](https://github.com/kyazdani42/nvim-tree.lua)
* Autocompletion with [Cmp](https://github.com/hrsh7th/nvim-cmp)
* Git integration with [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)
* Statusline with [Lualine](https://github.com/nvim-lualine/lualine.nvim)
* Terminal with [Toggleterm](https://github.com/akinsho/toggleterm.nvim)
* Fuzzy finding with [Telescope](https://github.com/nvim-telescope/telescope.nvim)
* Syntax highlighting with [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* Formatting and linting with [Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim)
* Language Server Protocol with [Native LSP](https://github.com/neovim/nvim-lspconfig)

## ⚙️ CONFIGURATION

[User](https://github.com/xotoenv/xotovim/blob/main/lua/user) directory is given for custom configuration

```lua
-- Set colorscheme
colorscheme = "tokyonight",

-- Add plugins
plugins = {
  { "andweeb/presence.nvim" },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup()
    end,
  },
},

-- Overrides
overrides = {
  treesitter = {
    ensure_installed = { "lua" },
  },
},

-- On/off virtual diagnostics text
virtual_text = true,

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

-- Add formatters and linters
-- https://github.com/jose-elias-alvarez/null-ls.nvim
null_ls.setup {
  debug = false,
  sources = {
    -- Set a formatter
    formatting.rufo,
    -- Set a linter
    diagnostics.rubocop,
  },
  -- NOTE: You can remove this on attach function to disable format on save
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
    end
  end,
}
```

## EXTENDING XOTOVIM

XotoVim allows you to extend its functionality without going outside of the `user` directory!
> Please get in contact when you run into some setup issue where that is not the case.

### ADD MORE PLUGINS

Just copy the `packer` configuration without the `use` and with a `,` after the last closing `}` into the `plugins` key of your `user/settings.lua` file.

See the example above.

### ADDING SOURCES TO `NVIM-CMP`

To add new completion sources to `nvim-cmp` you can add the plugin (see above) providing that source like this:

```lua
    {
      "Saecki/crates.nvim",
      after = "nvim-cmp",
      config = function()
        require("crates").setup()

        local cmp = require "cmp"
        local config = cmp.get_config()
        table.insert(config.sources, { name = "crates" })
        cmp.setup(config)
      end,
    },
```

Use the options provided by `nvim-cmp` to change the order, etc. as you see fit.

### COMPLEY LSP SERVER SETUP

Some plugins need to do special magic to the LSP configuration to enable advanced features. One example for this is the `rust-tools.nvim` plugin.

Those can override `overrides.lsp_installer.server_registration_override`.

For example the `rust-tools.nvim` plugin can be set up like this:

```lua
    -- Plugin definition:
    {
      "simrat39/rust-tools.nvim",
      requires = { "nvim-lspconfig", "nvim-lsp-installer", "nvim-dap", "Comment.nvim" },
      -- Is configured via the server_registration_override installed below!
    },
```

and then wired up with:

```lua
  overrides = {
    lsp_installer = {
      server_registration_override = function(server, server_opts)
        -- Special code for rust.tools.nvim!
        if server.name == "rust_analyzer" then
          local extension_path = vim.fn.stdpath "data" .. "/dapinstall/codelldb/extension/"
          local codelldb_path = extension_path .. "adapter/codelldb"
          local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

          require("rust-tools").setup {
            server = server_opts,
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
          }
        else
          server:setup(server_opts)
        end
      end,
    },
  },
```

## 🗒️ NOTE

[Guide](https://github.com/xotoenv/xotovim/blob/main/utils/userguide.md) is given for basic usage<br>
[Learn](https://github.com/xotoenv/xotovim/blob/main/utils/mappings.txt) more about the default key bindings<br>
[Watch](https://www.youtube.com/watch?v=JQLZ7NJRTEo&t=4s&ab_channel=JohnCodes) a review video to know about the out of the box experience

## ⭐ CREDITS

Sincere appreciation to the following repositories, plugin authors and the entire neovim community out there that made the development of XotoVim possible.

* [Plugins](https://github.com/xotoenv/xotovim/blob/main/utils/plugins.txt)
* [NvChad](https://github.com/NvChad/NvChad)
* [LunarVim](https://github.com/LunarVim)
* [CosmicVim](https://github.com/CosmicNvim/CosmicNvim)

<div align="center" id="madewithlua">

[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua)](https://lua.org)

</div>
