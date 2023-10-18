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
            print("should work")
            pickers.new(opts, {
                prompt_title = "plugins",
                sorter = sorters.get_generic_fuzzy_sorter(),
                finder = finders.new_table {
                    results = { "red", "green", "blue" }
                },
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        print(vim.inspect(selection))
                    end)
                    return true
                end,
            }):find()
        end,
    }
}
