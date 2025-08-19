{ pkgs, ... }: {
  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      settings = { formatters_by_ft.rust = [ "rustfmt" ]; };
    };

    rustaceanvim = {
      enable = true;
      settings = {
        dap.adapter = {
          command = "${pkgs.lldb}/bin/lldb-dap";
          type = "executable";
        };

        tools.enable_clippy = true;
        server = {
          default_settings = {
            rust-analyzer = {
              cargo.features = "all";
              check.command = "clippy";
            };
          };
        };
      };
    };
  };
}
