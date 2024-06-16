--require("tokyonight").setup({
--  -- use the night style
--  style = "storm",
--  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--  on_colors = function(colors)
--    colors.border = colors.cyan
--  end,
--})

return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "storm",
    on_colors = function(colors)
      colors.border = colors.cyan
    end,
  },
}
