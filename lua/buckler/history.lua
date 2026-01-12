local config = require('buckler.config')

local M = {}

---@class BucklerHistoryItem
---@field value string The yanked text content
---@field type string The type of the yanked content

--- Yank history storage
---@type BucklerHistoryItem[]
M.history = {}

--- Null entry constant
---@type BucklerHistoryItem
local null_entry = { value = '', type = '' }

--- Count the number of items in the yank history
---@return number
function M.count()
    return #M.history
end

--- Get an item from the yank history by index
---@param idx number|nil The index to retrieve (default 0)
---@return BucklerHistoryItem
function M.get(idx)
    return M.history[(idx or 0) + 1] or null_entry
end

--- Set an item in the yank history by index
---@param idx number The index to set
---@param item BucklerHistoryItem The item to store
function M.set(idx, item)
    M.history[idx + 1] = item
end

--- Push an item to the yank history maintaining its length
---@param item BucklerHistoryItem The item to push
function M.push(item)
    if item.value ~= '' and not vim.deep_equal(item, M.get()) then
        table.insert(M.history, 1, item)
        if M.count() > config.options.history_length then
            table.remove(M.history)
        end
    end
end

return M
