return {
  {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled                = true,
          auto_trigger           = true,
          hide_during_completion = true,
          keymap = { accept = "<Tab>", next = "<M-]>", prev = "<M-[>" },
        },
        panel     = { enabled = false },
        filetypes = {
          c      = false,
          cpp    = false,
          python = false,
          ["*"]  = true,
        },
      })
    end,
  },
}
