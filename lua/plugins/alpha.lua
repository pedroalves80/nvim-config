return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  commit = "dafa11a6218c2296df044e00f88d9187222ba6b0",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "",
      "",
      [[ ██▓███  ▓█████ ▓█████▄  ██▀███   ▒█████      ▄▄▄      ██▓  ██▒   █▓▓█████   ██████  ]],
      [[▓██░  ██▒▓█   ▀ ▒██▀ ██▌▓██ ▒ ██▒▒██▒  ██▒   ▒████▄    ▓██▒ ▓██░   █▒▓█   ▀ ▒██    ▒ ]],
      [[▓██░ ██▓▒▒███   ░██   █▌▓██ ░▄█ ▒▒██░  ██▒   ▒██  ▀█▄  ▒██░  ▓██  █▒░▒███   ░ ▓██▄   ]],
      [[▒██▄█▓▒ ▒▒▓█  ▄ ░▓█▄   ▌▒██▀▀█▄  ▒██   ██░   ░██▄▄▄▄██ ▒██░   ▒██ █░░▒▓█  ▄   ▒   ██▒]],
      [[▒██▒ ░  ░░▒████▒░▒████▓ ░██▓ ▒██▒░ ████▓▒░    ▓█   ▓██▒░██████▒▒▀█░  ░▒████▒▒██████▒▒]],
      [[▒▓▒░ ░  ░░░ ▒░ ░ ▒▒▓  ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░     ▒▒   ▓▒█░░ ▒░▓  ░░ ▐░  ░░ ▒░ ░▒ ▒▓▒ ▒ ░]],
      [[░▒ ░      ░ ░  ░ ░ ▒  ▒   ░▒ ░ ▒░  ░ ▒ ▒░      ▒   ▒▒ ░░ ░ ▒  ░░ ░░   ░ ░  ░░ ░▒  ░ ░]],
      [[░░          ░    ░ ░  ░   ░░   ░ ░ ░ ░ ▒       ░   ▒     ░ ░     ░░     ░   ░  ░  ░  ]],
      [[            ░  ░   ░       ░         ░ ░           ░  ░    ░  ░   ░     ░  ░      ░  ]],
      [[                 ░                                               ░                   ]],
      "",
      "",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    local function footer()
      return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end

    dashboard.section.footer.val = footer()

    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end
}
