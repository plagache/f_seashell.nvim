local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
  return
end


local actions			= require"telescope.actions"
local action_state		= require "telescope.actions.state"
local finders			= require"telescope.finders"
local pickers			= require"telescope.pickers"
local sorters			= require"telescope.sorters"
local entry_display		= require"telescope.pickers.entry_display"

local function get_command_table(opts)
	command_list = {"ls", "make"}
	return command_list
end

local function get_entry_maker(opts)

	local entry_maker = function(entry)
        return {
            valid = true,
            value = entry,
            display = entry,
            ordinal = entry,
            content = entry,
        }
    end

	if not opts.entry_maker then
		return entry_maker
	else
		return opts.entry_maker
	end
end

local function get_sorter(opts)
	return sorters.get_generic_fuzzy_sorter()
end

local function attach_mappings(prompt_bufnr, map)
  actions.select_default:replace(function()
	actions.close(prompt_bufnr)
	local selection = action_state.get_selected_entry()
	-- print(vim.inspect(selection))
	-- do something relevant with our selected command
  end)
  return true
end

-- Telescope picker
local command_picker = function(opts) 

	opts = opts or {}

    local picker_opts = {

        prompt_title = "Command picker",

        finder = finders.new_table {
            results = get_command_table(opts),
            entry_maker = get_entry_maker(opts),
        },

		sorter = get_sorter(opts),

        attach_mappings = attach_mappings
	}

    pickers.new(opts, picker_opts):find()
end

-- debug purpose uncomment and do a luafile % to run the picker
-- command_picker()

return telescope.register_extension {
  exports = {
    commands = command_picker,
  }
}

