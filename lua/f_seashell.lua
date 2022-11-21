-- module declaration
local FSeaShell = {}
FSeaShell.opts = {}

-- get filename for new command
local function get_filename(command)

	-- TODO add a hash of command at the end of filename
    local file_name = os.date() -- .. command

	-- add default_path if one is set
	if FSeaShell.opts.default_path then
		file_name = FSeaShell.opts.default_path .. file_name
	end

	return file_name
end

local function inject_command_in_new_buff(input)

    --[[ open file and get bufnr ]]

    local new_file_command = "vnew " .. get_filename(input)
    vim.cmd(new_file_command)
    local buf_nbr = vim.api.nvim_get_current_buf()

    --[[ inject output command to this attached bufnr ]]
    vim.fn.jobstart(input, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(buf_nbr, 0, -1, false, {"command :", "##BEGIN##", input, "##END##", "Output :", "##BEGIN##", data, "##END##"})
                local write_command = "write " .. vim.api.nvim_buf_get_name(buf_nbr)
                vim.cmd(write_command)
            end
        end,
    })
end

--[[ save buffer with hash name ]]

--[[ take the input of a command ]]
function FSeaShell.command_prompt()
    vim.ui.input({ prompt = 'enter new command : ' }, inject_command_in_new_buff)
    return data
end

local function completion(_, line)
	local l = vim.split(line, "%s+")
	local n = #l - 2
	print(l, n)

	if n == 0 then
		--expand modulename
	end

	if n == 1 then
		--expand function
	end
	return "HELLO"
end

-- setup function to override default options
function FSeaShell.setup(opts)
	opts = opts or {}

	if opts.default_path then
		FSeaShell.opts.default_path = opts.default_path
	else
		FSeaShell.opts.default_path = ""
	end

	
	-- set default user command
	-- last param may be used to create completion for commands see
	-- https://github.com/nvim-telescope/telescope.nvim/blob/master/plugin/telescope.lua#L108
	command_options = {
		-- nargs = "*",
		-- complete = completion
	}
	vim.api.nvim_create_user_command("FSeaShell", FSeaShell.command_prompt, command_options)
end

return FSeaShell
