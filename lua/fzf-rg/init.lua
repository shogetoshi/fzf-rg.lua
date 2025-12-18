local M = {}
local fzf = require("fzf")

require("fzf").default_options = {
    window_on_create = function()
        vim.cmd("set winhl=Normal:Normal")
    end
}

local source = 'fd -HI --ignore-file ~/.ignore -c always -t f'
local options = {
    "--ansi",
    "--multi",
    "--reverse",
    "--preview 'bat --plain --number --color always {}'",
    "--preview-window down:70%",
    "--bind 'alt-h:reload:fd -HI -c always -t f'",
}

M.run = function()
    coroutine.wrap(function()
        local result = fzf.fzf(source, table.concat(options, " "))
        if result then
            for _, file in ipairs(result) do
                vim.cmd("edit " .. file)
            end
        end
    end)()
end

return M
