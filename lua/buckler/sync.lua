local clipboard = require('buckler.clipboard')
local history = require('buckler.history')
local registers = require('buckler.registers')

local M = {}

--- Stores clipboard contents for comparison
---@type BucklerHistoryItem|nil
local contents = nil

--- Process focus lost event
function M.process_focus_lost()
    contents = registers.get_reg(clipboard.register)
end

--- Process focus gained event
function M.process_focus_gained()
    local item = registers.get_reg(clipboard.register)
    if not vim.deep_equal(item, contents) then
        history.push(item)
        registers.set_numbered_from_history()
        registers.set_clipboard_from_zero()
    end
end

--- Setup function for the sync module
function M.setup()
    local augroup = vim.api.nvim_create_augroup('buckler_sync_clipboard', { clear = true })

    vim.api.nvim_create_autocmd('FocusLost', {
        group = augroup,
        callback = function() M.process_focus_lost() end
    })
    vim.api.nvim_create_autocmd('FocusGained', {
        group = augroup,
        callback = function() M.process_focus_gained() end
    })
end

return M
