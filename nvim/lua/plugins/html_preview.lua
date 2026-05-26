return {
	{
		"barrett-ruth/live-server.nvim",
		cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
		ft = { "html", "css", "javascript" }, -- 階層エラーが消えたので、安全にファイルタイプ検知に戻せます！
		opts = {},
	},
}
