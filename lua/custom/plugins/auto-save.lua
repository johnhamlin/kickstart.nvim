return {
  {
    "pocco81/auto-save.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- load the plugin for any editable buffer
    opts = {
      -- Save whenever the current buffer loses focus
      trigger_events = { "BufLeave" },
    },
  },
} 