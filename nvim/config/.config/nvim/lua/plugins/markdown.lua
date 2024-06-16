return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    event = "BufRead",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
