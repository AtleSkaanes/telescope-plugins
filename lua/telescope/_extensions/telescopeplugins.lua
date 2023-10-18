local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function ScanDir(directory)
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

function ReadFile(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function GetPlugins()
    local plugins = {}
    local i = 0
    local optPath = vim.fn.stdpath("data")..'\\site\\pack\\packer\\opt'
    local startPath = vim.fn.stdpath("data")..'\\site\\pack\\packer\\start'
    for k, v in pairs(ScanDir(startPath)) do
        i = i + 1
        plugins[i] = {v, startPath..'\\'..v}
    end
    for k, v in pairs(ScanDir(optPath)) do
        i = i + 1
        plugins[i] = {v, optPath..'\\'..v}
    end
    for k, v in pairs(plugins) do
        local c = ReadFile(v[2]..'\\.git\\config')
        local regex = "http[a-zA-Z:/._0-9\\-]*"
        local s = string.sub(c, string.find(c, regex))
        plugins[k][2] = s
    end
    return plugins
end

function open_url(url)
    if (package.config:sub(1,1) == "\\") then
        os.execute('start "" "' .. url .. '"')
    else
        os.execute('open "" "' .. url .. '"')
  end
end


return require("telescope").register_extension {
    exports = {
        ListPlugins = function(opts)
            opts = opts or {}
            pickers.new(opts, {
                prompt_title = "plugins",
                sorter = sorters.get_generic_fuzzy_sorter(),
                finder = finders.new_table {
                    results = GetPlugins(),
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
                        open_url(selection[2])
                    end)
                    return true
                end,
            }):find()
        end,
    }
}
