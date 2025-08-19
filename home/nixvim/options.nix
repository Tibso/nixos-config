{
  programs.nixvim.opts = {
    updatetime = 100; # faster completion

    number = true;
    #relativenumber = true;
    shiftround = true;
    shiftwidth = 2;
    tabstop = 2;
    cursorline = true;
    signcolumn = "yes";
    list = true;
    expandtab = true;
    autowrite = true;
    autoindent = true;
    smartcase = true;
    smartindent = true;
    confirm = true;

    clipboard = "unnamedplus";

    ignorecase = true;
    incsearch = true;
    completeopt = "menu,menuone,noselect";
    wildmode = "longest:full:full";

    swapfile = false;
    undofile = true; # Built-in persistent undo
    undolevels = 10000;
  };
}
