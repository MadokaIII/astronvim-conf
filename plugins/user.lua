return {
  -- you can also add new plugins here as well:
  -- add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "user astrofile",
    config = true,
    branch = "anticonceal",
  },
  {
    "simrat39/rust-tools.nvim",
    opts = { tools = { inlay_hints = { auto = false } } },
  },
  {
    "fedepujol/move.nvim",
    event = "user astrofile",
  },
  {
    "crag666/code_runner.nvim",
    cmd = { "runcode", "runfile" },
    config = function()
      require("code_runner").setup {
        -- put here the commands by filetype
        startinsert = false,
        filetype_path = "", -- no default path define
        project_path = "", -- no default path defined
        filetype = {
          java = "cd $dir && javac $filename && java $filenamewithoutext",
          python = "export pythonpath=$pythonpath:. && time python3 -x dev -u",
          lua = "time luaj",
          typescript = "time deno run",
          rust = "cd $dir && rustc $filename && time $dir/$filenamewithoutext",
          javascript = "time node",
          shellscript = "time bash",
          zsh = "time zsh -i",
          go = "time go run",
          scala = "time scala",
          c = "cd $dir && gcc $filename -o $filenamewithoutext -wall && time ./$filenamewithoutext && rm $filenamewithoutext",
          markdown = "rich",
        },
        term = {
          --  position to open the terminal, this option is ignored if mode is tab
          mode = "toggleterm",
          position = "bot",
          -- position = "vert",
          -- window size, this option is ignored if tab is true
          size = 20,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "user astrogitfile",
    config = function()
      local actions = require "diffview.actions"
      local utils = require "astronvim.utils"
      local prefix = "<leader>d"

      utils.set_mappings {
        n = {
          [prefix] = { name = " diff view" },
          [prefix .. "<cr>"] = {
            "<cmd>diffviewopen<cr>",
            desc = "open diffview",
          },
          [prefix .. "h"] = {
            "<cmd>diffviewfilehistory %<cr>",
            desc = "open diffview file history",
          },
          [prefix .. "h"] = {
            "<cmd>diffviewfilehistory<cr>",
            desc = "open diffview branch history",
          },
        },
      }

      local build_keymaps = function(maps)
        local out = {}
        local i = 1
        for lhs, def in
          pairs(utils.extend_tbl(maps, {
            [prefix .. "q"] = {
              "<cmd>diffviewclose<cr>",
              desc = "quit diffview",
            }, -- toggle the file panel.
            ["]d"] = { actions.select_next_entry, desc = "next difference" }, -- open the diff for the next file
            ["[d"] = {
              actions.select_prev_entry,
              desc = "previous difference",
            }, -- open the diff for the previous file
            ["[c"] = { actions.prev_conflict, desc = "next conflict" }, -- in the merge_tool: jump to the previous conflict
            ["]c"] = { actions.next_conflict, desc = "previous conflict" }, -- in the merge_tool: jump to the next conflict
            ["cl"] = { actions.cycle_layout, desc = "cycle diff layout" }, -- cycle through available layouts.
            ["ct"] = { actions.listing_style, desc = "cycle tree style" }, -- cycle through available layouts.
            ["<leader>e"] = { actions.toggle_files, desc = "toggle explorer" }, -- toggle the file panel.
            ["<leader>o"] = { actions.focus_files, desc = "focus explorer" }, -- bring focus to the file panel
          }))
        do
          local opts
          local rhs = def
          local mode = { "n" }
          if type(def) == "table" then
            if def.mode then mode = def.mode end
            rhs = def[1]
            def[1] = nil
            def.mode = nil
            opts = def
          end
          out[i] = { mode, lhs, rhs, opts }
          i = i + 1
        end
        return out
      end

      require("diffview").setup {
        view = {
          merge_tool = { layout = "diff3_mixed" },
        },
        keymaps = {
          disable_defaults = true,
          view = build_keymaps {
            [prefix .. "o"] = {
              actions.conflict_choose "ours",
              desc = "take ours",
            }, -- choose the ours version of a conflict
            [prefix .. "t"] = {
              actions.conflict_choose "theirs",
              desc = "take theirs",
            }, -- choose the theirs version of a conflict
            [prefix .. "b"] = {
              actions.conflict_choose "base",
              desc = "take base",
            }, -- choose the base version of a conflict
            [prefix .. "a"] = {
              actions.conflict_choose "all",
              desc = "take all",
            }, -- choose all the versions of a conflict
            [prefix .. "0"] = {
              actions.conflict_choose "none",
              desc = "take none",
            }, -- delete the conflict region
          },
          diff3 = build_keymaps {
            [prefix .. "o"] = {
              actions.diffget "ours",
              mode = { "n", "x" },
              desc = "get our diff",
            }, -- obtain the diff hunk from the ours version of the file
            [prefix .. "t"] = {
              actions.diffget "theirs",
              mode = { "n", "x" },
              desc = "get their diff",
            }, -- obtain the diff hunk from the theirs version of the file
          },
          diff4 = build_keymaps {
            [prefix .. "b"] = {
              actions.diffget "base",
              mode = { "n", "x" },
              desc = "get base diff",
            }, -- obtain the diff hunk from the ours version of the file
            [prefix .. "o"] = {
              actions.diffget "ours",
              mode = { "n", "x" },
              desc = "get our diff",
            }, -- obtain the diff hunk from the ours version of the file
            [prefix .. "t"] = {
              actions.diffget "theirs",
              mode = { "n", "x" },
              desc = "get their diff",
            }, -- obtain the diff hunk from the theirs version of the file
          },
          file_panel = build_keymaps {
            j = actions.next_entry, -- bring the cursor to the next file entry
            k = actions.prev_entry, -- bring the cursor to the previous file entry.
            o = actions.select_entry,
            s = actions.stage_all, -- stage all entries.
            u = actions.unstage_all, -- unstage all entries.
            x = actions.restore_entry, -- restore entry to the state on the left side.
            l = actions.open_commit_log, -- open the commit log panel.
            cf = { actions.toggle_flatten_dirs, desc = "flatten" }, -- flatten empty subdirectories in tree listing style.
            r = actions.refresh_files, -- update stats and entries in the file list.
            ["-"] = actions.toggle_stage_entry, -- stage / unstage the selected entry.
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry, -- open the diff for the selected entry.
            ["<2-leftmouse>"] = actions.select_entry,
            ["<c-b>"] = actions.scroll_view(-0.25), -- scroll the view up
            ["<c-f>"] = actions.scroll_view(0.25), -- scroll the view down
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          file_history_panel = build_keymaps {
            j = actions.next_entry,
            k = actions.prev_entry,
            o = actions.select_entry,
            y = actions.copy_hash, -- copy the commit hash of the entry under the cursor
            l = actions.open_commit_log,
            zr = { actions.open_all_folds, desc = "open all folds" },
            zm = { actions.close_all_folds, desc = "close all folds" },
            ["?"] = { actions.options, desc = "options" }, -- open the option panel
            ["<down>"] = actions.next_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-leftmouse>"] = actions.select_entry,
            ["<c-a-d>"] = actions.open_in_diffview, -- open the entry under the cursor in a diffview
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
          },
          option_panel = {
            q = actions.close,
            o = actions.select_entry,
            ["<cr>"] = actions.select_entry,
            ["<2-leftmouse"] = actions.select_entry,
          },
        },
      }
    end,
  },
  {
    "joechrisellis/lsp-format-modifications.nvim",
    event = "user astrofile",
  },
  {
    "m-demare/hlargs.nvim",
    event = "user astrofile",
    opts = {
      color = "#ff7a00", --"#ef9062",
      paint_arg_usages = true,
    },
  },
  {
    "exafunction/codeium.vim",
    event = "user astrofile",
    config = function()
      -- change '<c-g>' here to any keycode you like.
      vim.keymap.set("i", "<c-g>", function() return vim.fn["codeium#accept"]() end, { expr = true })
      vim.keymap.set("i", "<c-n>", function() return vim.fn["codeium#cyclecompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<c-p>", function() return vim.fn["codeium#cyclecompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#clear"]() end, { expr = true })
    end,
  },
  {
    "nvim-neotest/neotest",
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        adapters = {
          require "neotest-go",
          require "neotest-rust",
          require "neotest-python",
        },
        log_level = vim.log.levels.debug,
      }
      vim.api.nvim_create_user_command("neotestrun", require("neotest").run.run, {})
      vim.api.nvim_create_user_command(
        "neotestrunfile",
        function() require("neotest").run.run(vim.fn.expand "%") end,
        {}
      )
      vim.api.nvim_create_user_command(
        "neotestrundap",
        function() require("neotest").run.run { strategy = "dap" } end,
        {}
      )
      vim.api.nvim_create_user_command("neoteststop", function() require("neotest").run.stop() end, {})
      vim.api.nvim_create_user_command("neotestattach", function() require("neotest").run.attach() end, {})
      vim.api.nvim_create_user_command("neotestsummarytoggle", function() require("neotest").summary.toggle() end, {})
      vim.api.nvim_create_user_command(
        "neotestoutput",
        function() require("neotest").output.open { enter = true } end,
        {}
      )
      vim.api.nvim_create_user_command(
        "neotestoutputtoggle",
        function() require("neotest").output_panel.toggle() end,
        {}
      )
      vim.api.nvim_create_user_command(
        "neotestjumppreviousfailed",
        function() require("neotest").jump.prev { status = "failed" } end,
        {}
      )
      vim.api.nvim_create_user_command(
        "neotestjumpnextfailed",
        function() require("neotest").jump.next { status = "failed" } end,
        {}
      )
    end,
    ft = { "go", "rust", "python" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "antoinemadec/fixcursorhold.nvim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "user astrofile",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
}
