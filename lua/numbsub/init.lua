-- Load commands
local commands = require("numbsub.numbsub")
local myCommand = "NumbSub"

-- Define the custom command in Neovim
vim.api.nvim_create_user_command(myCommand, function(opts)
	commands.subst_with_num(opts.args)
end, { nargs = "*" })
