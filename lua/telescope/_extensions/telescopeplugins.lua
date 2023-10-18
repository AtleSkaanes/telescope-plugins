local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local get_plugins = function ()

end


return require("telescope").register_extension {
    exports = {
        ListPlugins = function(opts)
            opts = opts or {}
            pickers.new(opts, {
                prompt_title = "plugins",
                sorter = sorters.get_generic_fuzzy_sorter(),
                finder = finders.new_table {
                    results = {
                        { "red", "#ff0000" },
                        { "green", "#00ff00" },
                        { "blue", "#0000ff" },
                    },
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry[1],
                            ordinal = entry[1],
                        }
                    end
                },
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        print(selection.value[2])
                    end)
                    return true
                end,
            }):find()
        end,
    }
}
