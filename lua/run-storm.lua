local function terminal_autoclose(cmd)
	local bufnr = vim.api.nvim_get_current_buf()
	cmd = cmd or vim.o.shell

	local opts = {
		on_exit = function()
			vim.cmd(bufnr .. "bwipeout")
		end,
	}

	vim.fn.termopen(cmd, opts)
	vim.cmd("normal! G")
end

vim.api.nvim_create_user_command("TerminalAutoclose", function(opts)
	terminal_autoclose(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("SS", function()
	vim.cmd("botright split +enew")
	vim.cmd("TerminalAutoclose webstorm .")
	--vim.cmd("set bufhidden=wipe")
	--vim.cmd("wincmd p")
end, {})

-- local function terminal_autoclose(cmd)
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	cmd = cmd or vim.o.shell
--
-- 	local opts = {
-- 		on_exit = function()
-- 			vim.cmd(bufnr .. "bwipeout")
-- 		end,
-- 	}
--
-- 	vim.fn.termopen(cmd, opts)
-- 	vim.cmd("normal! G")
-- end

local function openWebstorm()
	-- :echo expand('%:p')
	local terminal = "terminal"
	local row = unpack(vim.api.nvim_win_get_cursor(0))
	print(row)

	-- https://pleiades.io/help/webstorm/opening-files-from-command-line.html#macos
	-- https://zenn.dev/comamoca/articles/lets-make-neovim-plugin
	-- https://developer.jmatsuzaki.com/posts/get-file-name-in-vim/
	-- https://zenn.dev/kawarimidoll/articles/04ffb0d2270328
	-- 	local cmd = ":terminal echo aaa"
	-- 	local cmd = ": "
	-- 		.. terminal
	-- 		.. " "
	-- 		.. "sh /Users/hisasann/_/dotfile/webstorm.sh"
	-- 		.. " "
	-- 		.. "--line"
	-- 		.. " "
	-- 		.. row
	-- 		.. " "
	-- 		.. vim.fn.expand("%:p")
	local cmd = ":silent exec '!command sh /Users/hisasann/_/dotfile/webstorm.sh --line "
		.. row
		.. " "
		.. vim.fn.expand("%:p")
		.. "'"
	vim.cmd(cmd)
	--vim.cmd("normal! <C-o>")
	--vim.cmd("normal! \\<C-o>")
	--vim.cmd([[autocmd TermClose * execute 'bdelete! ' . expand('<abuf>')]])
	-- 	vim.fn.termopen(cmd, {
	-- 		on_exit = function()
	-- 			vim.cmd("bwipeout!")
	-- 		end,
	-- 	})

	vim.wait(3000, function()
		--vim.cmd(":set modifiable")
		--vim.cmd(":<C-o>")
		--vim.cmd("normal! \\<C-o>")
		print("vim.wait")
		return true
	end)
	--terminal_autoclose(cmd)

	--vim.cmd(":autocmd TermClose * execute 'bdelete! ' . expand('<abuf>')")
	--vim.cmd(":set modifiable")
	--vim.cmd(":<C-o>")
end

local cache_bufnr = nil

local function get_buffer()
	if cache_bufnr ~= nil and vim.fn.bufexists(cache_bufnr) then
		return cache_bufnr
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "vim-ui-input")
	vim.api.nvim_buf_set_option(buf, "filetype", "vim-ui-input")
	cache_bufnr = buf
	return buf
end

local function open_window(buffer, title)
	if title ~= nil and type(title) == "string" then
		title = { { title, "InputFloatTitle" } }
	end
	local win = vim.api.nvim_open_win(buffer, true, {
		relative = "cursor",
		row = 1,
		col = 1,
		width = 40,
		height = 1,
		focusable = true,
		border = "rounded",
		title = title,
		title_pos = "left",
		noautocmd = true,
	})
	vim.api.nvim_win_set_option(win, "number", false)
	vim.api.nvim_win_set_option(win, "relativenumber", false)
	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "cursorline", false)
	vim.api.nvim_win_set_option(win, "winhighlight", "FloatBorder:InputFloatBorder,NormalFloat:Normal")
	-- 	vim.fn.sign_place(1, "", "InputPrompt", buffer, { lnum = vim.fn.line(".") })
	return win
end

-- require("rc.util").highlight.set({
-- 	InputFloatBorder = { fg = "#006db3" },
-- 	InputFloatTitle = { fg = "#6ab7ff" },
-- 	InputPrompt = { fg = "#5c6370" },
-- })
--
-- vim.fn.sign_define("InputPrompt", {
-- 	text = "❯",
-- 	texthl = "InputPrompt",
-- })

function run_webstorm(directory, on_confirm)
	local buffer = get_buffer()
	local prompt = "JetBrains IDE Command:"
	local on_confirm = vim.F.if_nil(on_confirm, function(shell_file_name)
		local row = unpack(vim.api.nvim_win_get_cursor(0))
		-- 		local cmd = ":"
		-- 			.. "terminal"
		-- 			.. " "
		-- 			.. "sh /Users/hisasann/_/dotfile/webstorm.sh"
		-- 			.. " "
		-- 			.. "--line"
		-- 			.. " "
		-- 			.. row
		-- 			.. " "
		-- 			.. vim.fn.expand("%:p")
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
		vim.api.nvim_win_close(window, false)
		on_confirm(input)
	end, { buffer = buffer })

	-- 	-- 新しいバッファを作成
	-- 	local buffer = vim.api.nvim_create_buf(false, true)
	-- 	--vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {})
	-- 	local win = vim.api.nvim_open_win(buffer, true, {
	-- 		relative = "cursor",
	-- 		row = 1,
	-- 		col = 1,
	-- 		width = 40,
	-- 		height = 1,
	-- 		focusable = true,
	-- 		border = "rounded",
	-- 		title = "aaa",
	-- 		title_pos = "left",
	-- 		noautocmd = true,
	-- 	})
	-- 	vim.api.nvim_win_set_option(win, "number", false)
	-- 	vim.api.nvim_win_set_option(win, "relativenumber", false)
	-- 	vim.api.nvim_win_set_option(win, "wrap", false)
	-- 	vim.api.nvim_win_set_option(win, "cursorline", false)
	-- 	vim.api.nvim_win_set_option(win, "winhighlight", "FloatBorder:InputFloatBorder,NormalFloat:Normal")
	--
	-- 	-- 新しいバッファにフォーカス
	-- 	vim.cmd([[wincmd w]])
	--
	-- 	-- ターミナルでコマンドを実行 (非同期)
	-- 	vim.cmd([[terminal webstorm .]])
end

vim.api.nvim_create_user_command("OpenWebStorm", function()
	--vim.cmd("!webstorm .")
	vim.fn.system(":terminal webstorm .")
end, {})

local function setup(directory)
	vim.api.nvim_create_user_command("St", function()
		run_webstorm(directory)
		--openWebstorm()
	end, {})
end

return {
	setup = setup,
}
