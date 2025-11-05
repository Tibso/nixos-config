{
  programs.nixvim = {
    globals.mapleader = " ";

    plugins.which-key = {
      enable = true;
      settings = {};
    };

    keymaps = [
      {
        mode = "n";
        key = "<Space>";
        action = "<Nop>";
      }

      # FZF-Lua custom commands -- Limited to current directory
      {
        mode = "n";
        key = "<leader>ff";
        action = "<CMD>lua require('fzf-lua').files({ cwd = vim.loop.cwd() })<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<CMD>lua require('fzf-lua').oldfiles({ cwd = vim.loop.cwd() })<CR>";
        options.desc = "Recent Files";
      }

      # LSP Actions
      {
        mode = "n";
        key = "gd";
        action = "<CMD>FzfLua lsp_definitions jump1=true ignore_current_line=true<CR>";
        options.desc = "Goto Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<CMD>FzfLua lsp_references jump1=true ignore_current_line=true<CR>";
        options.desc = "References";
      }
      {
        mode = "n";
        key = "gI";
        action = "<CMD>FzfLua lsp_implementations jump1=true ignore_current_line=true<CR>";
        options.desc = "Goto Implementation";
      }
      {
        mode = "n";
        key = "gy";
        action = "<CMD>FzfLua lsp_typedefs jump1=true ignore_current_line=true<CR>";
        options.desc = "Goto T[y]pe Definition";
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = "<CMD>Trouble diagnostics toggle<CR>";
        options.desc = "List All Diagnostics";
      }

      # Buffer
      {
        mode = "n";
        key = "<S-h>";
        action = "<CMD>bprevious<CR>";
        options.desc = "Previous Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<CMD>bnext<CR>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bb";
        action = "<CMD>e #<CR>";
        options.desc = "Switch To Other Buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<CMD>bd<CR>";
        options.desc = "Delete Buffer and Window";
      }

      # DAP Telescope Actions
      # {
      #   mode = "n";
      #   key = "<leader>d/c";
      #   action = "<CMD>Telescope dap commands<CR>";
      #   options.desc = "Search Commands";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>d/b";
      #   action = "<CMD>Telescope dap list_breakpoints<CR>";
      #   options.desc = "Search Breakpoints";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>d/v";
      #   action = "<CMD>Telescope dap variables<CR>";
      #   options.desc = "Search Variables";
      # }
      # {
      #   mode = "n";
      #   key = "<leader>d/f";
      #   action = "<CMD>Telescope dap frames<CR>";
      #   options.desc = "Search Frames";
      # }
    ];
  };
}
