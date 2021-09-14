local api = vim.api
local M = {}

local settings = {}

settings.highlight_color_1 = "#000000"
settings.highlight_color_2 = "#2E2E2E"
settings.highlight_color_3 = "#616161"
settings.highlight_color_4 = "#969696"
settings.highlight_color_5 = "#A1A1A1"
settings.change_step_size = 1

function M.setup(update)
  settings = setmetatable(update, { __index = settings })
end

local function name_space()
  local ns = api.nvim_create_namespace("Footprints")
  api.nvim_set_hl(ns,"FootprintsLine1",{bg=settings.highlight_color_1})
  api.nvim_set_hl(ns,"FootprintsLine2",{bg=settings.highlight_color_2})
  api.nvim_set_hl(ns,"FootprintsLine3",{bg=settings.highlight_color_3})
  api.nvim_set_hl(ns,"FootprintsLine4",{bg=settings.highlight_color_4})
  api.nvim_set_hl(ns,"FootprintsLine5",{bg=settings.highlight_color_5})
  return ns
end

function M.add_highlights(changes)
  local ns_id = name_space()
  local buffer_nr = api.nvim_get_current_buf()
  for s in changes:gmatch("[^\n]+") do
    local change_num = tonumber(string.sub(s,3,5))
    local line = tonumber(string.sub(s,6,11)) -- really big files will work
    if change_num == nil then
    elseif change_num > settings.change_step_size * 5 then
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "Normal", line, 0, -1)
      print(s)
    elseif change_num > settings.change_step_size * 4 then
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "FootprintsLine1", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 3 then
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "FootprintsLine2", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 2 then
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "FootprintsLine3", line-1, 0, -1)
    elseif change_num > settings.change_step_size * 1 then
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "FootprintsLine4", line-1, 0, -1)
    else
      api.nvim_buf_add_highlight(buffer_nr, ns_id, "FootprintsLine5", line-1, 0, -1)
    end
    api.nvim__set_hl_ns(ns_id)
  end
end

local function create_autocmds()
  vim.cmd[[autocmd TextChangedI * lua require("footprints_nvim").add_highlights(vim.fn.execute("changes"))]]
  vim.cmd[[autocmd TextChanged * lua require("footprints_nvim").add_highlights(vim.fn.execute("changes"))]]
end

function M.init()
  create_autocmds()
end

return M
