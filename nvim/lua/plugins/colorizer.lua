return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" }, -- 全てのファイルタイプで有効
      user_default_options = {
        suppress_deprecation = true,
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or red
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "background", -- Set the display mode (foreground/background/virtualtext)
        tailwind = true, -- Enable Tailwind colors
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■", -- 仮想テキストで表示する場合の記号
      },
      buftypes = {},
    },
  },
}
