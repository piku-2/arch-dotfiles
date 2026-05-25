return {
	{
		"barrett-ruth/live-server.nvim",
		cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
		ft = { "html", "css", "javascript" },
		config = function()
			require("live-server").setup({
				-- 外部の live-server コマンドをそのまま叩くシンプルな設計
			})
		end,
	},
}
