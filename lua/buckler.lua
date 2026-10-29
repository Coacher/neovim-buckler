local M = {}

--- Run the callback once Neovim has started
---@param callback function
local function on_vim_enter(callback)
    if vim.v.vim_did_enter == 1 then
        callback()
    else
        vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = callback })
    end
end

--- Setup the plugin with user configuration
---@param user_config BucklerConfig|nil User configuration
function M.setup(user_config)
    local config = require('buckler.config')
    config.setup(user_config)

    if config.options.history_length < 10 then
        vim.notify('neovim-buckler requires history length >= 10', vim.log.levels.ERROR)
        return
    end

    -- Registers and 'clipboard' reach their startup state only after shada is read
    on_vim_enter(function()
        require('buckler.clipboard').setup()
        require('buckler.registers').setup()
    end)

    require('buckler.visual').setup()
    require('buckler.yank').setup()

    if config.options.sync_clipboard then
        require('buckler.sync').setup()
    end
end

return M
