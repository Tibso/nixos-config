{
  programs.nixvim.plugins = {
    #dap-python.enable = true;

    lsp.servers.pylsp = {
      enable = true;
      settings.plugins = {
        flake8.enabled = true;
        pycodestyle.enabled = false;
        pyflakes.enabled = false;
        rope.enabled = true;
      };
    };
  };
}
