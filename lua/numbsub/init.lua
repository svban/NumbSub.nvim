-- Load commands
local commands = require("numbsub.commands")
local myCommand = "NumbSub"
local M = {}

-- Define the custom command in Neovim
function M.setup()
	vim.api.nvim_create_user_command(myCommand, function(opts)
		commands.subst_with_num(opts.args)
	end, { nargs = "*" })
end

return M
