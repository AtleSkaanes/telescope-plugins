local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function scandir(directory)
    local dirs = {}
    local i = 1
    if (package.config:sub(1,1) == "\\") then
        for dir in io.popen('dir "'..directory..'" /b'):lines() do
            i = i + 1
            dirs[i] = dir
        end
    else
        for dir in io.popen('ls -pa "'..directory..'" | grep -v /'):lines() do
            i = i + 1
            dirs[i] = dir
        end
    end
    return dirs
end

function get_plugins()
    local optPath = vim.fn.stdpath("data")..'\\side\\pack\\packer\\opt'
    local startPath = vim.fn.stdpath("data")..'\\side\\pack\\packer\\start'
    for k, v in pairs(scandir(startPath)) do
        print(v)
    end
end


return require("telescope").register_extension {
    exports = {
        ListPlugins = function(opts)
            get_plugins()
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
