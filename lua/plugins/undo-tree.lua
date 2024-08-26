return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  event = "BufRead",
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
  },
  config = function()
    local undotree = require('undotree')

    undotree.setup {
      float_diff = false,
      position = 'left',
    }
  end
}
