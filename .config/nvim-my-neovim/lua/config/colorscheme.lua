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
