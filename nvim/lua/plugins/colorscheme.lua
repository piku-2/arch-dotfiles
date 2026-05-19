return {
  {
    "rebelot/kanagawa.nvim",
    lazy     = false,
    priority = 1000,
    opts     = { theme = "dragon" },
    config   = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "kanagawa-dragon" },
  },
}
