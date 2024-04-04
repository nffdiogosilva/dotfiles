require("neo-tree.command").execute({ action = "close" })
-- return {
--   "nvim-neo-tree/neo-tree.nvim",
--   enabled = false,
-- }

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  opts = {
    window = {
      position = "right",
    },
  },
}
