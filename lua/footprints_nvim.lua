local M = {}
local api = vim.api

local settings = {}

settings.highlight_color = "#A1A1A1"

function M.highlight_line()
  vim.cmd("highlight FootprintsLine guibg=" .. settings.highlight_color)
  local buffer_nr = api.nvim_get_current_buf()
  local line_nr = api.nvim_win_get_cursor(0)[1]
  api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine", line_nr-1, 0, -1)
end


function M.setup(update)
  settings = setmetatable(update, { __index = settings })
end


local function create_autocmds()
  vim.cmd[[autocmd InsertLeave * lua require("footprints_nvim").highlight_line()]]
end

function M.init()
  create_autocmds()
end

return M
