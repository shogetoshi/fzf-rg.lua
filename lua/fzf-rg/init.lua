local M = {}
local fzf = require("fzf")

require("fzf").default_options = {
    window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
    end
}

local source = 'rg -uuu --ignore-file ~/.ignore --color always -n ^'
local options = {
    "--ansi",
    "--multi",
    "--reverse",
    "--delimiter", ":",
    "--preview 'bat --plain --number --color always --highlight-line={2} {1}'",
    "--preview-window '+{2}-5:down:70%'",
    "--bind 'alt-h:reload:fd -HI -c always -t f'",
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
