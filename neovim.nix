{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      ripgrep
      fzf
      nixfmt
      nixd
    ];

    plugins = with pkgs.vimPlugins; [
      rose-pine

      fzf-wrapper
      fzf-vim

      neo-tree-nvim
      plenary-nvim
      nui-nvim

      nvim-lspconfig

      conform-nvim

      vim-surround
      vim-repeat
      vim-visual-star-search

      vim-polyglot
      vim-auto-save
      undotree
      lightline-vim
      nerdcommenter
      vim-gitgutter

      nvim-treesitter.withAllGrammars
      render-markdown-nvim
      nvim-web-devicons
      zen-mode-nvim
    ];

    extraConfig = builtins.readFile ./nvim/config.vim;
  };
}
