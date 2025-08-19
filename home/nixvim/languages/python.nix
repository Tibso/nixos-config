{
  programs.nixvim.plugins = {
    dap-python.enable = true;

    conform-nvim = {
      enable = true;
      settings = { formatters_by_ft.python = [ "black" ]; };
    };

    lsp.servers.pylsp = {
      enable = true;
      settings.plugins = {
        black.enabled = true;
        pycodestyle.enabled = true;
        pydocstyle.enabled = true;
        pyflakes.enabled = true;
        pylint.enabled = true;
        flake8.enabled = true;
        isort.enabled = true;
        rope.enabled = true;
        yapf.enabled = true;
        mccabe.enabled = true;
      };
    };
    none-ls.sources.formatting.black.enable = true;
  };
}
