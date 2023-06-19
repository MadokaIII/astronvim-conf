return {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        bindingModeHints = {
          enable = true,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
        },
        closureCaptureHints = {
          enable = true,
        },
        closureReturnTypeHints = {
          enable = true,
        },
        discriminantHints = {
          enable = true,
        },
        expressionAdjustmentHints = {
          enable = true,
        },
        lifetimeElisionHints = {
          enable = true,
        },
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = true,
        },
        typeHints = {
          enable = true,
        },
        locationLinks = {
          enable = false,
        },
      },
    },
  },
}
