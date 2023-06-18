return {
  -- control auto formatting on save
  format_on_save = {
    enabled = true, -- enable or disable format on save globally
  },
  disabled = {
    "lua_ls",
  },
  timeout_ms = 1000, -- default format timeout
  -- filter = function(client) -- fully override the default formatting function
  --   return true
  -- end
}
