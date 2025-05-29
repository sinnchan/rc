return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<a-j>", "<a-n>zz", remap = true },
    { "<a-k>", "<a-p>zz", remap = true },
  },
}
