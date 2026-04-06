-- Minimal Neovim config for C/C++, Rust, and Go with VS Code-like theme.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Core options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Smart window sizing
local autocmd = vim.api.nvim_create_autocmd

-- Intelligent split resizing
local smart_resize = function()
  local total_width = vim.o.columns
  local total_height = vim.o.lines
  local win_count = #vim.api.nvim_list_wins()
  
  if win_count <= 1 then
    return
  end
  
  -- Get layout information
  local win_id = vim.api.nvim_get_current_win()
  local win_config = vim.api.nvim_win_get_config(win_id)
  
  -- Check if we have vertical or horizontal splits
  local has_vertical_splits = false
  local has_horizontal_splits = false
  
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_pos = vim.fn.win_screenpos(win)
    if win ~= win_id then
      local other_pos = vim.fn.win_screenpos(win)
      if win_pos[1] ~= other_pos[1] then
        has_horizontal_splits = true
      end
      if win_pos[2] ~= other_pos[2] then
        has_vertical_splits = true
      end
    end
  end
  
  -- Handle vertical splits
  if has_vertical_splits then
    if win_count == 2 then
      local optimal_width = math.floor((total_width - 2) / 2)
      vim.cmd("vertical resize " .. optimal_width)
    else
      local optimal_width = math.floor((total_width - 4) / win_count)
      vim.cmd("vertical resize " .. optimal_width)
    end
  end
  
  -- Handle horizontal splits
  if has_horizontal_splits then
    local available_height = total_height - 3
    local optimal_height = math.floor(available_height / math.ceil(win_count / 2))
    
    if optimal_height > 8 then
      vim.cmd("resize " .. optimal_height)
    end
  end
end

autocmd("WinNew", {
  callback = smart_resize,
  desc = "Smart window resizing on new split"
})

