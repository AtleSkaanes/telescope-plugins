local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function scandir(directory)
    local dirs = {}
    local i = 0
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
    local plugins = {}
    local i = 0
    local optPath = vim.fn.stdpath("data")..'\\site\\pack\\packer\\opt'
    local startPath = vim.fn.stdpath("data")..'\\sise\\pack\\packer\\start'
    for k, v in pairs(scandir(startPath)) do
        i = i + 1
        plugins[i] = {v, k}
    end
    for k, v in pairs(scandir(optPath)) do
        i = i + 1
        plugins[i] = {v, k}
    end
    return plugins
end


return require("telescope").register_extension {
    exports = {
        ListPlugins = function(opts)
            opts = opts or {}
            pickers.new(opts, {
                prompt_title = "plugins",
                sorter = sorters.get_generic_fuzzy_sorter(),
                finder = finders.new_table {
                    results = get_plugins(),
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
