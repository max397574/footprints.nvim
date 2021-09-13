local api = vim.api
local M = {}

local settings = {}

function M.add_highlights(changes)
  local buffer_nr = api.nvim_get_current_buf()
  for s in changes:gmatch("[^\n]+") do
    local change_num = tonumber(string.sub(s,3,5))
    local line = tonumber(string.sub(s,6,11)) -- really big files will work
    if change_num == nil then
    elseif change_num > settings.change_step_size * 5 then
      api.nvim_buf_add_highlight(buffer_nr, -1, "Normal", line, 0, -1)
      print(s)
    elseif change_num > settings.change_step_size * 4 then
      api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine1", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 3 then
      api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine2", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 2 then
      api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine3", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 1 then
      api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine4", line-1, 0, -1)
    else
      api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine5", line-1, 0, -1)
    end
  end
end


settings.highlight_color_1 = "#000000"
settings.highlight_color_2 = "#2E2E2E"
settings.highlight_color_3 = "#616161"
settings.highlight_color_4 = "#969696"
settings.highlight_color_5 = "#A1A1A1"
settings.change_step_size = 1

function M.highlight_line()
  local buffer_nr = api.nvim_get_current_buf()
  local line_nr = api.nvim_win_get_cursor(0)[1]
  api.nvim_buf_add_highlight(buffer_nr, -1, "FootprintsLine", line_nr-1, 0, -1)
end


function M.setup(update)
  settings = setmetatable(update, { __index = settings })
end


local function create_autocmds()
  vim.cmd[[autocmd TextChangedI * lua require("footprints_nvim").add_highlights(vim.fn.execute("changes"))]]
  vim.cmd[[autocmd TextChanged * lua require("footprints_nvim").add_highlights(vim.fn.execute("changes"))]]
end

function M.init()
  vim.cmd("highlight FootprintsLine1 guibg=" .. settings.highlight_color_1)
  vim.cmd("highlight FootprintsLine2 guibg=" .. settings.highlight_color_2)
  vim.cmd("highlight FootprintsLine3 guibg=" .. settings.highlight_color_3)
  vim.cmd("highlight FootprintsLine4 guibg=" .. settings.highlight_color_4)
  vim.cmd("highlight FootprintsLine5 guibg=" .. settings.highlight_color_5)
  create_autocmds()
end

return M
