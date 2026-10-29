local clipboard = require('buckler.clipboard')
local history = require('buckler.history')
local registers = require('buckler.registers')

local M = {}

--- Process focus gained event
function M.process_focus_gained()
    local item = registers.get_reg(clipboard.primary())
    if not vim.deep_equal(item, history.get()) then
        history.push(item)
        registers.set_numbered_from_history()
        registers.set_clipboard_from_zero()
    end
end

--- Setup function for the sync module
function M.setup()
    vim.api.nvim_create_autocmd('FocusGained', {
        group = vim.api.nvim_create_augroup('buckler_sync_clipboard', { clear = true }),
        callback = function()
            if #clipboard.registers > 0 then
                M.process_focus_gained()
            end
        end
    })
end

return M
