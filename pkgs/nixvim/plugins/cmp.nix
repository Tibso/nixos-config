{
  programs.nixvim.plugins.cmp = {
    enable = true;

    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];

      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-e>" = "cmp.mapping.close()";
      };
    };
  };
}
