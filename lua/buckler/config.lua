local M = {}

--- Configuration for the plugin
---@class BucklerConfig
---@field history_length number Maximum number of items in the yank history (default: 10)
---@field sync_clipboard boolean Whether to synchronize with the system clipboard (default: true)
M.options = {
    history_length = 10,
    sync_clipboard = true,
}

--- Setup function for the config module
---@param user_config BucklerConfig|nil User configuration
function M.setup(user_config)
    M.options = vim.tbl_deep_extend('force', M.options, user_config or {})
end

return M
