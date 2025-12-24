local M = {}
local fzf = require("fzf")

require("fzf").default_options = {
    window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
    end
}

local function get_search_path()
    local search_path = vim.fn.system("git rev-parse --show-cdup 2>/dev/null"):gsub("%s+$", "")
    if search_path == "" then
        return ""
    else
        return search_path
    end
end

local search_path = get_search_path()
local source = 'rg -uuu --ignore-file ~/.ignore --color always -n ^ ' .. search_path
local options = {
    "--ansi",
    "--multi",
    "--reverse",
    "--delimiter", ":",
    "--nth", "3..",
    "--preview 'bat --plain --number --color always --highlight-line={2} {1}'",
    "--preview-window '+{2}-5:down:70%'",
    "--bind 'alt-h:reload:fd -HI -c always -t f " .. search_path .. "'",
}

M.run = function()
    coroutine.wrap(function()
        local result = fzf.fzf(source, table.concat(options, " "))
        if result then
            for _, line in ipairs(result) do
                local file, lnum = line:match("^([^:]+):(%d+)")
                if file and lnum then
                    vim.cmd("edit +" .. lnum .. " " .. file)
                end
            end
        end
    end)()
end

return M
