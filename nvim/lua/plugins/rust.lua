return {
  {
    "mrcjkb/rustaceanvim",
    -- config 関数は LazyVim の lang.rust extra に委ねる（override しない）
    opts = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            -- clippy を保存時チェックに使用（--no-deps で高速化）
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = { enable = true },
            inlayHints = {
              chainingHints = { enable = true },
              closureReturnTypeHints = { enable = "with_block" },
              parameterHints = { enable = true },
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
              maxLength = { enable = true, value = 30 },
            },
          },
        },
      },
    },
  },
}
