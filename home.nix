{ pkgs, ... }:
{
  imports = [ ./ghostty.nix ./zsh.nix ./git.nix ];
  home = {
    stateVersion = "25.05"; 
    sessionVariables = { EDITOR = "nvim"; KORB_CURL = "curl_safari184_ios"; };
    sessionPath = [ "$HOME/bin" "$HOME/.local/bin" ];
    packages = with pkgs; [
      jq k9s pandoc python311 ripgrep sbt unar wget fd kubectx mermaid-cli  
      neovim        # config still in ~/.config/nvim (migrate to programs.neovim later)
    ];
  };
  programs.home-manager.enable = true;

  programs.fzf.enable = true;
  programs.gh.enable = true;   # installs gh + sets it as git credential helper
}