autocmd("VimResized", {
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(100, 0, vim.schedule_wrap(function()
      smart_resize()
      vim.cmd("wincmd =")
      timer:close()
    end))
  end,
  desc = "Smart resize on terminal resize"
})

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "c", "cpp", "rust", "go", "lua", "vim", "vimdoc" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-ui-select.nvim", config = function()
        require("telescope").load_extension("ui-select")
      end },
    },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local open_file_horizontal = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("split")
        vim.cmd("edit " .. selection.value)
      end
      
      local open_file_vertical = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("vsplit")
        vim.cmd("edit " .. selection.value)
      end
      
      local open_file_left = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("topleft vsplit")
        vim.cmd("edit " .. selection.value)
      end
      
      local open_file_bottom = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("belowright split")
        vim.cmd("edit " .. selection.value)
      end
      
      local open_file_current = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. selection.value)
      end
      
      -- Create new file function
      local create_new_file = function(prompt_bufnr, direction)
        actions.close(prompt_bufnr)
        local filename = vim.fn.input("New file name: ")
        if filename ~= "" then
          if direction == "current" then
            vim.cmd("edit " .. filename)
          elseif direction == "horizontal" then
            vim.cmd("split " .. filename)
          elseif direction == "vertical" then
            vim.cmd("vsplit " .. filename)
          elseif direction == "left" then
            vim.cmd("topleft vsplit " .. filename)
          elseif direction == "bottom" then
            vim.cmd("belowright split " .. filename)
          end
        end
      end
      
      -- Create custom command - simplified
      vim.api.nvim_create_user_command("TelescopeFindFilesEnhanced", function(opts)
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        
        pickers.new(opts, {
          prompt_title = "Find Files (Enter=current, h=horizontal, v=vertical, l=left, j=bottom, n=new, d=delete)",
          finder = require("telescope.finders").new_oneshot_job({ "find", ".", "-type", "f" }, opts),
          sorter = conf.file_sorter(opts),
          attach_mappings = function(prompt_bufnr, map)
            local open_file = function(direction)
              local selection = action_state.get_selected_entry()
              if selection then
                actions.close(prompt_bufnr)
                if direction == "horizontal" then
                  vim.cmd("split")
                elseif direction == "vertical" then
                  vim.cmd("vsplit")
                elseif direction == "left" then
                  vim.cmd("topleft vsplit")
                elseif direction == "bottom" then
                  vim.cmd("belowright split")
                end
                vim.cmd("edit " .. selection.value)
              end
            end
            
            map("i", "<CR>", function() open_file("current") end)
            map("i", "h", function() open_file("horizontal") end)
            map("i", "v", function() open_file("vertical") end)
            map("i", "l", function() open_file("left") end)
            map("i", "j", function() open_file("bottom") end)
            map("i", "n", function()
              actions.close(prompt_bufnr)
              local filename = vim.fn.input("New file name: ")
              if filename ~= "" then
                vim.cmd("edit " .. filename)
              end
            end)
            map("i", "d", function()
              local selection = action_state.get_selected_entry()
              if selection then
                local filename = vim.fn.fnamemodify(selection.value, ":t")
                local confirm = vim.fn.confirm("Delete file '" .. filename .. "'?", "&Yes\n&No", 2)
                if confirm == 1 then
                  vim.fn.delete(selection.value)
                  vim.notify("Deleted: " .. filename, vim.log.levels.INFO)
                  actions.close(prompt_bufnr)
                  vim.cmd("TelescopeFindFilesEnhanced")
                end
              end
            end)
            map("i", "<Esc>", actions.close)
            return true
          end,
        }):find()
      end, {})
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        actions = { 
          open_file = { quit_on_open = false },
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          
          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)
          
          -- Custom mappings for smart splits
          vim.keymap.set('n', '<CR>', api.node.open.edit, { buffer = bufnr, desc = "Open" })
          vim.keymap.set('n', '<M-CR>', function()
            api.node.open.horizontal()
          end, { buffer = bufnr, desc = "Open horizontal split" })
          vim.keymap.set('n', '<C-CR>', function()
            api.node.open.vertical()
          end, { buffer = bufnr, desc = "Open vertical split" })
        end,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = { border = "rounded" },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        scope = { enabled = true },
        indent = { char = "│" },
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    lazy = false,
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          use_treesitter = false,
          notify = true,
          style = {
            { fg = "#e6c384" },
            { fg = "#e82424" },
          },
        },
        indent = { enable = false },
        line_num = { enable = false },
        blank = { enable = false },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "astyle" },
          cpp = { "astyle" },
          h = { "astyle" },
          hpp = { "astyle" },
          rust = { "rustfmt" },
          go = { "gofmt" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({})
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({})
    end,
  },

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neogit").setup({})
    end,
  },
  {
    "aikhe/wrapped.nvim",
    dependencies = { "nvzone/volt", "nvim-lua/plenary.nvim" },
    cmd = { "NvimWrapped" },
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "NvimTree", "toggleterm" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { 
            { "filename", path = 1 },
            { "diagnostics", sources = { "nvim_lsp" } }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
      })
    end,
  },
})

-- Navigation keymaps
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>TelescopeFindFilesEnhanced<cr>", { desc = "Find files with directions" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map("n", "<leader>t", "<cmd>Telescope<cr>", { desc = "Telescope menu" })

