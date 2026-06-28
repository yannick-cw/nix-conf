{ pkgs, inputs, ... }:
{
  # merges all these modules to be configured here
  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./git.nix
    ./neovim.nix
    inputs.nix-index-database.homeModules.nix-index
  ]; 
  home = {
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      KORB_CURL = "curl_safari184_ios";
      NH_FLAKE = "/Users/yannickgladow/nix-config";
    };
    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
    ];
    packages = with pkgs; [
      jq
      k9s
      pandoc
      python311
      ripgrep
      sbt
      unar
      wget
      fd
      kubectx
      mermaid-cli
      nh
    ];
  };
  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  # merged from imports = []
  programs.nix-index-database.comma.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf.enable = true;
  programs.gh.enable = true;
}
