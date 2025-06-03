return {
  {
    'Olical/conjure',
    ft = { 'clojure', 'fennel', 'scheme', 'racket' }, -- etc
    lazy = true,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,
    -- NOTE: cmp-conjure is for nvim-cmp only and doesn't work with blink.cmp yet
    -- TODO: Look for blink.cmp integration for conjure in the future
  },
}
