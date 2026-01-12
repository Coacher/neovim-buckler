local clipboard = require('buckler.clipboard')
local history = require('buckler.history')
local registers = require('buckler.registers')
local visual = require('buckler.visual')

local M = {}

--- Process text yank event
function M.process_text_yank()
    local register = vim.v.event.regname
    local item = { value = vim.fn.getreg(register), type = vim.v.event.regtype }

    if clipboard.is_clipboard_register(register) then
        if string.lower(visual.char or '') ~= 'p' then
            history.push(item)
        end
        registers.set_numbered_from_history()
    elseif string.match(register, '%d') then
        local idx = tonumber(register)
        if history.count() > idx then
            history.set(idx, item)
        elseif idx == 0 then
            history.push(item)
        else
            vim.api.nvim_echo({ { '"' .. register .. ' may be cleared after next yank' } }, true, {})
        end
    end
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
