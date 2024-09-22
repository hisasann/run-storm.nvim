function run_storm(directory, on_confirm)
	local buffer = get_buffer()
	local prompt = "JetBrains IDE Command:"

	local on_confirm = vim.F.if_nil(on_confirm, function(shell_file_name)
		local row = unpack(vim.api.nvim_win_get_cursor(0))
		print(directory)
		local cmd = ":silent exec '!command sh"
			.. " "
			.. directory
			.. shell_file_name
			.. ".sh --line "
			.. row
			.. " "
			.. vim.fn.expand("%:p")
			.. "'"
		vim.cmd(cmd)
		print(shell_file_name)
	end)

	local window = open_window(buffer, prompt)

	vim.cmd("startinsert!")

	vim.keymap.set("i", "<ESC>", function()
		vim.cmd("stopinsert")
		vim.api.nvim_win_close(window, false)
	end, { buffer = buffer })

	vim.keymap.set("i", "<CR>", function()
		vim.cmd("stopinsert")
		local input = vim.fn.getline(".")
		print(input)
		im.api.nvim_win_close(window, false)
		on_confirm(input)
	end, { buffer = buffer })
end

local function setup(directory)
	vim.api.nvim_create_user_command("St", function()
		run_storm(directory)
	end, {})
end

return {
	setup = setup,
}
