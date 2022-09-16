print("f_seashell is now loaded")


local function inject_command_in_new_buff(input)

    --[[ open file and get bufnr ]]

    local file_name = "vnew " .. os.date()
    vim.cmd(file_name)
    local buf_nbr = vim.api.nvim_get_current_buf()

    --[[ inject output command to this attached bufnr ]]

    vim.fn.jobstart(input, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(buf_nbr, 0, -1, false, {"command :", "", input, "Output :", ""})
                vim.api.nvim_buf_set_lines(buf_nbr, -1, -1, false, data)
                local file_name = "write " .. vim.api.nvim_buf_get_name(buf_nbr)
                vim.cmd(file_name)
            end
        end,
    })
end

--[[ save buffer with hash name ]]


--[[ take the input of a command ]]
function command_prompt()
    vim.ui.input({ prompt = 'enter new command : ' }, inject_command_in_new_buff)
    return data
end

print(os.date())

command_prompt()
