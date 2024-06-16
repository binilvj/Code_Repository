-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vimtex key maps
return {
  "folke/which-key.nvim",
  optional = true,
  opts = {
    defaults = {
      ["<localLeader>l"] = { name = "+vimtex" },
    },
  },
}
