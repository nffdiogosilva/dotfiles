-- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

local function is_dir(path)
  local f = io.open(path, "r")

  if f ~= nil then
    local _, _, code = f:read(1)

    f:close()
    return code == 21
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if is_dir(vim.fn.argv(0)) then
      require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
    end
  end,
})

return {
  "nvim-telescope/telescope.nvim",
}
