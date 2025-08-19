{
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;

        #component_separators = {
        #  left = "|";
        #  right = "|";
        #};

        theme = "onedark";
      };

      sections = {
        lualine_a = [ "buffers" ];
        lualine_b = [ "branch" "diff" ];
        lualine_c = [ "" ];

        lualine_x = [ "diagnostics" "lsp_status" ];
        lualine_y = [ "progress" "location" ];
        lualine_z = [ "mode" ];
      };
    };
  };
}
