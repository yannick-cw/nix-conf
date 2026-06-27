{ pkgs, ... }:
{
  home.username = "yannickgladow";
  home.homeDirectory = "/Users/yannickgladow";
  home.stateVersion = "25.05"; 
  programs.home-manager.enable = true;

  # start tiny to prove it works:
  home.packages = [ pkgs.ripgrep ];
}
