local M = {}

--- Setup the plugin with user configuration
---@param user_config BucklerConfig|nil User configuration
function M.setup(user_config)
    local config = require('buckler.config')
    config.setup(user_config)

    if config.options.history_length < 10 then
        vim.notify('neovim-buckler requires history length >= 10', vim.log.levels.ERROR)
        return
    end

    require('buckler.clipboard').setup()
    require('buckler.registers').setup()
    require('buckler.visual').setup()
    require('buckler.yank').setup()

    if config.options.sync_clipboard then
        require('buckler.sync').setup()
    end
end

return M
