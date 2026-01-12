local M = {}

--- Setup the plugin with user configuration
---@param user_config BucklerConfig|nil User configuration
function M.setup(user_config)
    local config = require('buckler.config')
    config.setup(user_config)

    require('buckler.clipboard').setup()
    require('buckler.registers').setup()
    require('buckler.visual').setup()
    require('buckler.yank').setup()

    if config.options.sync_clipboard then
        require('buckler.sync').setup()
    end
end

return M
