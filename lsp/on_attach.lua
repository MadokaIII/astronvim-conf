return function(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    local is_available, inlayhints = pcall(require, "lsp-inlayhints")
    if is_available then
      require("lsp-inlayhints").on_attach(client, bufnr, false)
      vim.keymap.set("n", "<leader>uH", function() inlayhints.toggle() end, { desc = "Toggle inlay hints" })
      vim.cmd "hi! link LspInlayHint Comment"
    end

    -- this will be enabled in the future if neovim implements inline hints
    -- vim.lsp.buf_inlay_hint_toggle(bufnr)
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    local lsp_format_modifications_ok, lsp_format_modifications = pcall(require, "lsp-format-modifications")
    if lsp_format_modifications_ok then
      lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
      vim.keymap.set("n", "<leader>lF", "<CMD>FormatModifications<CR>", { desc = "Format changed code" })
    end
  end

  if client.name == "ruff_lsp" then client.server_capabilities.hoverProvider = false end
  if client.name == "pyright" then
    local enabled_capabilities = {
      textDocumentSync = true,
      completionProvider = true,
      documentHighlightProvider = true,
      documentSymbolProvider = true,
      workspaceSymbolProvider = true,
    }
    for capability_name, _ in pairs(client.server_capabilities) do
      if not enabled_capabilities[capability_name] then client.server_capabilities[capability_name] = false end
    end
  end
end
