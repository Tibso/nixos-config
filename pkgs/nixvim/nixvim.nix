let
  readFolders = folder:
  let
    files = builtins.filter (file: builtins.match ".*\\.nix$" file != null)
      (builtins.attrNames (builtins.readDir folder));
  in
    map (file: import (folder + "/${file}")) files;

  allImports = readFolders ./plugins ++ readFolders ./languages;
in
{
    imports = [
      ./options.nix
      ./keybinds.nix
    ] ++ allImports;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    colorschemes = {
      onedark = {
        enable = true;
        settings = {
          style = "warmer";
          transparent = true;
        };
      };
    };

    diagnostic.settings.virtual_lines = true;

    plugins = {
      lsp.enable = true;
      #harpoon.enable = true;
      telescope.enable = true;
      #lazygit.enable = true;
      web-devicons.enable = true;
      #nvim-lightbulb.enable = true;
      #render-markdown.enable = true;
      nvim-autopairs.enable = true;
      trouble.enable = true;
      lsp-status.enable = true;
      #hop.enable = true;
      #tmux-navigator.enable = true;
    };

  #  extraConfigLua = ''
  #    local lsp_status = require('lsp-status')
  #    lsp_status.register_progress()

  #    vim.g.rustaceanvim = {
  #      server = {
  #        on_attach = function(client, bufnr)
  #          lsp_status.on_attach(client, bufnr)
  #        end,
  #        capabilities = lsp_status.capabilities,
  #      }
  #    }
  #  '';
  };
}
