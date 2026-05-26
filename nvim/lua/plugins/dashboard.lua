return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	config = function()
		require("dashboard").setup({
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
				header = {
					"██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗",
					"██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║",
					"██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║",
					"██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║",
					"███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║",
					"╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝",
					" ",
				},
				center = {
					{
						icon = "󰱼  ",
						desc = "Find File",
						key = "f",
						action = 'lua LazyVim.pick("files")()',
					},
					{
						icon = "󰈚  ",
						desc = "Recent Files",
						key = "r",
						action = 'lua LazyVim.pick("oldfiles")()',
					},
					{
						icon = "  ",
						desc = "Live Grep",
						key = "g",
						action = 'lua LazyVim.pick("live_grep")()',
					},
					{
						icon = "  ",
						desc = "Projects",
						key = "p",
						action = "lua Snacks.picker.projects()",
					},
					{
						icon = "  ",
						desc = "Config",
						key = "c",
						action = "lua LazyVim.pick.config_files()()",
					},
					{
						icon = "  ",
						desc = "Restore Session",
						key = "s",
						action = 'lua require("persistence").load()',
					},
					{
						icon = "󰗼  ",
						desc = "Quit",
						key = "q",
						action = "qa",
					},
				},
				footer = { "Find. Jump. Ship." },
			},
		})
	end,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-lua/plenary.nvim" },
	},
}
