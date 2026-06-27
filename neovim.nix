{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep  
      fzf     
    ];

    plugins = with pkgs.vimPlugins; [
      rose-pine

      fzf-Wrapper        
      fzf-vim          

      neo-tree-nvim
      plenary-nvim
      nui-nvim

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
