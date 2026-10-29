local clipboard = require('buckler.clipboard')
local history = require('buckler.history')

local M = {}

--- Get a yank history item from the given register
---@param register string The register name
---@return BucklerHistoryItem
function M.get_reg(register)
    return history.item(vim.fn.getreg(register), vim.fn.getregtype(register))
end

--- Set the given register to the given yank history item
---@param register string The register name
---@param item BucklerHistoryItem The item to set
function M.set_reg(register, item)
    vim.fn.setreg(register, item.value, item.type)
end

--- Set the numbered registers from the yank history
function M.set_numbered_from_history()
    for idx = 0, 9 do
        M.set_reg(tostring(idx), history.get(idx))
    end
end

--- Set the unnamed and clipboard registers from the 0 register
function M.set_clipboard_from_zero()
    vim.fn.setreg('', { points_to = '0' })
    for _, register in ipairs(clipboard.registers) do
        M.set_reg(register, M.get_reg('0'))
    end
end

--- Push the numbered and clipboard registers to the yank history
--- Then update all the registers from the resulting yank history
function M.sync_history_with_registers()
    for idx = 9, 0, -1 do
        history.push(M.get_reg(tostring(idx)))
    end
    if #clipboard.registers > 0 then
        history.push(M.get_reg(clipboard.primary()))
    end
    M.set_numbered_from_history()
    M.set_clipboard_from_zero()
end

--- Setup function for the registers module
function M.setup()
    M.sync_history_with_registers()
end

return M
