local clipboard = require('buckler.clipboard')
local history = require('buckler.history')
local registers = require('buckler.registers')
local visual = require('buckler.visual')

local M = {}

--- Process text yank event
function M.process_text_yank()
    local register = vim.v.event.regname
    local item = history.item(vim.fn.getreg(register), vim.v.event.regtype)

    if clipboard.is_clipboard_register(register) then
        -- Clipboard register is used
        if string.lower(visual.char or '') ~= 'p' then
            -- Real yank, push the item to the yank history
            history.push(item)
        end
    elseif string.match(register, '%d') then
        -- Numbered register is used
        local idx = tonumber(register)
        if history.count() > idx then
            -- Set the item in the yank history if it is present
            history.set(idx, item)
        elseif idx == 0 then
            -- 0 register is used and the yank history is empty,
            -- push the item to the yank history
            history.push(item)
        else
            -- Numbered register outside of the yank history is used,
            -- preserve the current valid history and show a warning
            vim.api.nvim_echo({ { 'Out-of-range yank history write attempt blocked' } }, true, {})
        end
    end
    registers.set_numbered_from_history()
    registers.set_clipboard_from_zero()
end

--- Setup function for the yank module
function M.setup()
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('buckler_process_yank', { clear = true }),
        callback = function() M.process_text_yank() end
    })
end

return M
