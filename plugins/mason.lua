-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "lua_ls", -- Lua
        "clangd", -- C/C++
        "omnisharp", -- C#
        "rust_analyzer", -- Rust
        "pyright", -- Python
        "jdtls", -- Java
        "gopls", -- Go
        "yamlls", -- YAML
        "jsonls", -- JSON
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "stylua",
        "omnisharp",
        "black",
        "gofumpt",
        "yamlfmt",
        "jsonlint",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "cpptools",
        "netcoredbg",
        "rustfmt",
        "solargraph",
        "debugpy",
        "delve",
      })
    end,
  },
}
