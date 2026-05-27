return {
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = vim.tbl_filter(function(tool)
				return tool ~= "codelldb"
			end, opts.ensure_installed or {})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		opts = function(_, opts)
			opts.dap = vim.tbl_deep_extend("force", opts.dap or {}, {
				autoload_configurations = false,
				adapter = false,
				configuration = false,
			})

			opts.server = opts.server or {}
			local previous_on_attach = opts.server.on_attach
			opts.server.on_attach = function(client, bufnr)
				if previous_on_attach then
					previous_on_attach(client, bufnr)
				end
				pcall(vim.keymap.del, "n", "<leader>dr", { buffer = bufnr })
			end
		end,
	},
}
