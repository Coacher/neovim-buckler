local M = {}

--- Stores the configured clipboard register name
---@type string
M.register = ''

--- Indicates whether the editor has clipboard support
---@type boolean
local has_clipboard = vim.fn.has('clipboard') == 1

--- Store the configured clipboard register name
function M.store_clipboard_name()
    if has_clipboard then
        local clipboard_option = vim.opt.clipboard:get()
        if vim.tbl_contains(clipboard_option, 'unnamedplus') then
            M.register = '+'
        elseif vim.tbl_contains(clipboard_option, 'unnamed') then
            M.register = '*'
        else
            M.register = ''
        end
    end
end

--- Check if the given name is the clipboard register name
---@param name string The register name to check
---@return boolean
function M.is_clipboard_register(name)
    return (name == M.register) or (name == '')
end

--- Setup function for the clipboard module
function M.setup()
    M.store_clipboard_name()

    vim.api.nvim_create_autocmd('OptionSet', {
        group = vim.api.nvim_create_augroup('buckler_store_clipboard_name', { clear = true }),
        pattern = 'clipboard',
        callback = function() M.store_clipboard_name() end
    })
end

return M
