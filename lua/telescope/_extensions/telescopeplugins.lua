local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function scandir(directory)
    if (package.config:sub(1,1) == "\\") then
        for dir in io.popen([[dir "C:\Program Files\" /b]]):lines() do print(dir) end
    else
        for dir in io.popen([[ls -pa /home/user | grep -v /]]):lines() do print(dir) end
    end

end

local get_plugins = function ()
    local path = vim.fn.stdpath("data")+"/site/pack/packer"
    for file in lfs.dir(path) do
        if lfs.attributes(file,"mode") == "directory" then print("found dir, "..file," containing:")
            for sub in lfs.dir(""..file) do
                print("",l)
            end
        end
    end

end


return require("telescope").register_extension {
    exports = {
        ListPlugins = function(opts)
            scandir(vim.fn.stdpath("data"))
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