-- Code navigation shortcuts
map("n", "<leader>sf", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in current file" })
map("n", "<leader>sg", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
map("n", "<leader>sr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references" })
map("n", "<leader>sd", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>sw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>si", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find implementations" })
map("n", "<leader>sD", "<cmd>Telescope lsp_definitions<cr>", { desc = "Find definitions" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus project tree" })
map("n", "<leader>E", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle project tree" })

-- Window navigation with Alt+arrows
map("n", "<M-Left>", "<C-w>h", { desc = "Navigate left" })
map("n", "<M-Right>", "<C-w>l", { desc = "Navigate right" })
map("n", "<M-Up>", "<C-w>k", { desc = "Navigate up" })
map("n", "<M-Down>", "<C-w>j", { desc = "Navigate down" })

-- Smart split management
map("n", "<leader>ss", function()
  local total_height = vim.o.lines - 3
  vim.cmd("split")
  vim.cmd("resize " .. math.floor(total_height / 2))
end, { desc = "Smart horizontal split" })

map("n", "<leader>vv", function()
  local total_width = vim.o.columns - 2
  vim.cmd("vsplit")
  vim.cmd("vertical resize " .. math.floor(total_width / 2))
end, { desc = "Smart vertical split" })

map("n", "<leader>qc", "<cmd>close<cr>", { desc = "Close current window" })

-- Auto-resize all windows evenly
map("n", "<leader>ar", function()
  local win_count = #vim.api.nvim_list_wins()
  if win_count > 1 then
    vim.cmd("wincmd =")
  end
end, { desc = "Auto-resize all windows" })

-- Create new file
map("n", "<leader>nn", function()
  local filename = vim.fn.input("New file: ")
  if filename ~= "" then
    vim.cmd("edit " .. filename)
  end
end, { desc = "Create new file" })

-- Delete current file
map("n", "<leader>fd", function()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    vim.notify("No file to delete", vim.log.levels.WARN)
    return
  end
  
  local filename = vim.fn.fnamemodify(current_file, ":t")
  local confirm = vim.fn.confirm("Delete file '" .. filename .. "'?", "&Yes\n&No", 2)
  
  if confirm == 1 then
    vim.cmd("bdelete!")
    vim.fn.delete(current_file)
    vim.notify("Deleted: " .. filename, vim.log.levels.INFO)
  end
end, { desc = "Delete current file" })
map("n", "<leader>fm", function()
  require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Format buffer" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev git hunk" })
map("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
map("n", "<leader>nw", "<cmd>NvimWrapped<cr>", { desc = "Nvim Wrapped" })

-- Inlay hints toggle with debug info
map("n", "<leader>ih", function()
  local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
  local has_rust_analyzer = clients and #clients > 0
  local enabled = vim.lsp.inlay_hint.is_enabled()
  
  vim.notify(string.format("Rust analyzer: %s, Inlay hints: %s", 
    has_rust_analyzer and "yes" or "no", 
    enabled and "enabled" or "disabled"), vim.log.levels.INFO)
  
  vim.lsp.inlay_hint.enable(not enabled)
  local new_status = vim.lsp.inlay_hint.is_enabled()
  vim.notify("Inlay hints now: " .. (new_status and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle inlay hints with debug" })

-- Built-in LSP (Neovim 0.11+)
if vim.lsp and vim.lsp.config then
  -- Debug LSP setup
  vim.lsp.config("clangd", {})
  
  -- Simple rust-analyzer config for now
  vim.lsp.config("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
        cargo = {
          allFeatures = true
        },
        inlayHints = {
          enable = true
        }
      }
    }
  })
  
  vim.lsp.config("gopls", {})

  local servers = { "clangd", "rust_analyzer", "gopls" }
  local ok, err = pcall(vim.lsp.enable, servers)
  if not ok then
    vim.notify("LSP error: " .. err, vim.log.levels.ERROR)
  end
  
  -- LSP keymaps
  local lsp_map = function(bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, bufopts)
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, bufopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
  end
  
  -- Apply LSP keymaps when LSP attaches
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
      lsp_map(args.buf)
      
      if vim.bo[args.buf].filetype == "rust" then
        vim.lsp.inlay_hint.enable(true)
      end
    end,
  })
  
  -- Also enable when entering Rust buffer (fallback)
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("RustInlayHints", {}),
    pattern = "*.rs",
    callback = function()
      local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
      if clients and #clients > 0 then
        vim.lsp.inlay_hint.enable(true)
      end
    end,
  })
end
