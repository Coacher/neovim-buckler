local clipboard = require('buckler.clipboard')
local registers = require('buckler.registers')

local M = {}

--- Stores the last key pressed in visual mode
---@type string|nil
M.char = nil

--- Namespace for visual mode key handling
---@type integer
M.namespace = vim.api.nvim_create_namespace('buckler.visual')

--- Process key input in visual mode
---@param key string The key pressed
function M.process_key_input(key)
    M.char = key

    if string.lower(key) == 'p' and clipboard.is_clipboard_register(vim.v.register) then
        registers.set_clipboard_from_zero()
    end
end

--- Process mode change events
function M.process_mode_change()
    M.char = nil
end

--- Setup function for the visual module
function M.setup()
    local augroup = vim.api.nvim_create_augroup('buckler_process_visual', { clear = true })

    vim.api.nvim_create_autocmd('ModeChanged', {
        group = augroup,
        pattern = '[^vV\\x16]*:[vV\\x16]*',
        callback = function() vim.on_key(M.process_key_input, M.namespace) end
    })

    vim.api.nvim_create_autocmd('ModeChanged', {
        group = augroup,
        pattern = '[vV\\x16]*:[^vV\\x16]*',
        callback = function() vim.on_key(nil, M.namespace) end
    })
    vim.api.nvim_create_autocmd('ModeChanged', {
        group = augroup,
        pattern = '[vV\\x16]*:[^vV\\x16]*',
        callback = function() M.process_mode_change() end
    })
end

return M
