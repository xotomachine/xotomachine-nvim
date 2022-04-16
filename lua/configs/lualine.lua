local M = {}

function M.config()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end

    options = {
        theme = 'tokyonight'
    }

    lualine.setup(options)
end

return M
