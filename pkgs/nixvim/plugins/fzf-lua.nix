{
  programs.nixvim.plugins.fzf-lua = {
    enable = true;

    keymaps = {
      "<leader>/" = {
        action = "live_grep";
        options.desc = "Live Grep";
      };
      "<leader>," = {
        action = "buffers";
        options.desc = "Switch Buffer";
        settings = {
          sort_mru = true;
          sort_lastused = true;
        };
      };
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "Git Commits";
      };
      "<leader>gs" = {
        action = "git_status";
        options.desc = "Git Status";
      };
      "<leader>km" = {
        action = "keymaps";
        options.desc = "Key Maps";
      };
    };
  };
}
