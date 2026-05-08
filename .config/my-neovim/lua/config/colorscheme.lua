-- ~/.config/nvim/lua/config/colorscheme.lua

local M = {}

local state_file = vim.fn.stdpath("data") .. "/colorscheme.txt"

function M.save(name)
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

function M.load()
  local f = io.open(state_file, "r")
  if f then
    local name = f:read("*l")
    f:close()
    if name and name ~= "" then
      vim.cmd.colorscheme(name)
      return
    end
  end
  -- fallback default
  vim.cmd.colorscheme("habamax")
end

local function set_blink_highlights()
  local h = vim.api.nvim_set_hl
  -- doc popup: deep navy bg with bright border
  h(0, "BlinkCmpDoc",        { bg = "#1e2030", fg = "#c8d3f5" })
  h(0, "BlinkCmpDocBorder",  { fg = "#82aaff", bold = true })
  -- completion menu
  h(0, "BlinkCmpMenu",       { bg = "#1e2030", fg = "#c8d3f5" })
  h(0, "BlinkCmpMenuBorder", { fg = "#3d59a1" })
  h(0, "BlinkCmpMenuSelection", { bg = "#2d3f76", bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_blink_highlights,
})

-- Command to switch and persist
vim.api.nvim_create_user_command("MyTheme", function(opts)
  local name = opts.args
  vim.cmd.colorscheme(name)
  M.save(name)
end, {
  nargs = 1,
  complete = "color",  -- tab-completes installed colorschemes!
})

return M
