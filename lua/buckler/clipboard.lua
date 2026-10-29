local M = {}

--- Stores the configured clipboard register names
---@type string[]
M.registers = {}

--- Indicates whether the editor has clipboard support
---@type boolean
local has_clipboard = vim.fn.has('clipboard') == 1

--- Store the configured clipboard register names
function M.store_clipboard_name()
    M.registers = {}
    if has_clipboard then
        local clipboard_option = vim.opt.clipboard:get()
        if vim.tbl_contains(clipboard_option, 'unnamedplus') then
            table.insert(M.registers, '+')
        end
        if vim.tbl_contains(clipboard_option, 'unnamed') then
            table.insert(M.registers, '*')
        end
    end
end

--- Get the primary clipboard register name
---@return string
function M.primary()
    return M.registers[1] or ''
end

--- Check if the given name is the clipboard or the unnamed register name
---@param name string The register name to check
---@return boolean
function M.is_clipboard_register(name)
    return vim.tbl_contains(M.registers, name) or (name == '') or (name == '"')
end

--- Setup function for the clipboard module
function M.setup()
    M.store_clipboard_name()
end

return M
