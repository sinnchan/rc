return {
  "CopilotC-Nvim/CopilotChat.nvim",
  lazy = false,
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    debug = true,
    show_help = "yes",
    prompts = {
      Explain = {
        prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
        mapping = '<leader>ce',
      },
      Review = {
        prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
        mapping = '<leader>cr',
      },
      Fix = {
        prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
        mapping = '<leader>cf',
      },
      Optimize = {
        prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
        mapping = '<leader>co',
      },
      Docs = {
        prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
        mapping = '<leader>cd',
      },
      Tests = {
        prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
        mapping = '<leader>ct',
      },
      Commit = {
        prompt =
        '実装差分に対するコミットメッセージを日本語で記述してください。',
        mapping = '<leader>cco',
      },
    },
  },
}
